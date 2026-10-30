#!/bin/bash
# Obsidian Vault Backup – läuft stündlich über launchd.
# Sichert jeden Vault unter VAULTS_ROOT (Unterordner mit .obsidian) nach
# BACKUP_ROOT/<Name>/: Dateien ohne .git, gelöschte/überschriebene Dateien
# in Alte-Versionen/, die Git-Historie als eine Datei vault.bundle.
# Ein fehlerhafter Vault hält die anderen nicht auf.
set -Eeuo pipefail   # -E: ERR-Trap auch in Funktionen

CONFIG="${OVB_CONFIG:-$HOME/Library/Application Support/obsidian-vault-backup/config}"
LOG="${OVB_LOG:-$HOME/Library/Logs/obsidian-vault-backup.log}"
mkdir -p "$(dirname "$LOG")" 2>/dev/null || true

log() {
  local ts
  ts="$(date '+%Y-%m-%d %H:%M:%S')"
  echo "$ts $*" >>"$LOG" 2>/dev/null || true   # Log-Fehler dürfen nichts abbrechen
}

# alert <Titel> <Text> – Dialogfenster statt Mitteilung: macOS verwirft
# `display notification` aus Skripten oft still (keine Berechtigung).
# Läuft im Hintergrund, damit das Backup nicht auf „OK“ wartet. Die launchd-Plist
# braucht dafür AbandonProcessGroup (install.sh schreibt Plist und Skript immer
# gemeinsam). Schließt sich nach 1 Stunde selbst.
# Gibt 1 zurück, wenn kein Dialog gezeigt wurde: OVB_QUIET=1 (Testlauf in
# install.sh) oder es ist schon ein Obsidian-Backup-Dialog offen (kein Stapeln).
alert() {
  [[ "${OVB_QUIET:-}" == 1 ]] && return 1
  pgrep -f '^osascript .*display alert.*Obsidian-Backup' >/dev/null 2>&1 && return 1
  osascript -e 'on run argv' \
    -e 'display alert (item 1 of argv) message (item 2 of argv) as critical giving up after 3600' \
    -e 'end run' "$1" "$2" >/dev/null 2>&1 &
  disown || true
  return 0
}

# Am Ende jedes Fehlerdialogs: Log-Pfad + Hinweis, wie man Hilfe bekommt
DETAILS="Details: ~/Library/Logs/obsidian-vault-backup.log"$'\n\n'"So bekommst du Hilfe: Mach ein Bildschirmfoto dieses Fensters (⇧⌘4, dann Leertaste und auf das Fenster klicken) und gib es Claude (Claudian in Obsidian) mit der Bitte, den Fehler zu prüfen."

fail() {
  log "FEHLER: $1"
  # shellcheck disable=SC2310  # gewollt: kein Dialog ist hier kein Fehler
  alert "Obsidian-Backup fehlgeschlagen" "$1"$'\n\n'"$DETAILS" || true
  exit 1
}

trap 'fail "Unerwarteter Fehler in Zeile $LINENO"' ERR

[[ -f "$CONFIG" ]] || fail "Konfiguration fehlt: $CONFIG"
VAULTS_ROOT="" BACKUP_ROOT="" KEEP_DAYS=90
# shellcheck source=/dev/null
source "$CONFIG"   # setzt VAULTS_ROOT, BACKUP_ROOT, KEEP_DAYS
[[ -n "$VAULTS_ROOT" && -n "$BACKUP_ROOT" ]] || fail "Konfiguration unvollständig: $CONFIG"
[[ -d "$VAULTS_ROOT" ]] || fail "Vault-Ordner nicht gefunden: $VAULTS_ROOT"
mkdir -p "$BACKUP_ROOT"

# Nicht doppelt laufen (z. B. Login + Intervall gleichzeitig)
LOCK="$BACKUP_ROOT/.backup.lock"
# Sperre älter als 2 Stunden = Überbleibsel eines Absturzes → entfernen
find "$LOCK" -maxdepth 0 -mmin +120 -exec rmdir {} \; 2>/dev/null || true
if ! mkdir "$LOCK" 2>/dev/null; then
  log "Übersprungen: Backup läuft bereits"
  exit 0
fi
trap 'rmdir "$LOCK" 2>/dev/null || true' EXIT
trap 'exit 1' TERM INT HUP   # auch beim Abbruch (z. B. launchctl bootout) Sperre freigeben

STAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
REASON=""   # Fehlergrund des zuletzt gesicherten Vaults
HINTS=()       # Hinweise, gesammelt für einen Dialog am Ende
HINT_MARKS=()  # deren Markierungsdateien

# hinted_today <Markierung> – wahr, wenn der Hinweis in den letzten 24 h gezeigt wurde.
# Ohne Befehlsersetzung, die fehlschlagen kann (set -E würde sonst fail() auslösen).
hinted_today() {
  [[ -e "$1" ]] || return 1
  local now mtime
  now="$(date +%s)"; mtime="$(stat -f %m "$1")"
  (( now - mtime < 86400 ))
}

