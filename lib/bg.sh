# shellcheck shell=bash
# Hintergrund-Aufträge für Agent-Chats: Claudian sperrt den Chat, solange ein Befehl
# im Vordergrund läuft. Diese Helfer starten einen Auftrag in eigener Prozessgruppe,
# kehren sofort zurück und lassen den Stand später abfragen.
#   bg_init <name>          Zustandsdateien ~/Library/Logs/obsidian-vault-setup-<name>.{log,rc,pid}
#   bg_start <befehl> …     startet den Befehl; Exit-Code landet in BG_RC
#   bg_state                0 fertig, 1 Fehler, 3 läuft, 4 nicht gestartet
# Bewusst ohne Warten: Auch kurzes Warten im Agent-Turn sperrt in Claudian die Eingabe.

bg_init() {
  local s="$HOME/Library/Logs/obsidian-vault-setup-$1"
  mkdir -p "$HOME/Library/Logs"
  BG_LOG="$s.log" BG_RC="$s.rc" BG_PIDF="$s.pid"
}

bg_running() {
  local pid=""
  [[ -f "$BG_PIDF" ]] && pid="$(cat "$BG_PIDF" || true)"
  [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null
}

bg_start() {
  rm -f "$BG_RC"
  # set -m: eigene Prozessgruppe – so beendet das Agent-Werkzeug den Auftrag
  # nicht, wenn es den aufrufenden Befehl abschließt.
  set -m
  # shellcheck disable=SC2016  # $1/$@ expandiert erst die neue Shell
  nohup /bin/bash -c 'rc="$1"; shift; "$@"; echo $? >"$rc"' _ "$BG_RC" "$@" >"$BG_LOG" 2>&1 </dev/null &
  echo $! >"$BG_PIDF"
  set +m
}

bg_state() {
  if [[ -f "$BG_RC" ]]; then
    local rc
    rc="$(cat "$BG_RC" || true)"
    [[ "$rc" == "0" ]] && return 0
    return 1
  fi
  # shellcheck disable=SC2310
  bg_running && return 3
  return 4
}
