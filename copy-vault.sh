#!/bin/bash
# shellcheck disable=SC1111,SC2310  # deutsche Anführungszeichen gewollt; Funktionen in Bedingungen gewollt
# Kopiert Vaults im Hintergrund nach ~/Obsidian Vaults – der Chat bleibt frei.
# Liegen Dateien nur online (Google Drive, iCloud), lädt das Kopieren sie herunter;
# das kann bei langsamem Internet dauern. Das Original bleibt unverändert.
# Verwendung:
#   ./copy-vault.sh start "<alt>" "<neu>" ["<alt2>" "<neu2>" …]
#   ./copy-vault.sh status    Fortschritt: kopierte von insgesamt Dateien
#   ./copy-vault.sh wait [Sek.]
# Exit-Codes von status/wait: 0 fertig und vollständig, 1 Fehler oder unvollständig,
# 3 läuft noch, 4 nicht gestartet.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/bg.sh
source "$HERE/lib/bg.sh"
bg_init copy
PAIRS="$BG_LOG.paare"   # Zeilen: alt<TAB>neu<TAB>Dateianzahl des Originals

count() { find "$1" -type f 2>/dev/null | wc -l | tr -d ' '; }

report() {
  local st=0 done_n=0 total=0 alt neu n
  bg_state || st=$?
  if [[ -f "$PAIRS" ]]; then
    while IFS=$'\t' read -r alt neu n; do
      total=$((total + n))
      [[ -d "$neu" ]] && done_n=$((done_n + $(count "$neu")))
    done <"$PAIRS"
  fi
  case "$st" in
    0) echo "✅ Kopiert und geprüft: $done_n von $total Dateien." ;;
    1) echo "❌ Kopieren nicht vollständig ($done_n von $total Dateien). Letzte Zeilen aus $BG_LOG:"; tail -20 "$BG_LOG" ;;
    3) echo "⏳ Kopiert noch – $done_n von $total Dateien." ;;
    *) echo "Nicht gestartet (oder abgebrochen)." ;;
  esac
  return "$st"
}

case "${1:-status}" in
  start)
    shift
    (($# >= 2 && $# % 2 == 0)) || { echo "Verwendung: $0 start \"<alt>\" \"<neu>\" …" >&2; exit 2; }
    if bg_running; then report || true; exit 0; fi
    : >"$PAIRS"
    while (($#)); do
      alt="${1%/}" neu="${2%/}"
      shift 2
      [[ -d "$alt/.obsidian" ]] || { echo "❌ Kein Obsidian-Vault: $alt" >&2; exit 1; }
      [[ ! -e "$neu" ]] || { echo "❌ Ziel existiert schon: $neu – erst klären, was damit passieren soll." >&2; exit 1; }
      n="$(count "$alt")"
      printf '%s\t%s\t%s\n' "$alt" "$neu" "$n" >>"$PAIRS"
    done
    bg_start "$HERE/copy-vault.sh" _run
    echo "⏳ Kopieren läuft im Hintergrund (Protokoll: $BG_LOG)."
    report || true
    ;;
  _run)   # der eigentliche Auftrag, läuft im Hintergrund
    rc=0
    while IFS=$'\t' read -r alt neu n; do
      echo "Kopiere: $alt → $neu ($n Dateien)"
      mkdir -p "$(dirname "$neu")"
      ditto "$alt" "$neu" || { rc=1; continue; }
      have="$(count "$neu")"
      if [[ "$have" != "$n" ]]; then
        echo "Unvollständig: $neu hat $have von $n Dateien – im Original liegen Dateien vermutlich nur online."
        rc=1
      fi
    done <"$PAIRS"
    exit "$rc"
    ;;
  status) report ;;
  wait) bg_wait "${2:-60}" || true; report ;;
  *) echo "Verwendung: $0 start \"<alt>\" \"<neu>\" … | status | wait [Sekunden]" >&2; exit 2 ;;
esac
