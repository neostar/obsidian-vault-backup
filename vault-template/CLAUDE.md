# {{VAULT_NAME}}

## Über diesen Vault

%% Wird beim Einrichten im Interview ausgefüllt: Person, Studium, Zweck des Vaults, Wünsche an Agents. %%

%% obsidian-vault-setup: Anfang – dieser Block wird bei jedem Setup-Lauf erneuert; eigene Ergänzungen bitte darüber oder darunter %%

## Arbeiten in diesem Vault

- **Ort:** lokal in `{{VAULT_PATH}}`. Das Obsidian Git Plugin committet automatisch; das Backup nach `{{BACKUP_ROOT}}/{{VAULT_NAME}}` läuft stündlich von selbst.
- **Ablage:** Anhänge (Bilder, PDFs, Pläne) in `Attachments/`, Zeichnungen in `Excalidraw/`, Pläne und Tickets der Skills in `Planung/`, Lernmaterial in `Lernen/<Thema>/`.
- **Git:** Arbeite immer auf `main` und lass Commits dem Git-Plugin; der Vault hat kein Remote. Schlägt ein Skill einen Branch oder Push vor, leg das Ergebnis stattdessen als Datei in `Planung/` ab.
- **Verschieben und Umbenennen** über die Obsidian CLI, damit Obsidian die Links mitzieht – aus diesem Ordner: `/Applications/Obsidian.app/Contents/MacOS/obsidian move path="alt.md" to="neu.md"`.
- **Dateien bearbeiten** (Bilder, PDF, Pläne, Layout, Video, Auswertungen): lies zuerst `~/Library/Application Support/obsidian-vault-setup/agent/WERKZEUGE.md`. Originale bleiben unberührt; Python immer über `uv run` / `uvx`, nie `pip install`.
- **Skills** – die Person kennt sie aus [[Mit Claude arbeiten]]; schlag einen passenden mit vollem Befehl vor (z. B. `/mattpocock-skills:teach`):
  - `teach`: Arbeitsordner ist `Lernen/<Thema>/` – alle Lern-Dateien (Mission, Quellen, Lektionen, Glossar) dort, nicht im Vault-Root; Lektionen öffnet die Person per Klick im Browser.
  - `prototype`: eine einzelne HTML-Datei in `Planung/Prototypen/`, per Doppelklick im Browser zu öffnen.
  - `retro`: Vorschläge auf Hinweise in dieser `CLAUDE.md` und auf Arbeitsweisen beschränken, in Alltagssprache.
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
