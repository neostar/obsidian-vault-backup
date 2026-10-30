# {{VAULT_NAME}}

Anweisungen für KI-Agents in diesem Vault (z. B. Claude Code oder Codex, in Obsidian über Claudian).

## Über die Person

Lies zu Beginn jeder Sitzung `Profil.md`: wer die Person ist, was sie studiert, welche Vorgaben gelten und wobei du helfen sollst.

%% obsidian-vault-setup: Anfang – dieser Block wird bei jedem Setup-Lauf erneuert; eigene Ergänzungen bitte darüber oder darunter %%

## Arbeiten in diesem Vault

- **Ort:** lokal in `{{VAULT_PATH}}`. Das Obsidian Git Plugin committet automatisch; das Backup nach `{{BACKUP_ROOT}}/{{VAULT_NAME}}` läuft stündlich von selbst.
- **Ablage:** Jede Notiz hat ihren Anhänge-Ordner `Attachments/<Ordner der Notiz>/<Notizname>/` (Plugin „Custom Attachment Location“); er zieht beim Umbenennen und Verschieben der Notiz mit. Zeichnungen in `Excalidraw/`, Pläne und Tickets der Skills in `Planung/`, Lernmaterial in `Lernen/<Thema>/`.
- **Eigenschaften:** Notizen zu einem Modul bekommen `modul: [[<Modulname>]]` (Liste, Link auf die Modulnotiz), `typ` und `datum` – Format wie `Vorlagen/Notiz.md`. Neues Wahlmodul gewählt: Modulnotiz nach `Vorlagen/Modul.md` in `Studium/Module/` anlegen (`verpflichtungsgrad: Wahlmodul`, Werte aus der Modulbeschreibung) und im Platzhalter „Wahlmodule (…)“ verlinken; passendes Symbol (Farbe `purple`) mit `~/Library/Application Support/obsidian-vault-setup/set-icons.sh "<Vault-Pfad>" "<Pfad>=lucide-…=purple"`. Symbole, die die Person selbst gesetzt hat, bleiben. Hat die Person Eigenschaften oder Werte umbenannt, verwende ihre Namen.
- **Neue Dateien ablegen:** in den Anhänge-Ordner der Notiz, zu der sie gehören, und dort verlinken – nie lose in `Attachments/`.
- **Aufräumen** („Räum Attachments auf“): `obsidian eval code="app.commands.executeCommandById('obsidian-custom-attachment-location:collect-attachments-entire-vault')"` (mit vollem CLI-Pfad, aus diesem Ordner). Obsidian fragt nach – die Person bestätigt mit OK. Danach Dateien, die keine Notiz verlinkt, als Liste zeigen und fragen, was damit passieren soll; gelöscht wird nur nach ausdrücklichem OK.
- **Git:** Arbeite immer auf `main` und lass Commits dem Git-Plugin; der Vault hat kein Remote. Schlägt ein Skill einen Branch oder Push vor, leg das Ergebnis stattdessen als Datei in `Planung/` ab.
- **Verschieben und Umbenennen** über die Obsidian CLI, damit Obsidian die Links mitzieht – aus diesem Ordner: `/Applications/Obsidian.app/Contents/MacOS/obsidian move path="alt.md" to="neu.md"`.
- **Dateien bearbeiten** (Tabellen, Karten und Geodaten, Bilder, PDF, Pläne, Layout, Video): lies zuerst `~/Library/Application Support/obsidian-vault-setup/agent/WERKZEUGE.md`. Originale bleiben unberührt; Python immer über `uv run` / `uvx`, nie `pip install`.
- **Skills** – die Person kennt sie aus [[Mit Claudian arbeiten]]; schlag einen passenden mit dem Aufruf für deinen Agent vor – Claude Code: `/mattpocock-skills:teach`, Codex: `$teach`:
  - Studium im Blick: Module und Semester stehen in `Studium/Studienverlauf.md` und als Notizen in `Studium/Module/` – nutze sie, um Beispiele und Lernstoff am Studienplan auszurichten.
  - `teach`: Arbeitsordner ist `Lernen/<Thema>/` – alle Lern-Dateien (Mission, Quellen, Lektionen, Glossar) dort, nicht im Vault-Root; Lektionen öffnet die Person per Klick im Browser. Vorlesungsmaterial aus dem Vault ist die erste und maßgebliche Quelle: als Erstes in `RESOURCES.md` eintragen, Lektionen und Übungen daraus ableiten, die Begriffe der Vorlesung verwenden. Ergänzungen aus anderen Quellen als solche kennzeichnen; widerspricht etwas dem Material, die Abweichung benennen.
  - `prototype`: eine einzelne HTML-Datei in `Planung/Prototypen/`, per Doppelklick im Browser zu öffnen.
  - `retro`: Vorschläge auf Hinweise in dieser `AGENTS.md` und auf Arbeitsweisen beschränken, in Alltagssprache.
- **Neuer Vault** in `~/Obsidian Vaults`: im Setup-Paket `~/Library/Application Support/obsidian-vault-setup` erst `install.sh`, dann `vault-setup.sh "<Vault>"` ausführen.
- **Backup-Fehlerdialog**, Wiederherstellen, Fragen zum Backup: lies `~/Library/Application Support/obsidian-vault-setup/agent/TROUBLESHOOTING.md`.

## Agent skills

### Issue tracker

Pläne, Specs und Tickets liegen als Markdown-Dateien unter `Planung/<thema>/` (in Obsidian sichtbar). See `docs/agents/issue-tracker.md`.

### Triage labels

Standard-Vokabular: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix` (als `Status:`-Zeile in der Datei). See `docs/agents/triage-labels.md`.

### Domain docs

Ein `GLOSSARY.md` (Begriffe dieses Vaults) und `docs/adr/` (Entscheidungsnotizen) im Vault-Root. See `docs/agents/domain.md`.

%% obsidian-vault-setup: Ende %%
