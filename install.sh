#!/bin/bash
# shellcheck disable=SC1111  # deutsche Anführungszeichen „…“ sind gewollt
# Einrichtung: Git in jedem Vault unter dem Stammordner + stündliches Backup.
# Verwendung:  ./install.sh ["/Pfad/zum/Stammordner"] [Backup-Ordner]
# Standard-Stammordner: ~/Obsidian Vaults    Standard-Backup-Ordner: ~/Obsidian-Backup
# Kann gefahrlos erneut ausgeführt werden – neue Vaults bekommen dann Git.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$HOME/Library/Application Support/obsidian-vault-backup"
LABEL="com.obsidian-vault-backup"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
LOG="$HOME/Library/Logs/obsidian-vault-backup.log"

die()  { echo "❌ $*" >&2; exit 1; }
ok()   { echo "✅ $*"; }
warn() { echo "⚠️  $*"; }

# --- Eingaben --------------------------------------------------------------
# Ohne Argumente gelten die Werte der bestehenden Installation, sonst die
# Standardordner – so verstellt ein erneuter Lauf (neuer Vault) nichts.
OLD_ROOT="" OLD_BACKUP="" KEEP_DAYS=90
if [[ -f "$APP_DIR/config" ]]; then
  # shellcheck disable=SC2016  # $1 und die Variablen expandiert erst die neue Shell
  OLD_CFG="$(/bin/bash -c 'source "$1"; printf "%s\n%s\n%s" "${VAULTS_ROOT:-}" "${BACKUP_ROOT:-}" "${KEEP_DAYS:-90}"' _ "$APP_DIR/config")" || OLD_CFG=""
  { IFS= read -r OLD_ROOT; IFS= read -r OLD_BACKUP; IFS= read -r KEEP_DAYS; } <<<"$OLD_CFG" || true
fi
VAULTS_ROOT="${1:-${OLD_ROOT:-$HOME/Obsidian Vaults}}"
BACKUP_ROOT="${2:-${OLD_BACKUP:-$HOME/Obsidian-Backup}}"
[[ "$KEEP_DAYS" =~ ^[0-9]+$ ]] || KEEP_DAYS=90

