#!/bin/bash
# shellcheck disable=SC1111  # deutsche Anführungszeichen „…“ sind gewollt
# Setzt Symbole (Iconic) für Notizen und Ordner – z. B. für Modulnotizen.
# Verwendung:  ./set-icons.sh [--ersetzen] "/Pfad/zum/Vault" "Pfad/im/Vault.md=lucide-bus=cyan" …
#   Pfad relativ zum Vault, Symbol als Lucide-Name (lucide-…), Farbe optional:
#   red orange yellow green cyan blue purple pink gray.
#   Ohne --ersetzen bleiben Symbole, die schon gesetzt sind (auch von der Person).
# Unbekannte Symbole und fehlende Pfade werden gemeldet und übersprungen (Exit 2) –
# dann ein anderes Symbol wählen und erneut aufrufen.
# Voraussetzung: Obsidian läuft mit diesem Vault, Iconic ist aktiviert.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/obsidian.sh
source "$HERE/lib/obsidian.sh"

REPLACE=false
if [[ "${1:-}" == "--ersetzen" ]]; then REPLACE=true; shift; fi
[[ $# -ge 2 ]] || die "Verwendung: $0 [--ersetzen] \"/Pfad/zum/Vault\" \"Pfad.md=lucide-symbol=farbe\" …"
vault_init "$1"
shift

# Einträge prüfen und als JSON [[pfad, symbol, farbe], …] an Obsidian geben
WANT="$(/usr/bin/python3 -I - "$@" <<'PYEOF'
import json, sys
colors = {"red", "orange", "yellow", "green", "cyan", "blue", "purple", "pink", "gray", ""}
out = []
for arg in sys.argv[1:]:
    parts = arg.rsplit("=", 2)
    if len(parts) == 3 and not parts[2].startswith("lucide-") and parts[1].startswith("lucide-"):
        path, icon, color = parts
    else:
        path, icon = arg.rsplit("=", 1) if "=" in arg else (arg, "")
        color = ""
    if not path or not icon:
        sys.exit(f"Eintrag unvollständig: {arg}  (Form: Pfad=lucide-symbol=farbe)")
    if color not in colors:
        sys.exit(f"Unbekannte Farbe „{color}“ bei {path} – erlaubt: {', '.join(sorted(colors - {''}))}")
    out.append([path, icon, color or None])
print(json.dumps(out, ensure_ascii=False))
PYEOF
)" || die "Ungültige Angaben."

# shellcheck disable=SC2310
wait_for "!!app.plugins.plugins['iconic'] && !app.plugins.plugins['iconic'].isSaving" 30 \
  || die "Iconic ist nicht aktiv. Einstellungen → Community-Plugins → Iconic einschalten."
# Gerade angelegte Dateien kennt Obsidian erst nach dem Indexieren
# shellcheck disable=SC2310
wait_for "$WANT.every(([p]) => !!app.vault.getAbstractFileByPath(p))" 15 || true

set_icons() {
  js "(() => { const ic = app.plugins.plugins['iconic'], r = app.workspace.leftRibbon;
    // Symbol bekannt? Ein losgelöster Ribbon-Knopf rendert es ohne Nebenwirkung.
    const known = n => !!r.makeRibbonItemButton(n, '', () => {}).querySelector('svg');
    const res = {gesetzt: [], vorhanden: [], fehlt: [], unbekannt: []};
    for (const [p, icon, color] of $WANT) {
      if (!app.vault.getAbstractFileByPath(p)) { res.fehlt.push(p); continue; }
      if (!known(icon)) { res.unbekannt.push(p + ' = ' + icon); continue; }
      const cur = ic.settings.fileIcons[p];
      // Gleiches Symbol (z. B. aus dem ersten Versuch) zählt als gesetzt
      if (cur && !$REPLACE && !(cur.icon === icon && (cur.color || null) === color)) { res.vorhanden.push(p); continue; }
      ic.settings.fileIcons[p] = {icon, color}; res.gesetzt.push(p);
    }
    window.__ovsIcons = 'läuft';
    ic.saveSettings().then(() => app.plugins.disablePlugin('iconic')).then(() => app.plugins.enablePlugin('iconic'))
      .then(() => { window.__ovsIcons = 'fertig'; }).catch(e => { window.__ovsIcons = 'Fehler: ' + e; });
    return JSON.stringify(res); })()"
  RES="$R"
  # shellcheck disable=SC2310
  wait_for "window.__ovsIcons !== 'läuft'" 30 || return 1
  # Erfolg erst, wenn alles auf der Platte steht (Iconic kann Speichern überspringen)
  /usr/bin/python3 -I -c 'import json,sys
res=json.loads(sys.argv[2]); have=json.load(open(sys.argv[1])).get("fileIcons",{})
sys.exit(0 if all(p in have for p in res["gesetzt"]) else 1)' \
    "$VAULT/.obsidian/plugins/iconic/data.json" "$RES" 2>/dev/null
}

RES=""
# shellcheck disable=SC2310
set_icons || { sleep 3; set_icons; } || die "Symbole nicht gespeichert (Antwort: ${RES:-keine}) – erneut ausführen."

/usr/bin/python3 -I - "$RES" <<'PYEOF'
import json, sys
res = json.loads(sys.argv[1])
labels = [("gesetzt", "✅ Gesetzt"), ("vorhanden", "↪️  Hatte schon ein Symbol (--ersetzen zum Überschreiben)"),
          ("fehlt", "⚠️  Nicht im Vault"), ("unbekannt", "⚠️  Unbekanntes Symbol – anderes wählen")]
for key, label in labels:
    if res[key]:
        print(f"{label}: " + "; ".join(res[key]))
sys.exit(2 if res["fehlt"] or res["unbekannt"] else 0)
PYEOF
