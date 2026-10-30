# shellcheck shell=bash
# Gemeinsame Helfer für Skripte, die über die Obsidian CLI einen Vault steuern.
# Einbinden mit:  source "$HERE/lib/obsidian.sh"; dann  vault_init "/Pfad/zum/Vault"
# Setzt danach: VAULT (aufgelöster Pfad), NAME, VAULT_JS, OBS.

OBS="${OBSIDIAN_CLI:-/Applications/Obsidian.app/Contents/MacOS/obsidian}"

die()  { echo "❌ $*" >&2; exit 1; }
ok()   { echo "✅ $*"; }
warn() { echo "⚠️  $*"; }
json() { /usr/bin/python3 -I -c 'import json,sys;print(json.dumps(sys.stdin.read()))'; }

vault_init() {
  VAULT="${1:-}"
  [[ -n "$VAULT" ]] || die "Kein Vault angegeben."
  VAULT="${VAULT%/}"
  [[ -d "$VAULT/.obsidian" ]] || die "Kein Obsidian-Vault: $VAULT"
  VAULT="$(cd "$VAULT" && pwd -P)"   # -P: Obsidian meldet aufgelöste Pfade (/tmp → /private/tmp)
  # shellcheck disable=SC2034  # NAME nutzen die einbindenden Skripte
  NAME="$(basename "$VAULT")"
  VAULT_JS="$(printf '%s' "$VAULT" | json)"
  [[ -x "$OBS" ]] || die "Obsidian nicht gefunden: $OBS"
}

# js <Ausdruck> – wertet JavaScript im Vault aus, Ergebnis als Text in $R.
# Die CLI wählt den Vault über das Arbeitsverzeichnis; zusätzlich wird der Pfad
# geprüft (bei gleichnamigen Vaults träfe die CLI sonst evtl. den falschen).
# Läuft bewusst nicht in $(…), damit die Prüfung das Skript beenden kann.
# Die CLI liefert gelegentlich gar keine Ausgabe; jede Antwort trägt deshalb das
# Präfix „OK:“, und fehlt es, wird bis zu dreimal neu gefragt. Die Ausdrücke in
# den Skripten sind so geschrieben, dass eine Wiederholung nichts doppelt tut.
R=""
STRICT=1   # 0 nur beim Öffnen: dort ist ein anderer Vault noch erwartet
js() {
  local code out try
  code="app.vault.adapter.basePath !== $VAULT_JS ? 'FALSCHER VAULT: ' + app.vault.adapter.basePath : 'OK:' + String($1)"
  for try in 1 2 3; do
    out="$(cd "$VAULT" && "$OBS" eval code="$code" 2>&1 || true)"
    R="${out#=> }"
    case "$R" in
      OK:*) R="${R#OK:}"; return 0 ;;
      "FALSCHER VAULT"*)
        ((STRICT == 0)) || die "Obsidian zeigt einen anderen Vault: ${R#FALSCHER VAULT: }"
        return 0 ;;
      *) ((try < 3)) && sleep 1 ;;
    esac
  done
}

# wait_for <Ausdruck> <Sekunden> – wartet, bis der Ausdruck "true" ergibt
wait_for() {
  local i
  for ((i = 0; i < $2; i++)); do
    js "$1"
    [[ "$R" == "true" ]] && return 0
    sleep 1
  done
  return 1
}