# abs <Pfad> – absolut, ohne Schrägstrich am Ende; vorhandene Ordner mit
# aufgelösten Symlinks (ein Link nach iCloud soll die Prüfung nicht umgehen)
abs() {
  local p="${1%/}"
  [[ "$p" == /* ]] || p="$PWD/$p"
  if [[ -d "$p" ]]; then (cd "$p" && pwd -P); else printf '%s' "$p"; fi
}
VAULTS_ROOT="$(abs "$VAULTS_ROOT")"
BACKUP_ROOT="$(abs "$BACKUP_ROOT")"

if [[ -d "$VAULTS_ROOT/.obsidian" ]]; then
  die "Das ist ein einzelner Vault, nicht der Stammordner:
   $VAULTS_ROOT
   Bitte den Ordner angeben, in dem die Vaults liegen (z. B. ~/Obsidian Vaults)."
fi

# --- Prüfungen -------------------------------------------------------------
# check_location <Pfad> <Bezeichnung> – keine Cloud-Ordner, nicht Dokumente/
# Schreibtisch (iCloud-Sync; der Hintergrund-Job hat dort oft keinen Zugriff)
check_location() {
  case "$1" in
    "$HOME/Library/CloudStorage/"*|"$HOME/Library/Mobile Documents/"*)
      die "$2 liegt in einem Cloud-Ordner (iCloud/Google Drive/Dropbox): $1
   Bitte einen lokalen Ordner verwenden, z. B. ~/Obsidian Vaults bzw. ~/Obsidian-Backup." ;;
    "$HOME/Documents"|"$HOME/Documents/"*|"$HOME/Desktop"|"$HOME/Desktop/"*)
      die "$2 liegt in Dokumente/Schreibtisch – oft von iCloud synchronisiert, und der
   Hintergrund-Job darf dort nicht lesen: $1" ;;
    "$HOME"|"$HOME/Library"|"/") die "$2 kann nicht $1 sein." ;;
    *) ;;
  esac
}
check_location "$VAULTS_ROOT" "Der Vault-Ordner"
check_location "$BACKUP_ROOT" "Der Backup-Ordner"
case "$BACKUP_ROOT/" in
  "$VAULTS_ROOT/"*) die "Der Backup-Ordner darf nicht im Vault-Ordner liegen." ;;
  *) ;;
esac
case "$VAULTS_ROOT/" in
  "$BACKUP_ROOT/"*) die "Der Vault-Ordner darf nicht im Backup-Ordner liegen." ;;
  *) ;;
esac

# Ein Stammordner pro Mac – nicht still einen anderen ersetzen
if [[ -n "$OLD_ROOT" && "$OLD_ROOT" != "$VAULTS_ROOT" && -d "$OLD_ROOT" ]]; then
  die "Auf diesem Mac werden bereits die Vaults in einem anderen Ordner gesichert:
   $OLD_ROOT
   Neue Vaults bitte dort hineinlegen und install.sh ohne Argumente erneut ausführen."
fi
if [[ -n "$OLD_BACKUP" && "$OLD_BACKUP" != "$BACKUP_ROOT" ]]; then
  warn "Backup-Ordner ändert sich: $OLD_BACKUP → $BACKUP_ROOT
   Den neuen Ordner in Google Drive („My Mac“) verknüpfen."
fi

mkdir -p "$VAULTS_ROOT" "$BACKUP_ROOT"
VAULTS_ROOT="$(abs "$VAULTS_ROOT")"
BACKUP_ROOT="$(abs "$BACKUP_ROOT")"
# Erneut prüfen: erst jetzt sind Symlinks in übergeordneten Ordnern aufgelöst
check_location "$VAULTS_ROOT" "Der Vault-Ordner"
check_location "$BACKUP_ROOT" "Der Backup-Ordner"

/usr/bin/git --version >/dev/null 2>&1 \
  || die "Git fehlt. Bitte im Terminal 'xcode-select --install' ausführen und danach erneut starten."

ok "Vault-Ordner: $VAULTS_ROOT"
ok "Backup-Ordner: $BACKUP_ROOT"

# --- Git pro Vault -----------------------------------------------------------
FULL_NAME="$(id -F 2>/dev/null)" || FULL_NAME="$USER"
HOST="$(scutil --get LocalHostName 2>/dev/null)" || HOST="mac"

setup_git() {
  local v="$1"
  if [[ ! -d "$v/.git" ]]; then
    git -C "$v" init -q -b main
    echo "     Git-Repository angelegt"
  fi
  if [[ ! -f "$v/.gitignore" ]]; then
    cp "$HERE/gitignore.template" "$v/.gitignore"
    echo "     .gitignore angelegt (Anhänge, CAD-, Office- und Videodateien ausgeschlossen)"
  else
    # Bestehende .gitignore behalten, fehlende Regeln aus der Vorlage anhängen
    local line added=0
    while IFS= read -r line; do
      [[ -z "$line" || "$line" == \#* ]] && continue
      grep -qxF -- "$line" "$v/.gitignore" && continue
      ((added == 0)) && printf '\n# Ergänzt von obsidian-vault-setup\n' >>"$v/.gitignore"
      printf '%s\n' "$line" >>"$v/.gitignore"
      added=$((added + 1))
    done <"$HERE/gitignore.template"
    ((added == 0)) || echo "     .gitignore um $added Regeln ergänzt"
  fi
  git -C "$v" config user.name >/dev/null || git -C "$v" config user.name "$FULL_NAME"
  git -C "$v" config user.email >/dev/null || git -C "$v" config user.email "$USER@$HOST.local"
  # Automatische Commits alle 10 Minuten: nicht signieren (sonst fragt z. B. 1Password jedes Mal)
  git -C "$v" config commit.gpgsign false
  if ! git -C "$v" rev-parse --verify --quiet HEAD >/dev/null; then
    git -C "$v" add -A
    git -C "$v" commit -q -m "Erster Stand"
    echo "     Erster Commit erstellt"
  fi
}

COUNT=0
for dot in "$VAULTS_ROOT"/*/.obsidian; do
  [[ -d "$dot" ]] || continue
  vault="$(dirname "$dot")"
  ok "Vault: $(basename "$vault")"
  setup_git "$vault"
  COUNT=$((COUNT + 1))
done
((COUNT > 0)) || warn "Noch keine Vaults in $VAULTS_ROOT – das Backup sichert sie, sobald sie dort liegen."

# --- Backup-Job installieren -------------------------------------------------
mkdir -p "$APP_DIR" "$HOME/Library/LaunchAgents" "$(dirname "$LOG")"
cp "$HERE/backup.sh" "$APP_DIR/backup.sh"
chmod +x "$APP_DIR/backup.sh"

cat >"$APP_DIR/config" <<EOF
VAULTS_ROOT=$(printf '%q' "$VAULTS_ROOT")
BACKUP_ROOT=$(printf '%q' "$BACKUP_ROOT")
KEEP_DAYS=$KEEP_DAYS
EOF

cat >"$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>$APP_DIR/backup.sh</string>
  </array>
  <key>StartInterval</key><integer>3600</integer>
  <key>RunAtLoad</key><true/>
  <key>LowPriorityIO</key><true/>
  <key>AbandonProcessGroup</key><true/>
  <key>ProcessType</key><string>Background</string>
  <key>StandardErrorPath</key><string>$LOG</string>
</dict>
</plist>
EOF
plutil -lint "$PLIST" >/dev/null || die "Fehler in $PLIST"

# --- Testlauf (vor dem Laden des Jobs, sonst kollidiert er mit RunAtLoad) ---
DOMAIN="gui/$(id -u)"
launchctl bootout "$DOMAIN/$LABEL" 2>/dev/null || true
if OVB_QUIET=1 /bin/bash "$APP_DIR/backup.sh"; then
  ok "Testlauf erfolgreich ($COUNT Vault(s)): $BACKUP_ROOT"
else
  die "Testlauf fehlgeschlagen – siehe $LOG"
fi

# Direkt nach bootout meldet launchd gelegentlich „Input/output error“ – kurz warten, einmal wiederholen
if ! launchctl bootstrap "$DOMAIN" "$PLIST" 2>/dev/null; then
  sleep 3
  launchctl bootstrap "$DOMAIN" "$PLIST" 2>/dev/null \
    || die "Der Hintergrund-Job ließ sich nicht starten.
   Systemeinstellungen → Allgemein → Anmeldeobjekte: Eintrag „bash“ erlauben,
   danach install.sh erneut ausführen."
fi
launchctl print "$DOMAIN/$LABEL" >/dev/null 2>&1 || die "Hintergrund-Job nicht geladen – install.sh erneut ausführen."
ok "Stündliches Backup eingerichtet"

cat <<EOF

Git und Backup sind eingerichtet.
Weiter:        für jeden Vault  vault-setup.sh "<Vault>"  (Obsidian-Plugins)
Online-Kopie:  $BACKUP_ROOT in Google Drive unter „My Mac“ verknüpfen (einmalig)
Neuer Vault:   in $VAULTS_ROOT ablegen, dieses Skript und vault-setup.sh erneut ausführen
Log:           tail "$LOG"
Entfernen:     $HERE/uninstall.sh
EOF
