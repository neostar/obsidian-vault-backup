#!/bin/bash
# shellcheck disable=SC1111,SC2310  # deutsche Anführungszeichen gewollt; Funktionen in Bedingungen gewollt
# Installiert die Werkzeuge aus dem Brewfile im Hintergrund – der Chat bleibt frei.
# Verwendung:
#   ./tools.sh start          startet die Installation und kehrt sofort zurück
#   ./tools.sh status         läuft / fertig / Fehler, mit dem aktuellen Paket
#   ./tools.sh wait [Sek.]    wartet höchstens so lange (Standard 60), dann wie status
# Exit-Codes von status/wait: 0 fertig, 1 Fehler, 3 läuft noch, 4 nicht gestartet.
# Nach Erfolg schaltet es die tägliche Aktualisierung ein (brew autoupdate).
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
STATE="$HOME/Library/Logs/obsidian-vault-setup-tools"
LOG="$STATE.log" RC="$STATE.rc" PIDF="$STATE.pid"

BREW="${OVS_BREW:-}"   # OVS_BREW nur für Tests
for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -z "$BREW" ]] || break
  [[ -x "$b" ]] && { BREW="$b"; break; }
done

running() {
  local pid=""
  [[ -f "$PIDF" ]] && pid="$(cat "$PIDF" || true)"
  [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null
}

# Letzte aussagekräftige Zeile des Logs, z. B. „Installing pandoc“
current() {
  local line
  line="$(grep -E '^(Installing|Upgrading|Using|Fetching|==> (Fetching|Pouring|Downloading))' "$LOG" 2>/dev/null | tail -1 || true)"
  printf '%s' "${line:-startet …}"
}

status() {
  if [[ -f "$RC" ]]; then
    local rc
    rc="$(cat "$RC" || true)"
    if [[ "$rc" == "0" ]]; then
      echo "✅ Werkzeuge fertig installiert."
      return 0
    fi
    echo "❌ Installation mit Fehler beendet. Letzte Zeilen aus $LOG:"
    tail -20 "$LOG"
    return 1
  fi
  if running; then
    local n total now
    n="$(grep -cE '^(Installing|Using|Upgrading) ' "$LOG" 2>/dev/null || true)"
    total="$(grep -c '^brew ' "$HERE/Brewfile" || true)"
    now="$(current)"
    echo "⏳ Läuft noch – $now (${n:-0} von $total Paketen erledigt)"
    return 3
  fi
  echo "Nicht gestartet (oder abgebrochen). Starten mit: bash \"$HERE/tools.sh\" start"
  return 4
}

case "${1:-status}" in
  start)
    [[ -n "$BREW" ]] || { echo "❌ Homebrew fehlt – erst setup-homebrew.sh im Terminal ausführen." >&2; exit 1; }
    if running; then status || true; exit 0; fi
    rm -f "$RC"
    # set -m: eigener Prozessgruppe – so beendet das Agent-Werkzeug die Installation
    # nicht, wenn es den aufrufenden Befehl abschließt.
    set -m
    # shellcheck disable=SC2016  # $1…$3 expandiert erst die neue Shell
    nohup /bin/bash -c '
      "$1" bundle --file "$2"; rc=$?
      if [ "$rc" -eq 0 ]; then
        "$1" autoupdate start 1d --upgrade --cleanup --leaves-only || true
      fi
      echo "$rc" >"$3"' _ "$BREW" "$HERE/Brewfile" "$RC" >"$LOG" 2>&1 </dev/null &
    echo $! >"$PIDF"
    set +m
    echo "⏳ Installation läuft im Hintergrund (Protokoll: $LOG)."
    ;;
  status) status ;;
  wait)
    end=$((SECONDS + ${2:-60}))
    while [[ ! -f "$RC" ]] && running && ((SECONDS < end)); do sleep 5; done
    status
    ;;
  *) echo "Verwendung: $0 start | status | wait [Sekunden]" >&2; exit 2 ;;
esac
