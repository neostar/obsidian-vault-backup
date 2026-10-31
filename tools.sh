#!/bin/bash
# shellcheck disable=SC1111,SC2310  # deutsche Anführungszeichen gewollt; Funktionen in Bedingungen gewollt
# Installiert die Werkzeuge aus dem Brewfile im Hintergrund – der Chat bleibt frei.
# Verwendung:
#   ./tools.sh start          startet die Installation und kehrt sofort zurück
#   ./tools.sh status         läuft / fertig / Fehler, mit dem aktuellen Paket
# Exit-Codes von status: 0 fertig, 1 Fehler, 3 läuft noch, 4 nicht gestartet.
# Nach Erfolg schaltet es die tägliche Aktualisierung ein (brew autoupdate).
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/bg.sh
source "$HERE/lib/bg.sh"
bg_init tools

BREW="${OVS_BREW:-}"   # OVS_BREW nur für Tests
for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -z "$BREW" ]] || break
  [[ -x "$b" ]] && { BREW="$b"; break; }
done

report() {
  local st=0 n total now
  bg_state || st=$?
  case "$st" in
    0) echo "✅ Werkzeuge fertig installiert." ;;
    1) echo "❌ Installation mit Fehler beendet. Letzte Zeilen aus $BG_LOG:"; tail -20 "$BG_LOG" ;;
    3)
      n="$(grep -cE '^(Installing|Using|Upgrading) ' "$BG_LOG" 2>/dev/null || true)"
      total="$(grep -cE '^(brew|tap) ' "$HERE/Brewfile" || true)"   # bundle meldet auch Taps mit „Using“
      now="$(grep -E '^(Installing|Upgrading|Using|==> (Fetching|Pouring|Downloading))' "$BG_LOG" 2>/dev/null | tail -1 || true)"
      echo "⏳ Läuft noch – ${now:-startet …} (${n:-0} von $total Paketen erledigt)" ;;
    *) echo "Nicht gestartet (oder abgebrochen). Starten mit: bash \"$HERE/tools.sh\" start" ;;
  esac
  return "$st"
}

case "${1:-status}" in
  start)
    [[ -n "$BREW" ]] || { echo "❌ Homebrew fehlt – erst setup-homebrew.sh im Terminal ausführen." >&2; exit 1; }
    if bg_running; then report || true; exit 0; fi
    bg_start /bin/bash "$HERE/tools.sh" _run "$BREW"   # über bash: läuft auch ohne Ausführungsrecht
    echo "⏳ Installation läuft im Hintergrund (Protokoll: $BG_LOG)."
    ;;
  _run)   # der eigentliche Auftrag, läuft im Hintergrund
    # Ältere Einrichtungen: der frühere offizielle Tap blockiert brew („Refusing automatic redirect“)
    taps="$("$2" tap)"
    if [[ $'\n'"$taps"$'\n' == *$'\n'homebrew/autoupdate$'\n'* ]]; then "$2" untap homebrew/autoupdate; fi
    "$2" bundle --file "$HERE/Brewfile"
    # Inoffizieller Tap: Homebrew führt seinen Befehl erst nach brew trust aus. Freigabe nur,
    # wenn der Tap von der im Brewfile festgelegten Adresse stammt.
    remote="$("$2" tap-info --json domt4/autoupdate | sed -n '/"remote":/{s/.*"remote": *"\([^"]*\)".*/\1/p;q;}')"
    r="$(printf '%s' "$remote" | tr '[:upper:]' '[:lower:]')"   # bash 3.2 kennt ${x,,} nicht
    r="${r%/}"; r="${r%.git}"
    case "$r" in
      git@github.com:*) r="https://github.com/${r#git@github.com:}" ;;
      ssh://git@github.com/*) r="https://github.com/${r#ssh://git@github.com/}" ;;
      *) ;;
    esac
    if [[ "$r" != "https://github.com/domt4/homebrew-autoupdate" ]]; then
      echo "❌ domt4/autoupdate stammt von unerwarteter Adresse (${remote:-unbekannt}) – nicht freigegeben, keine tägliche Aktualisierung." >&2
      exit 1
    fi
    "$2" trust --command domt4/autoupdate/autoupdate
    # start bricht ab, wenn der Job schon geladen ist – erneuter Lauf von tools.sh soll gelingen
    if ! launchctl list com.github.domt4.homebrew-autoupdate >/dev/null 2>&1; then
      "$2" autoupdate start 1d --upgrade --cleanup --leaves-only
    fi
    ;;
  status) report ;;
  *) echo "Verwendung: $0 start | status" >&2; exit 2 ;;
esac
