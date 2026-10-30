# Obsidian Vault Setup

Dein Obsidian-Vault – versioniert, gesichert und bereit für die Arbeit mit Claude. Ein KI-Agent richtet alles ein; du beantwortest ein paar Fragen und klickst an zwei Stellen.

Gedacht für Architektur-Studierende auf dem Mac.

## Was du bekommst

- **Nichts geht verloren.** Jede Änderung an deinen Notizen wird alle 10 Minuten festgehalten (Git), und jede Stunde landet eine Kopie deines Vaults in `~/Obsidian-Backup` – Google Drive lädt sie hoch. Gelöschte Dateien bleiben 90 Tage im Backup.
- **Alles bleibt auf deinem Mac.** Dein Vault liegt in `~/Obsidian Vaults/` und funktioniert auch ohne Internet.
- **Claude kennt deinen Vault.** In einem kurzen Gespräch erzählst du, wer du bist, was du studierst und wofür der Vault da ist. Das steht danach in der Datei `CLAUDE.md` – jede künftige Unterhaltung mit Claude startet mit diesem Wissen.
- **Werkzeuge für deine Dateien.** Claude kann Bilder umwandeln, PDFs zusammenfügen und verkleinern, DWG-Pläne lesen, Layouts als PDF setzen und Videos schneiden. Die Werkzeuge halten sich selbst aktuell.
- **Lernen, planen, ausprobieren mit Claude.** Die Notiz **„Mit Claude arbeiten“** in deinem Vault erklärt fünf eingebaute Arbeitsweisen: Neues lernen (`teach`), ein Konzept vor der Zwischenkritik prüfen lassen (`grill-with-docs`), die Abschlussarbeit in Etappen planen (`wayfinder`), eine Idee als klickbares Modell ausprobieren (`prototype`) und aus einer Sitzung lernen (`retro`).
- **Plugins sind eingerichtet:** Git, Excalidraw, Excalidraw Extras, Iconic, Slash Commander, Sort & Permute Lines, Claudian – mit Symbolen für die wichtigsten Ordner.

## Einrichten

**Vorher (macht die Kursleitung):**

1. Obsidian installieren, deinen Vault öffnen und Claudian mit Claude einrichten.
2. In Obsidian: Einstellungen → Allgemein → **Command line interface** einschalten.

**Dann:** Den Text aus [`AGENT-PROMPT.md`](AGENT-PROMPT.md) in Claudian einfügen und Claude folgen. Claude fragt zuerst, für welchen Vault das Setup gelten soll, und erklärt jeden Schritt, bevor etwas passiert.

**Du selbst tust nur das:**

- einmal einen Befehl ins Terminal kopieren und dein **Mac-Passwort** eingeben (für Homebrew, die Werkzeug-Verwaltung),
- in **Google Drive** den Ordner `Obsidian-Backup` zum Hochladen auswählen,
- ein paar Fragen über dich und deinen Vault beantworten.

Dauer: etwa 20–40 Minuten.

**Du brauchst:** einen eigenen Mac mit Admin-Rechten, Internet und [Google Drive für den Desktop](https://www.google.com/drive/download/).

## Wenn etwas ist

Frag Claude in Obsidian – egal ob Fehlermeldung, neuer Vault oder eine Datei, die du zurückhaben willst. Erscheint das Fenster **„Obsidian-Backup fehlgeschlagen“**, mach ein Bildschirmfoto davon und gib es Claude.

## Wo was liegt

| Ort | Was |
|---|---|
| `~/Obsidian Vaults/<Vault>` | deine Vaults |
| `~/Obsidian-Backup/<Vault>/vault/` | stündliche Kopie aller Dateien |
| `~/Obsidian-Backup/<Vault>/Alte-Versionen/` | gelöschte und überschriebene Dateien, 90 Tage |
| `~/Obsidian-Backup/<Vault>/vault.bundle` | der komplette Versionsverlauf in einer Datei |
| `~/Library/Application Support/obsidian-vault-setup/` | dieses Paket |
| `~/Library/Logs/obsidian-vault-backup.log` | Protokoll der Backups |

## Für Lehrende und Neugierige

Der Agent arbeitet [`agent/SETUP.md`](agent/SETUP.md) ab; das Interview steht in [`agent/INTERVIEW.md`](agent/INTERVIEW.md), die Fehlerhilfe in [`agent/TROUBLESHOOTING.md`](agent/TROUBLESHOOTING.md), Rezepte für Bilder, PDF, Pläne und Python (über `uv`) in [`agent/WERKZEUGE.md`](agent/WERKZEUGE.md).

| Datei | Zweck |
|---|---|
| `setup-homebrew.sh` | installiert Homebrew (braucht das Passwort, läuft im Terminal) |
| `Brewfile` | Werkzeuge: Python, Bilder, PDF, Layout, CAD, Video |
| `install.sh` | Git in jedem Vault unter `~/Obsidian Vaults` + stündlicher Backup-Job |
| `backup.sh` | das Backup selbst (läuft über launchd) |
| `vault-setup.sh` | Obsidian-Plugins und -Einstellungen pro Vault, über die Obsidian CLI |
| `vault-template/` | `CLAUDE.md`, `docs/agents/` und die Einführung „Mit Claude arbeiten“ für jeden Vault |
| `gitignore.template` | hält Bilder, PDFs, CAD-Dateien, Plugin-Code und Chat-Daten aus Git heraus |
| `uninstall.sh` | entfernt den Backup-Job; Vaults und Backups bleiben |

Warum die Vaults nicht in iCloud oder Google Drive liegen: Diese Dienste synchronisieren Dateien einzeln und während Git schreibt – das beschädigt Git-Repositories. Deshalb liegt der Vault lokal, und nur die fertige Backup-Kopie geht in die Cloud.

Nur macOS.
