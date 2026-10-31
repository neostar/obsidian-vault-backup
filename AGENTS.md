# obsidian-vault-backup

Setup-Paket für Obsidian-Vaults auf dem Mac: Git (Obsidian Git Plugin) + stündliches Backup per `launchd` nach `~/Obsidian-Backup`, synchronisiert über Google Drive „My Mac“. Zielgruppe: Studierende ohne Programmierkenntnisse (z. B. Architektur, Stadtplanung). Einstieg für Nutzer: `README.md`; Ablauf des Agents: `agent/SETUP.md`. Die Anleitungen richten sich an jeden Agent (Claude Code, Codex): keine Claude-spezifischen Begriffe, Skills mit beiden Aufrufen (`/mattpocock-skills:<name>`, `$<name>`), Anweisungen in `AGENTS.md` (`CLAUDE.md` verweist nur darauf). Lokale Planung (nicht versioniert, nur beim Maintainer): `PLAN.md`, Specs unter `.scratch/`.

## Agent skills

### Issue tracker

Issues und Specs liegen als Markdown-Dateien unter `.scratch/<feature>/`. See `docs/agents/issue-tracker.md`.

### Triage labels

Standard-Vokabular: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix` (als `Status:`-Zeile in der Issue-Datei). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: ein `GLOSSARY.md` + `docs/adr/` im Repo-Root. See `docs/agents/domain.md`.
