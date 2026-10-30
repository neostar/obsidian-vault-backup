#!/bin/bash
# shellcheck disable=SC1111  # deutsche Anführungszeichen „…“ sind gewollt
# Richtet einen Vault in Obsidian ein – über die Obsidian CLI:
#   Community-Plugins (inkl. Claudian) installieren + aktivieren, Git-Plugin auf „nur Commit“,
#   Anhänge-Ordner „Attachments“, Agent-Vorlagen (CLAUDE.md, docs/agents/,
#   „Mit Claude arbeiten.md“), Symbole für Ordner und Notizen (Iconic).
# Verwendung:  ./vault-setup.sh "/Pfad/zum/Vault"
# Voraussetzung: Obsidian läuft, CLI ist aktiviert (Einstellungen → Allgemein).
# Kann gefahrlos erneut ausgeführt werden; Vorhandenes wird nicht überschrieben.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
OBS="${OBSIDIAN_CLI:-/Applications/Obsidian.app/Contents/MacOS/obsidian}"
# Reihenfolge: advanced-rename-and-delete-handler vor custom-attachment-location (Abhängigkeit)
PLUGINS=(obsidian-git obsidian-excalidraw-plugin excalidraw-extras iconic slash-commander obsidian-sort-and-permute-lines advanced-rename-and-delete-handler obsidian-custom-attachment-location realclaudian)
STORE="https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/community-plugins.json"

die()  { echo "❌ $*" >&2; exit 1; }
ok()   { echo "✅ $*"; }
warn() { echo "⚠️  $*"; }
json() { /usr/bin/python3 -I -c 'import json,sys;print(json.dumps(sys.stdin.read()))'; }

VAULT="${1:-}"
[[ -n "$VAULT" ]] || die "Verwendung: $0 \"/Pfad/zum/Vault\""
VAULT="${VAULT%/}"
[[ -d "$VAULT/.obsidian" ]] || die "Kein Obsidian-Vault: $VAULT"
VAULT="$(cd "$VAULT" && pwd -P)"   # -P: Obsidian meldet aufgelöste Pfade (/tmp → /private/tmp)
NAME="$(basename "$VAULT")"
VAULT_JS="$(printf '%s' "$VAULT" | json)"
[[ -x "$OBS" ]] || die "Obsidian nicht gefunden: $OBS"

# js <Ausdruck> – wertet JavaScript im Vault aus, Ergebnis als Text in $R.
# Die CLI wählt den Vault über das Arbeitsverzeichnis; zusätzlich wird der Pfad
# geprüft (bei gleichnamigen Vaults träfe die CLI sonst evtl. den falschen).
# Läuft bewusst nicht in $(…), damit die Prüfung das Skript beenden kann.
R=""
STRICT=1   # 0 nur beim Öffnen: dort ist ein anderer Vault noch erwartet
js() {
  local code out
  code="app.vault.adapter.basePath !== $VAULT_JS ? 'FALSCHER VAULT: ' + app.vault.adapter.basePath : String($1)"
  out="$(cd "$VAULT" && "$OBS" eval code="$code" 2>&1 || true)"
  R="${out#=> }"
  case "$R" in
    "FALSCHER VAULT"*) ((STRICT == 0)) || die "Obsidian zeigt einen anderen Vault: ${R#FALSCHER VAULT: }" ;;
    *) ;;
  esac
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

# --- Vault in Obsidian öffnen ----------------------------------------------------
if ! (cd "$VAULT" && "$OBS" version >/dev/null 2>&1); then
  die "Die Obsidian CLI antwortet nicht. Läuft Obsidian, und ist
   Einstellungen → Allgemein → „Command line interface“ eingeschaltet?"