# backup_vault <Vault-Pfad> – gibt 1 zurück und setzt REASON bei Fehler.
# Läuft im if-Kontext (dort greift set -e nicht), daher prüft jeder Schritt selbst.
backup_vault() {
  local vault="$1" name dest tmp
  name="$(basename "$vault")"
  dest="$BACKUP_ROOT/$name"
  mkdir -p "$dest/vault" "$dest/Alte-Versionen" || { REASON="Backup-Ordner nicht anlegbar"; return 1; }

  # 1. Dateien kopieren. Gelöschte/überschriebene Dateien → Alte-Versionen/<Zeit>/
  # Exit 24 = Dateien verschwanden während des Kopierens (Obsidian/Claudian
  # arbeiten parallel) – normal, kein Fehler.
  local rc=0
  /usr/bin/rsync -a --delete \
    --backup --backup-dir="$dest/Alte-Versionen/$STAMP" \
    --exclude='.git/' \
    --exclude='.DS_Store' \
    --exclude='.obsidian/workspace*.json' \
    "$vault/" "$dest/vault/" 2>>"$LOG" || rc=$?
  if ((rc == 24)); then
    log "Hinweis $name: Dateien während des Kopierens geändert (rsync 24) – ok"
  elif ((rc != 0)); then
    REASON="Kopieren fehlgeschlagen (rsync $rc)"; return 1
  fi

  # 2. Git-Historie als eine Datei (erst fertig schreiben, dann ersetzen)
  # shellcheck disable=SC2310  # gewollt: hinted_today im elif ist die Bedingung
  if git -C "$vault" rev-parse --verify --quiet HEAD >/dev/null 2>&1; then
    # Nur neu schreiben, wenn sich Commits/Branches geändert haben – sonst lädt
    # Google Drive die ganze Historie jede Stunde erneut hoch.
    local refs=""
    refs="$(git -C "$vault" show-ref 2>/dev/null)" || refs=""
    if [[ ! -f "$dest/vault.bundle" || "$refs" != "$(cat "$dest/.bundle-refs" 2>/dev/null || true)" ]]; then
      tmp="$dest/.vault.bundle.tmp"
      if ! git -C "$vault" bundle create "$tmp" --all >/dev/null 2>&1; then
        rm -f "$tmp"; REASON="Git-Bundle konnte nicht erstellt werden"; return 1
      fi
      mv -f "$tmp" "$dest/vault.bundle" || { REASON="Git-Bundle nicht ersetzbar"; return 1; }
      printf '%s' "$refs" >"$dest/.bundle-refs"
    fi
    rm -f "$dest/.hinweis-ohne-git"
  elif ! hinted_today "$dest/.hinweis-ohne-git"; then
    # Vault ohne Git: Dateien sind gesichert, Historie fehlt. Höchstens einmal
    # pro Tag melden; die Markierung setzt erst der gezeigte Dialog (unten).
    log "HINWEIS $name: kein Git – install.sh erneut ausführen"
    HINTS+=("Vault ohne Git: $name – bitte install.sh erneut ausführen (oder Claude darum bitten).")
    HINT_MARKS+=("$dest/.hinweis-ohne-git")
  fi

  # 3. Alte Versionen nach KEEP_DAYS Tagen aufräumen
  find "$dest/Alte-Versionen" -mindepth 1 -maxdepth 1 -type d \
    -mtime +"${KEEP_DAYS:-90}" -exec rm -rf {} + 2>/dev/null || true
  return 0
}

COUNT=0
FAILED=()
for dot in "$VAULTS_ROOT"/*/.obsidian; do
  [[ -d "$dot" ]] || continue   # kein Treffer oder kein Vault
  vault="$(dirname "$dot")"
  name="$(basename "$vault")"
  COUNT=$((COUNT + 1))
  # shellcheck disable=SC2310  # gewollt: Fehler eines Vaults sammeln statt abbrechen
  if backup_vault "$vault"; then
    log "OK $name"
  else
    log "FEHLER $name: $REASON"
    FAILED+=("$name")
  fi
done

# Ein Dialog am Ende: Abschnitte durch Leerzeilen getrennt, immer mit DETAILS
BODY=""
add() { BODY+="${BODY:+$'\n\n'}$1"; }
if ((${#FAILED[@]} > 0)); then
  LIST="$(printf '%s, ' "${FAILED[@]}")"
  LIST="${LIST%, }"
  log "FERTIG mit Fehlern: $LIST"
  add "Betroffen: $LIST"
fi
for h in ${HINTS[@]+"${HINTS[@]}"}; do add "$h"; done

if [[ -n "$BODY" ]]; then
  add "$DETAILS"
  TITLE="Obsidian-Backup"
  ((${#FAILED[@]} == 0)) || TITLE="Obsidian-Backup fehlgeschlagen"
  # Hinweise gelten erst als gemeldet, wenn der Dialog wirklich erschien
  # shellcheck disable=SC2310  # gewollt: Rückgabewert prüfen
  if alert "$TITLE" "$BODY"; then
    for m in ${HINT_MARKS[@]+"${HINT_MARKS[@]}"}; do touch "$m"; done
  fi
  ((${#FAILED[@]} == 0)) || exit 1
fi

((COUNT > 0)) || log "HINWEIS: keine Vaults in $VAULTS_ROOT"
log "FERTIG: $COUNT Vault(s) gesichert"
