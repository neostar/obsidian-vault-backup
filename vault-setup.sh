#!/bin/bash
# shellcheck disable=SC1111  # deutsche Anführungszeichen „…“ sind gewollt
# Richtet einen Vault in Obsidian ein – über die Obsidian CLI:
#   Community-Plugins (inkl. Claudian) installieren + aktivieren, Git-Plugin auf „nur Commit“,
#   Anhänge-Ordner „Attachments“, Agent-Vorlagen (AGENTS.md + CLAUDE.md, docs/agents/,
#   „Mit Claudian arbeiten.md“, Profil.md), Symbole für Ordner und Notizen (Iconic).
# Verwendung:  ./vault-setup.sh "/Pfad/zum/Vault"
# Voraussetzung: Obsidian läuft, CLI ist aktiviert (Einstellungen → Allgemein).
# Kann gefahrlos erneut ausgeführt werden; Vorhandenes wird nicht überschrieben.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
# Reihenfolge: advanced-rename-and-delete-handler vor custom-attachment-location (Abhängigkeit)
PLUGINS=(obsidian-git obsidian-excalidraw-plugin excalidraw-extras iconic slash-commander obsidian-sort-and-permute-lines advanced-rename-and-delete-handler obsidian-custom-attachment-location realclaudian)
STORE="https://raw.githubusercontent.com/obsidianmd/obsidian-releases/master/community-plugins.json"

# shellcheck source=lib/obsidian.sh
source "$HERE/lib/obsidian.sh"
[[ -n "${1:-}" ]] || die "Verwendung: $0 \"/Pfad/zum/Vault\""
vault_init "$1"

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
# Fehlende Dateien anlegen, Vorhandenes behalten. In AGENTS.md gehört uns nur der
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
# agent_docs <AGENTS-Vorlage> <CLAUDE-Vorlage> <Vault> – Anweisungen für alle Agents
# in AGENTS.md (Codex liest nur diese); CLAUDE.md bindet sie per @AGENTS.md für
# Claude Code ein. Ausgabe: eine Zeile je Änderung.
agent_docs() {
  /usr/bin/python3 -I - "$1" "$2" "$3" <<'PYEOF'
import os, re, sys
tpl_a, tpl_c = (open(p, encoding="utf-8").read() for p in sys.argv[1:3])
pa, pc = (os.path.join(sys.argv[3], f) for f in ("AGENTS.md", "CLAUDE.md"))
pat = re.compile(r"%% obsidian-vault-setup: Anfang.*?%% obsidian-vault-setup: Ende %%\n?", re.S)
block = pat.search(tpl_a).group(0)
intro = tpl_a[tpl_a.index("## Über die Person"):pat.search(tpl_a).start()]

def update(path, tpl, change, msg_new, msg_changed):
    if not os.path.exists(path):
        open(path, "w", encoding="utf-8").write(tpl)
        print(msg_new)
        return
    cur = open(path, encoding="utf-8").read()
    new = change(cur)
    if new != cur:
        open(path, "w", encoding="utf-8").write(new)
        print(msg_changed)

# AGENTS.md: verwalteten Block erneuern oder anhängen (mit Profil-Hinweis, falls er fehlt)
def agents(cur):
    extra = "" if "Profil.md" in pat.sub("", cur) else intro
    if pat.search(cur):
        return pat.sub(lambda m: extra + block, cur, count=1)
    return cur.rstrip("\n") + "\n\n" + extra + block

# CLAUDE.md der Person: nur die Verweise ergänzen
def claude(cur):
    new = cur
    if "@AGENTS.md" not in new:
        m = re.match(r"# [^\n]*\n\n?", new)
        at = m.end() if m else 0
        new = new[:at] + "@AGENTS.md\n\n" + new[at:]
    if "@Profil.md" not in new:
        new = new.rstrip("\n") + "\n\n@Profil.md\n"
    return new

update(pa, tpl_a, agents, "AGENTS.md angelegt", "AGENTS.md: Setup-Abschnitt aktualisiert (eigener Inhalt bleibt)")
update(pc, tpl_c, claude, "CLAUDE.md angelegt (verweist auf AGENTS.md)", "CLAUDE.md: Verweis auf AGENTS.md ergänzt")
PYEOF
}
copied=0
while IFS= read -r -d '' src; do
  rel="${src#"$HERE/vault-template/"}"
  dst="$VAULT/$rel"
  case "$rel" in
    AGENTS.md | CLAUDE.md) continue ;;   # eigene Behandlung, siehe unten
    *) ;;
  esac
  if [[ ! -e "$dst" ]]; then
    mkdir -p "$(dirname "$dst")"
    render "$src" >"$dst"
    copied=$((copied + 1))
  fi
