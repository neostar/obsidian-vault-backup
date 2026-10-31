# Obsidian Vault Setup

Dein Obsidian-Vault – versioniert, gesichert und bereit für die Arbeit mit einem KI-Agent – Claude oder Codex. Der Agent richtet alles ein; du beantwortest ein paar Fragen und klickst an zwei Stellen.

Gedacht für Studierende ohne Programmierkenntnisse – z. B. Architektur oder Stadtplanung – auf dem Mac.

## Was du bekommst

- **Nichts geht verloren.** Jede Änderung an deinen Notizen wird alle 10 Minuten festgehalten (Git), und jede Stunde landet eine Kopie deines Vaults in `~/Obsidian-Backup` – Google Drive lädt sie hoch. Gelöschte Dateien bleiben 90 Tage im Backup.
- **Alles bleibt auf deinem Mac.** Dein Vault liegt in `~/Obsidian Vaults/` und funktioniert auch ohne Internet.
- **Dein Agent kennt deinen Vault.** In einem kurzen Gespräch erzählst du, wer du bist, was du studierst, welche Vorgaben für Abgaben gelten und wofür der Vault da ist; aus dem Link zu deinem Studienverlauf holt er die Module aller Semester. Das steht danach in der Notiz `Profil` – jede künftige Unterhaltung startet mit diesem Wissen.
- **Werkzeuge für deine Dateien.** Der Agent kann Karten und Geodaten aufbereiten (OpenStreetMap, Shapefile, GeoPackage für QGIS), Tabellen und CSV-Dateien auswerten, Bilder umwandeln, PDFs zusammenfügen und verkleinern, DWG-Pläne lesen, Hausarbeiten mit Literaturverzeichnis als Word oder PDF ausgeben (pandoc), Layouts als PDF setzen und Videos schneiden. Die Werkzeuge halten sich selbst aktuell.
- **Ordnung nach Modulen.** Aus dem Modulhandbuch entsteht je Modul eine Notiz (Kürzel, Semester, ECTS, Prüfungsleistung); eigene Notizen ordnest du per Vorlage einem Modul zu, und die Übersicht `Studium.base` zeigt Studienplan, aktuelles Semester und Notizen nach Modul. Jedes Modul bekommt ein passendes Symbol; Wahlmodule kommen später dazu.
- **Lernen, planen, ausprobieren mit KI.** Die Notiz **„Mit Claudian arbeiten“** in deinem Vault erklärt fünf eingebaute Arbeitsweisen: Neues lernen (`teach`), ein Konzept vor der Zwischenkritik prüfen lassen (`grill-with-docs`), die Abschlussarbeit in Etappen planen (`wayfinder`), eine Idee als klickbares Modell ausprobieren (`prototype`) und aus einer Sitzung lernen (`retro`).
- **Ordnung bei Anhängen.** Jede Notiz bekommt ihren eigenen Anhänge-Ordner, eingefügte Bilder heißen wie die Notiz, und beim Umbenennen oder Verschieben ziehen sie mit. Alte, lose Dateien räumt der Agent auf Zuruf auf.
- **Plugins sind eingerichtet:** Git, Excalidraw, Excalidraw Extras, Iconic, Slash Commander, Sort & Permute Lines, Custom Attachment Location, Advanced Rename and Delete Handler, Claudian – mit Symbolen für die wichtigsten Ordner.

## Einrichten

**Vorher (macht die Kursleitung):**

1. Obsidian installieren, deinen Vault öffnen und Claudian mit Claude oder Codex einrichten.
2. In Obsidian: Einstellungen → Allgemein → **Command line interface** einschalten.

**Dann:** Den Text aus [`AGENT-PROMPT.md`](AGENT-PROMPT.md) in Claudian einfügen und dem Agent folgen. Er fragt zuerst, für welchen Vault das Setup gelten soll, und erklärt jeden Schritt, bevor etwas passiert.

**Du selbst tust nur das:**

- einmal einen Befehl ins Terminal kopieren und dein **Mac-Passwort** eingeben (für Homebrew, die Werkzeug-Verwaltung),
- ein paar Fragen über dich und deinen Vault beantworten – während Homebrew lädt,
- in **Google Drive** den Ordner `Obsidian-Backup` zum Hochladen auswählen.

Dauer: etwa 30 Minuten, dazu die Downloads – bei langsamem Internet bis zu einer Stunde. Downloads und das Kopieren großer Vaults laufen im Hintergrund; der Chat bleibt dabei frei.

**Du brauchst:** einen eigenen Mac mit Admin-Rechten, Internet und [Google Drive für den Desktop](https://www.google.com/drive/download/).

## Wenn etwas ist

Frag deinen Agent in Obsidian – egal ob Fehlermeldung, neuer Vault oder eine Datei, die du zurückhaben willst. Erscheint das Fenster **„Obsidian-Backup fehlgeschlagen“**, mach ein Bildschirmfoto davon und gib es dem Agent.

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

Der Agent arbeitet [`agent/SETUP.md`](agent/SETUP.md) ab; das Interview steht in [`agent/INTERVIEW.md`](agent/INTERVIEW.md), die Fehlerhilfe in [`agent/TROUBLESHOOTING.md`](agent/TROUBLESHOOTING.md), Rezepte für Tabellen, Karten und Geodaten, Bilder, PDF, Pläne und Python (über `uv`) in [`agent/WERKZEUGE.md`](agent/WERKZEUGE.md).

| Datei | Zweck |
|---|---|
| `setup-homebrew.sh` | installiert Homebrew (braucht das Passwort, läuft im Terminal) |
| `tools.sh` | installiert die Werkzeuge aus dem `Brewfile` im Hintergrund und meldet den Stand |
| `copy-vault.sh` | kopiert Vaults im Hintergrund nach `~/Obsidian Vaults` und prüft, ob alle Dateien angekommen sind |
| `Brewfile` | Werkzeuge: Python (uv), Tabellen (DuckDB, Miller), Bilder, PDF, Layout, CAD, Video |
| `install.sh` | Git in jedem Vault unter `~/Obsidian Vaults` + stündlicher Backup-Job |
| `backup.sh` | das Backup selbst (läuft über launchd) |
| `vault-setup.sh` | Obsidian-Plugins und -Einstellungen pro Vault, über die Obsidian CLI |
| `set-icons.sh` | Symbole (Iconic) für Notizen und Ordner – nutzt der Agent z. B. für Modulnotizen |
| `vault-template/` | `AGENTS.md` (Anweisungen für jeden Agent; `CLAUDE.md` verweist darauf), `Profil.md`, `docs/agents/`, Vorlagen, Studium-Übersicht und die Einführung „Mit Claudian arbeiten“ für jeden Vault |
| `gitignore.template` | hält Bilder, PDFs, CAD-Dateien, Plugin-Code und Chat-Daten aus Git heraus |
| `uninstall.sh` | entfernt den Backup-Job; Vaults und Backups bleiben |

Warum die Vaults nicht in iCloud oder Google Drive liegen: Diese Dienste synchronisieren Dateien einzeln und während Git schreibt – das beschädigt Git-Repositories. Deshalb liegt der Vault lokal, und nur die fertige Backup-Kopie geht in die Cloud.

Nur macOS.