fi
# Neue Vaults kennt Obsidian noch nicht (obsidian://open öffnet nur bekannte).
# „vault-open“ ist der Aufruf des Vault-Wechslers: registriert den Ordner und
# öffnet ihn in einem eigenen Fenster. Ausgeführt in irgendeinem offenen Vault.
# Die Antwort des Aufrufs ist unzuverlässig (manchmal leer, obwohl der Vault
# aufgeht) – maßgeblich ist, dass der Vault danach antwortet.
open_vault() {
  (cd "$HOME" && "$OBS" eval code="String(require('electron').ipcRenderer.sendSync('vault-open', $VAULT_JS, false))" >/dev/null 2>&1) || true
}
open_vault
STRICT=0
# shellcheck disable=SC2310  # gewollt: Zeitüberschreitung selbst melden
wait_for "true" 15 || { open_vault; wait_for "true" 30; } \
  || die "Vault ließ sich in Obsidian nicht öffnen: $VAULT
   Falls Obsidian fragt, ob du dem Vault vertraust: „Vertrauen“ klicken und erneut starten."
STRICT=1
ok "Vault geöffnet: $NAME"

# --- Community-Plugins -----------------------------------------------------------
js "app.plugins.isEnabled()"
if [[ "$R" != "true" ]]; then
  js "(app.plugins.setEnable(true), 'ok')"
  ok "Community-Plugins eingeschaltet (Eingeschränkter Modus aus)"
fi

STORE_JSON="$(curl -fsSL "$STORE")" || die "Plugin-Verzeichnis nicht erreichbar – Internetverbindung prüfen."
# Einmal auswerten: Zeilen „id repo“ für unsere Plugins
REPOS="$(printf '%s' "$STORE_JSON" | /usr/bin/python3 -I -c '
import json,sys
want=set(sys.argv[1:])
for p in json.load(sys.stdin):
    if p["id"] in want: print(p["id"], p["repo"])' "${PLUGINS[@]}")" || die "Plugin-Verzeichnis nicht lesbar."

for id in "${PLUGINS[@]}"; do
  js "!!app.plugins.manifests['$id']"
  if [[ "$R" != "true" ]]; then
    repo="$(printf '%s\n' "$REPOS" | /usr/bin/awk -v id="$id" '$1 == id { print $2 }')"
    [[ -n "$repo" ]] || die "Plugin nicht im Verzeichnis: $id"
    manifest="$(curl -fsSL "https://github.com/$repo/releases/latest/download/manifest.json")" \
      || die "Manifest nicht ladbar: $id ($repo)"
    version="$(printf '%s' "$manifest" | /usr/bin/python3 -I -c 'import json,sys;print(json.load(sys.stdin)["version"])')"
    js "(app.plugins.installPlugin('$repo', '$version', $manifest), 'gestartet')"
    # shellcheck disable=SC2310
    wait_for "!!app.plugins.manifests['$id']" 90 || die "Installation hängt: $id"
    ok "Installiert: $id $version"
  fi
  js "app.plugins.enabledPlugins.has('$id')"
  if [[ "$R" != "true" ]]; then
    js "(app.plugins.enablePluginAndSave('$id'), 'ok')"
    # shellcheck disable=SC2310
    wait_for "app.plugins.enabledPlugins.has('$id') && !!app.plugins.plugins['$id']" 30 \
      || die "Aktivieren fehlgeschlagen: $id"
  fi
done
ok "Plugins aktiv: ${PLUGINS[*]}"

# --- Einstellungen -----------------------------------------------------------------
# Git-Plugin: nur Commit alle 10 Minuten. Ohne Remote führt „commit-and-sync“
# zum Fehler „No upstream-branch is set“. Neustart des Plugins übernimmt die Timer.
# Hat der Vault schon ein Remote (z. B. GitHub-Sync zwischen Geräten), bleiben
# die Plugin-Einstellungen, wie sie sind.
REMOTES="$(git -C "$VAULT" remote 2>/dev/null || true)"
if [[ -n "$REMOTES" ]]; then
  warn "Vault hat ein Git-Remote ($REMOTES) – Git-Plugin-Einstellungen bleiben unverändert."