done < <(find "$HERE/vault-template" -type f -not -name .DS_Store -print0 || true)
RA="$(mktemp)"; RC="$(mktemp)"
render "$HERE/vault-template/AGENTS.md" >"$RA"
render "$HERE/vault-template/CLAUDE.md" >"$RC"
# shellcheck disable=SC2310
DOCS="$(agent_docs "$RA" "$RC" "$VAULT")" || die "AGENTS.md/CLAUDE.md konnten nicht aktualisiert werden"
rm -f "$RA" "$RC"
while IFS= read -r line; do
  [[ -z "$line" ]] || ok "$line"
done <<<"$DOCS"
if ((copied > 0)); then
  ok "Agent-Vorlagen angelegt ($copied Dateien)"
else
  ok "Agent-Vorlagen vollständig"
fi

# --- Studium: Vorlagen, Übersicht, Eigenschaftstypen -------------------------------
# Kern-Plugins „Vorlagen“ und „Bases“ an; Vorlagenordner nur setzen, wenn keiner
# gewählt ist; Typen nur für noch nicht typisierte Eigenschaften (Begriffe aus
# Modulhandbüchern – die Person kann sie in Obsidian umbenennen).
js "(() => { const ip = app.internalPlugins;
  for (const id of ['templates', 'bases']) { const p = ip.getPluginById(id); if (p && !p.enabled) p.enable(true); }
  const t = ip.getPluginById('templates');
  if (t?.instance && !t.instance.options.folder) {
    t.instance.options.folder = 'Vorlagen'; t.instance.options.dateFormat = t.instance.options.dateFormat || 'YYYY-MM-DD';
    t.saveData(t.instance.options);
  }
  const m = app.metadataTypeManager, have = m.types || {};
  const want = {fachsemester: 'number', ects: 'number', modul: 'multitext', lehrform: 'multitext',
    modulverantwortliche: 'multitext', datum: 'date'};
  for (const [k, v] of Object.entries(want)) { if (!have[k]) m.setType(k, v); }
  return (t?.instance?.options.folder || '?'); })()"
ok "Studium: Vorlagen in „$R“ (⌘P → Vorlage einfügen), Übersicht Studium/Studium.base"

# --- Symbole (Iconic) ---------------------------------------------------------------
# Nur für vorhandene Einträge ohne eigenes Symbol – was die Person gesetzt hat, bleibt.
# Rein optisch: Probleme hier sind Warnungen, kein Abbruch.
ICONS=()
for e in "Attachments=lucide-paperclip=blue" "Excalidraw=lucide-pencil-ruler=green" \
  "Planung=lucide-map=red" "Lernen=lucide-book-open=cyan" "docs=lucide-bot=purple" \
  "AGENTS.md=lucide-sparkles=orange" "CLAUDE.md=lucide-link=gray" \
  "Mit Claudian arbeiten.md=lucide-graduation-cap=orange" \
  "Profil.md=lucide-user=pink" "Studium=lucide-school=cyan" "Studium/Module=lucide-library=cyan" \
  "Vorlagen=lucide-layout-template=gray"; do
  p="${e%%=*}"
  [[ -e "$VAULT/$p" ]] && ICONS+=("$e")
done
if "$HERE/set-icons.sh" "$VAULT" "${ICONS[@]}" >/dev/null; then
  ok "Symbole für Ordner und Notizen gesetzt"
else
  warn "Symbole nicht vollständig gesetzt – vault-setup.sh später erneut ausführen."
fi

echo
ok "Fertig: $NAME"