else
  # shellcheck disable=SC2310
  wait_for "!!app.plugins.plugins['obsidian-git']" 30 || die "Git-Plugin lädt nicht"
  # Erfolg erst melden, wenn Speichern und Neustart des Plugins durch sind
  js "(() => { window.__ovsGit = 'läuft'; const p = app.plugins.plugins['obsidian-git'];
    Object.assign(p.settings, {differentIntervalCommitAndPush: true, autoSaveInterval: 10,
      autoPushInterval: 0, autoPullInterval: 0, autoPullOnBoot: false,
      disablePush: true, pullBeforePush: false});
    p.saveSettings().then(() => app.plugins.disablePlugin('obsidian-git'))
      .then(() => app.plugins.enablePlugin('obsidian-git'))
      .then(() => { window.__ovsGit = 'fertig'; })
      .catch(e => { window.__ovsGit = 'Fehler: ' + e; });
    return 'ok'; })()"
  # shellcheck disable=SC2310
  wait_for "window.__ovsGit !== 'läuft'" 30 || die "Git-Plugin-Einstellungen: keine Rückmeldung"
  js "window.__ovsGit"
  [[ "$R" == "fertig" ]] || die "Git-Plugin-Einstellungen: $R"
  DATA="$VAULT/.obsidian/plugins/obsidian-git/data.json"
  /usr/bin/python3 -I -c 'import json,sys;d=json.load(open(sys.argv[1]));sys.exit(0 if d.get("differentIntervalCommitAndPush") is True and d.get("autoSaveInterval")==10 and d.get("disablePush") is True else 1)' "$DATA" \
    || die "Git-Plugin-Einstellungen nicht gespeichert: $DATA"
  ok "Git-Plugin: Commit alle 10 Minuten, kein Push/Pull"
fi

# --- Anhänge ordnen -----------------------------------------------------------------
# Custom Attachment Location: jede Notiz bekommt ihren Ordner unter Attachments/,
# gespiegelt zur Ordnerstruktur der Notizen; eingefügte Bilder heißen wie die Notiz.
# Advanced Rename and Delete Handler: Anhänge ziehen mit, wenn eine Notiz
# umbenannt oder verschoben wird. Löschen bleibt aus (nichts verschwindet still).
# plugin_settings <id> <Python-Code, der dict d anpasst> – nur bei Bedarf schreiben
plugin_settings() {
  local id="$1" data="$VAULT/.obsidian/plugins/$1/data.json" changed
  changed="$(/usr/bin/python3 -I - "$data" "$2" <<'PYEOF'
import json, os, sys
path, code = sys.argv[1], sys.argv[2]
d = json.load(open(path)) if os.path.exists(path) else {}
before = json.dumps(d, sort_keys=True)
exec(code)
print("ja" if json.dumps(d, sort_keys=True) != before else "")
PYEOF
)" || die "Einstellungen nicht lesbar: $id"
  [[ -n "$changed" ]] || return 0
  # Plugin aus, Datei schreiben, Plugin an – sonst überschreibt es die Datei
  js "(window.__ovsPl = 'läuft', app.plugins.disablePlugin('$id').then(() => { window.__ovsPl = 'aus'; }), 'ok')"
  # shellcheck disable=SC2310
  wait_for "window.__ovsPl === 'aus'" 20 || die "Plugin lässt sich nicht anhalten: $id"
  /usr/bin/python3 -I - "$data" "$2" <<'PYEOF' || die "Einstellungen nicht schreibbar: $id"
import json, os, sys
path, code = sys.argv[1], sys.argv[2]
d = json.load(open(path)) if os.path.exists(path) else {}
exec(code)
json.dump(d, open(path, "w"), indent=2, ensure_ascii=False)
PYEOF
  js "(app.plugins.enablePlugin('$id'), 'ok')"
  # shellcheck disable=SC2310
  wait_for "!!app.plugins.plugins['$id']" 20 || die "Plugin startet nicht wieder: $id"
}
plugin_settings advanced-rename-and-delete-handler \
  'd.update(shouldHandleRenames=True, shouldRenameAttachmentFolder=True)'
# Nur setzen, solange das Plugin noch Obsidians Einstellung folgt (Werkszustand) –
# ein eigenes Muster der Person bleibt erhalten.
plugin_settings obsidian-custom-attachment-location \
  'd.get("shouldFollowObsidianAttachmentLocation", True) and d.update(shouldFollowObsidianAttachmentLocation=False, attachmentFolderPath="Attachments/{{noteFolderPath}}/{{noteFileName}}", generatedAttachmentFileName="{{noteFileName}}")'
ok "Anhänge: je Notiz ein Ordner unter Attachments/, ziehen beim Umbenennen und Verschieben mit"

js "app.vault.getConfig('attachmentFolderPath')"
[[ "$R" == "Attachments" ]] || js "(app.vault.setConfig('attachmentFolderPath', 'Attachments'), 'ok')"
# Ordner gleich anlegen, damit er sein Symbol bekommt und sichtbar ist
js "app.vault.getAbstractFileByPath('Attachments') ? 'da' : (app.vault.createFolder('Attachments'), 'neu')"

# Dateien wie HTML-Lektionen und Prototypen im Datei-Explorer anzeigen
js "(app.vault.setConfig('showUnsupportedFiles', true), 'ok')"

# --- Agent-Vorlagen ----------------------------------------------------------------
# Fehlende Dateien anlegen, Vorhandenes behalten. In CLAUDE.md gehört uns nur der
# Block zwischen den Markierungen „obsidian-vault-setup: Anfang/Ende“: Er wird bei
# jedem Lauf erneuert. Fehlt er, wird er angehängt; der Rest gehört der Person.
# Platzhalter: Name, Pfad und Backup-Ordner dieses Macs (aus der Backup-Config)
BACKUP_ROOT="$HOME/Obsidian-Backup"
CFG="$HOME/Library/Application Support/obsidian-vault-backup/config"
if [[ -f "$CFG" ]]; then
  # shellcheck disable=SC2016  # $1 expandiert erst die neue Shell
  B="$(/bin/bash -c 'source "$1"; printf "%s" "${BACKUP_ROOT:-}"' _ "$CFG" 2>/dev/null || true)"
  [[ -z "$B" ]] || BACKUP_ROOT="$B"
fi
esc() { printf '%s' "${1/#$HOME/\~}" | /usr/bin/sed 's/[\/&|]/\\&/g'; }
E_NAME="$(esc "$NAME")"; E_PATH="$(esc "$VAULT")"; E_BACKUP="$(esc "$BACKUP_ROOT")"
render() {
  /usr/bin/sed -e "s|{{VAULT_NAME}}|$E_NAME|g" -e "s|{{VAULT_PATH}}|$E_PATH|g" \
    -e "s|{{BACKUP_ROOT}}|$E_BACKUP|g" "$1"
}
# claude_md <Vorlage> <Ziel> – verwalteten Block ersetzen oder anhängen
claude_md() {
  /usr/bin/python3 -I - "$1" "$2" <<'PYEOF'
import sys, re
tpl, dst = open(sys.argv[1], encoding="utf-8").read(), sys.argv[2]
cur = open(dst, encoding="utf-8").read()
pat = re.compile(r"%% obsidian-vault-setup: Anfang.*?%% obsidian-vault-setup: Ende %%\n?", re.S)
block = pat.search(tpl).group(0)
if pat.search(cur):
    new = pat.sub(lambda m: block, cur, count=1)
else:
    extra = "" if "## Über diesen Vault" in cur else tpl[tpl.index("## Über diesen Vault"):pat.search(tpl).start()]
    new = cur.rstrip("\n") + "\n\n" + extra + block
if new != cur:
    open(dst, "w", encoding="utf-8").write(new)
    print("geändert")
PYEOF
}
copied=0
while IFS= read -r -d '' src; do
  rel="${src#"$HERE/vault-template/"}"
  dst="$VAULT/$rel"
  if [[ ! -e "$dst" ]]; then
    mkdir -p "$(dirname "$dst")"
    render "$src" >"$dst"
    copied=$((copied + 1))
  elif [[ "$rel" == "CLAUDE.md" ]]; then
    RENDERED="$(mktemp)"
    render "$src" >"$RENDERED"
    # shellcheck disable=SC2310
    CHANGED="$(claude_md "$RENDERED" "$dst")" || die "CLAUDE.md konnte nicht aktualisiert werden"
    rm -f "$RENDERED"
    [[ -z "$CHANGED" ]] || ok "CLAUDE.md: Setup-Abschnitt aktualisiert (eigener Inhalt bleibt)"
  fi
done < <(find "$HERE/vault-template" -type f -not -name .DS_Store -print0 || true)
if ((copied > 0)); then
  ok "Agent-Vorlagen angelegt ($copied Dateien)"
else
  ok "Agent-Vorlagen vollständig"
fi

# --- Symbole (Iconic) ---------------------------------------------------------------
# Nur für Einträge ohne eigenes Symbol – was die Person gesetzt hat, bleibt.
# Rein optisch: Probleme hier sind Warnungen, kein Abbruch.
set_icons() {
  # shellcheck disable=SC2310
  wait_for "!!app.plugins.plugins['iconic'] && !app.plugins.plugins['iconic'].isSaving" 30 || { warn "Iconic lädt nicht – Symbole übersprungen."; return 0; }
  # Neu angelegte Dateien kennt Obsidian erst nach dem Indexieren
  # shellcheck disable=SC2310
  wait_for "!!app.vault.getAbstractFileByPath('CLAUDE.md')" 15 || true
  # Alle setzen, einmal speichern, Plugin neu laden (zeigt die Symbole)
  js "(() => { const ic = app.plugins.plugins['iconic'];
    const want = [['Attachments','lucide-paperclip','blue'], ['Excalidraw','lucide-pencil-ruler','green'],
      ['Planung','lucide-map','red'], ['Lernen','lucide-book-open','cyan'],
      ['docs','lucide-bot','purple'], ['CLAUDE.md','lucide-sparkles','orange'],
      ['Mit Claude arbeiten.md','lucide-graduation-cap','orange']];
    const set = [];
    for (const [p, i, c] of want) {
      if (app.vault.getAbstractFileByPath(p) && !ic.settings.fileIcons[p]) { ic.settings.fileIcons[p] = {icon: i, color: c}; set.push(p); }
    }
    window.__ovsIcons = 'läuft';
    ic.saveSettings().then(() => app.plugins.disablePlugin('iconic')).then(() => app.plugins.enablePlugin('iconic'))
      .then(() => { window.__ovsIcons = 'fertig'; }).catch(e => { window.__ovsIcons = 'Fehler: ' + e; });
    return JSON.stringify(set); })()"
  local wanted="$R"
  # shellcheck disable=SC2310
  wait_for "window.__ovsIcons !== 'läuft'" 30 || { warn "Symbole: keine Rückmeldung von Iconic."; return 0; }
  # Erfolg erst, wenn alles auf der Platte steht (Iconic kann Speichern überspringen)
  if /usr/bin/python3 -I -c 'import json,sys
want=json.loads(sys.argv[2]); have=json.load(open(sys.argv[1])).get("fileIcons",{})
sys.exit(0 if all(p in have for p in want) else 1)' "$VAULT/.obsidian/plugins/iconic/data.json" "$wanted" 2>/dev/null; then
    ok "Symbole für Ordner und Notizen gesetzt"
    return 0
  fi
  return 1
}
# Ein frisch installiertes Iconic schreibt beim ersten Start evtl. seine eigene
# data.json über unsere – dann ein zweiter Versuch.
# shellcheck disable=SC2310
set_icons || { sleep 3; set_icons; } || warn "Symbole nicht gespeichert – vault-setup.sh später erneut ausführen."

echo
ok "Fertig: $NAME"
