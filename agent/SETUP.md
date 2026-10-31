# Setup: Obsidian-Vaults mit Git, Backup und Agent-Werkzeugen

Du richtest den Mac einer oder eines Studierenden ein – meist aus Architektur, Stadtplanung oder einem anderen Studiengang ohne Programmieren. Am Ende:

- liegen die gewählten Vaults in `~/Obsidian Vaults/` und werden per Git versioniert,
- sichert ein Hintergrund-Job sie stündlich nach `~/Obsidian-Backup`, und Google Drive lädt diesen Ordner hoch,
- sind Werkzeuge, Obsidian-Plugins und Agent-Skills installiert,
- erklärt jeder Vault in seiner `AGENTS.md` künftigen Agents, für wen und wofür er da ist (`CLAUDE.md` verweist für Claude Code darauf).

`PKG` ist der Ordner, in dem diese Datei liegt (eine Ebene über `agent/`), normalerweise `~/Library/Application Support/obsidian-vault-setup`. Das Paket bleibt dort für spätere Läufe: neuer Vault, Fehlerhilfe.

## Arbeitsweise

- Sprich Deutsch, freundlich, einfach und ohne Fachjargon. Die Person programmiert nicht; erkläre das *Warum* in einem Halbsatz („damit nichts verloren geht“).
- Zeig zu Beginn in drei Sätzen den Plan: was passiert, was die Person selbst tut (ein paar Fragen über sich, einmal Passwort im Terminal, ein Ordner in Google Drive) und wie lange es dauert – etwa 30 Minuten plus die Downloads, die bei langsamem Internet bis zu einer Stunde brauchen. Die Fragen stellst du, während Homebrew lädt; die Werkzeuge laden im Hintergrund, während du die Vaults einrichtest.
- Kündige jeden Schritt in einem Satz an und warte auf ein OK, bevor du etwas veränderst.
- Bewahre alles Bestehende: Original-Vaults bleiben unangetastet, bis die Person sie selbst löscht; existiert ein Ziel schon, frag nach.
- Setze Pfade in Befehlen immer in Anführungszeichen (Namen enthalten Leerzeichen, Umlaute, `&`) und starte Skripte mit `bash "<Skript>"`.
- Führe nichts im Vordergrund aus, was länger als etwa eine Minute braucht: Claudian sperrt den Chat, bis der Befehl fertig ist, und die Person sieht nicht, wie lange es noch dauert. Lange Downloads laufen über `tools.sh` im Hintergrund.
- Schreibt ein Skript ❌, halte an, erkläre die Meldung in einfachen Worten und löse sie gemeinsam, bevor du weitergehst.

## Schritte

### 1. Orientierung

Die Person hat schon mindestens einen Vault.

- Lies `~/Library/Application Support/obsidian/obsidian.json` (Feld `vaults` → `path`).
- Zeig jeden Vault mit Name und Ort in Alltagssprache (iCloud, Google Drive, Dropbox, Dokumente, Schreibtisch, `~/Obsidian Vaults`, anderswo) und markiere den, in dem du gerade läufst.
- Vaults in Shared Drives (`…/Shared drives/…`) und anderen gemeinsam genutzten Ordnern gehören auch anderen: nenne sie, schlage sie nur auf ausdrücklichen Wunsch vor.
- Existiert `~/Library/Application Support/obsidian-vault-backup/config`, ist das Backup schon eingerichtet – sag, was drinsteht.
- Frag dann: **Für welchen Vault – oder welche – soll ich das einrichten?** Schlag den vor, in dem du gerade läufst.

**Fertig, wenn:** die Person die Vaults ausdrücklich genannt hat und du für jeden den alten Pfad und den neuen Pfad `~/Obsidian Vaults/<Name>` kennst.

### 2. Homebrew

Prüfe `/opt/homebrew/bin/brew --version` (Intel-Mac: `/usr/local/bin/brew`). Fehlt Homebrew: Die Installation braucht das Mac-Passwort, und das tippt nur die Person selbst. Bitte sie, das Programm „Terminal“ zu öffnen (⌘-Leertaste, „Terminal“) und genau diesen Befehl mit dem echten Pfad einzufügen: `bash "PKG/setup-homebrew.sh"`. Nach der Passwort-Eingabe lädt das Skript eine Weile (je nach Internet 5–20 Minuten) – die Person muss nur das Terminal offen lassen. Mach währenddessen mit Schritt 3 weiter und frag danach, ob im Terminal „Fertig“ steht. Findet deine Shell `brew` dann nicht, nutze den vollen Pfad.

**Fertig, wenn:** `brew --version` (oder der volle Pfad) bei dir eine Version ausgibt.

### 3. Interview, Teil 1: Fragen

Lies `PKG/agent/INTERVIEW.md` und führe **Teil 1** durch: die Fragen stellen und die Antworten sichern – am besten, während Homebrew im Terminal lädt. So ist die Wartezeit sinnvoll genutzt.

**Fertig, wenn:** die Antwortdatei aus `INTERVIEW.md` existiert und alle Fragen beantwortet oder ausgelassen sind.

### 4. Werkzeuge im Hintergrund laden

Der große Download (Python, pandoc, Bild-, PDF- und Video-Werkzeuge) läuft im Hintergrund, damit der Chat frei bleibt:

```
bash "PKG/tools.sh" start
```

Sag der Person, dass das je nach Internet 10–45 Minuten dauert, sie nichts tun muss und der Mac am Strom bleiben soll. Du machst derweil mit den nächsten Schritten weiter; `bash "PKG/tools.sh" status` zeigt dir jederzeit, welches Paket gerade dran ist. Nach dem Download schaltet das Skript die tägliche Aktualisierung ein.

**Fertig, wenn:** `tools.sh start` „läuft im Hintergrund“ meldet (abgeschlossen wird in Schritt 10).

### 5. Agent-Skills

Die Skills von Matt Pocock (`teach`, `grill-with-docs`, `wayfinder`, `prototype`, `retro` …) gibt es für Claude Code und Codex. Prüfe, welche der beiden Kommandozeilen da sind (`command -v claude`, `command -v codex`; sonst unter `~/.local/bin/`, `~/.claude/local/` und `/opt/homebrew/bin/`), und installiere für jede vorhandene – auch für beide, wenn die Person in Claudian zwischen ihnen wechselt:

```
# Claude Code
claude plugin marketplace add mattpocock/skills
claude plugin install mattpocock-skills@mattpocock

# Codex
codex plugin marketplace add mattpocock/skills
codex plugin add mattpocock-skills@mattpocock
```

Findest du keine der beiden, frag die Person, mit welchem Agent sie arbeitet. Die Skills erscheinen erst in einem neuen Chat.

**Fertig, wenn:** für jeden vorhandenen Agent beide Befehle ohne Fehler durchliefen – bei Claude Code zeigt `claude plugin list` den Eintrag `mattpocock-skills@mattpocock` als aktiv.

### 6. Vaults kopieren

Für jeden gewählten Vault, der noch nicht in `~/Obsidian Vaults` liegt: Größe und Dateianzahl nennen, dann kopieren – das Original bleibt als Sicherheit liegen:

```
mkdir -p ~/"Obsidian Vaults"
ditto "<alt>" "<neu>"
```

Hat die Kopie weniger Dateien, lagen manche nur online: Bitte die Person, den Originalordner im Finder auf „Offline verfügbar“ bzw. „Geladen lassen“ zu stellen, entferne die unvollständige Kopie nach Rückfrage und kopiere erneut.

**Fertig, wenn:** jede Kopie dieselbe Dateianzahl hat wie ihr Original (`find "<Pfad>" -type f | wc -l`).

### 7. Git und Backup

`bash "PKG/install.sh"` richtet Git in jedem Vault unter `~/Obsidian Vaults` ein und startet das stündliche Backup. Erkläre die Ausgabe in zwei, drei Sätzen. macOS meldet dabei „bash can run in the background“ – das ist das Backup; es muss eingeschaltet bleiben.

**Fertig, wenn:** die Ausgabe „Stündliches Backup eingerichtet“ und „Testlauf erfolgreich“ enthält. (Direkt danach startet das erste reguläre Backup im Hintergrund; das Log kann deshalb kurz mitten in einem Lauf stehen.)

### 8. Obsidian einrichten – pro Vault

Prüfe die Obsidian CLI: `/Applications/Obsidian.app/Contents/MacOS/obsidian version`. Antwortet sie nicht, führe die Person hin: Obsidian → Einstellungen → Allgemein → „Command line interface“ einschalten und die Abfrage bestätigen. Prüfe dann erneut. Nur wenn sie weiter nicht antwortet, ist ein Neustart von Obsidian nötig – und der beendet diesen Chat. Sag deshalb **vorher**: „Nach dem Neustart öffne Claudian, wähle im Chat-Verlauf diesen Chat und schreib ‚weiter mit Schritt 8‘.“ Erst dann ⌘Q und Obsidian neu öffnen.

Dann für jeden Vault `bash "PKG/vault-setup.sh" "<neuer Pfad>"`. Das Skript öffnet den Vault in einem eigenen Obsidian-Fenster, installiert die Plugins, stellt das Git-Plugin auf „Commit alle 10 Minuten“, legt `AGENTS.md` (mit `CLAUDE.md` als Verweis für Claude Code), `docs/agents/` und die Einführung „Mit Claudian arbeiten“ an, ordnet Anhänge künftig je Notiz in eigene Ordner unter `Attachments/` und setzt Symbole für Ordner und Notizen. Fragt Obsidian, ob es dem Vault vertrauen soll, bitte die Person, „Vertrauen“ zu klicken. Liegen im Vault schon lose Bilder oder PDFs (z. B. „Pasted image …“ direkt in `Attachments/` oder im Vault-Root), biete an, sie einmal aufzuräumen – wie in der `AGENTS.md` des Vaults unter „Aufräumen“ beschrieben.

**Fertig, wenn:** das Skript für jeden Vault mit „Fertig: <Name>“ endet.

### 9. Google Drive

Führe die Person Klick für Klick: Google Drive (Symbol in der Menüleiste) → Zahnrad → Einstellungen → „My Mac“ → „Add folder“ → im Finder ⌘⇧H, Ordner `Obsidian-Backup` wählen → „Sync with Google Drive“ → Fertig → Speichern. Hat sie kein Google Drive, sag es offen: Das Backup liegt dann nur auf diesem Mac; eine Alternative klärt sie mit der Kursleitung.

**Fertig, wenn:** die Person unter „My Mac“ den Ordner „Obsidian-Backup“ mit einer Größe über 0 Bytes sieht.

### 10. Werkzeuge abschließen

`bash "PKG/tools.sh" status` zeigt den Stand:

- **fertig** – weiter mit Schritt 11.
- **läuft noch** – sag der Person, welches Paket gerade dran ist, und warte mit `bash "PKG/tools.sh" wait 60` höchstens eine Minute am Stück; berichte danach den Stand. Dauert es voraussichtlich noch länger als zehn Minuten, sag der Person, sie soll „weiter“ schreiben, sobald sie Zeit hat, und beende deine Antwort.
- **Fehler** – erklär die letzten Zeilen in einfachen Worten; meist hilft ein erneutes `tools.sh start` (bereits Installiertes wird übersprungen).

**Fertig, wenn:** `tools.sh status` „fertig installiert“ meldet, `brew bundle check --file "PKG/Brewfile"` alles als installiert zeigt und `brew autoupdate status` einen laufenden Job meldet.

### 11. Interview, Teil 2: Eintragen

Führe Teil 2 aus `PKG/agent/INTERVIEW.md` durch: Studienverlauf, Modulnotizen und Profil aus den gesicherten Antworten anlegen.

**Fertig, wenn:** jede eingerichtete `Profil.md` die von der Person bestätigten Antworten enthält und – sofern sie einen Link zum Studienverlauf hatte – `Studium/Studienverlauf.md` und die Modulnotizen in `Studium/Module/` angelegt sind.

### 12. Prüfen und abschließen

Prüfe je Vault mit Befehlen: Log endet mit `FERTIG`; `~/Obsidian-Backup/<Name>/` enthält `vault/` und `vault.bundle`; `git -C "<neuer Pfad>" log --oneline` zeigt Commits.

Gib dann eine kurze Zusammenfassung in Alltagssprache:

- **Ab jetzt im neuen Vault arbeiten:** das Obsidian-Fenster von `~/Obsidian Vaults/<Name>` nutzen und dort einen neuen Chat beginnen – dieser Chat läuft noch im alten Vault.
- Was automatisch passiert: Versionen alle 10 Minuten, Backup stündlich, Google Drive lädt hoch, Werkzeuge aktualisieren sich täglich.
- Erscheint „Obsidian-Backup fehlgeschlagen“: Bildschirmfoto an den Agent.
- **Zum Weiterlesen:** die Notiz „Mit Claudian arbeiten“ im Vault – was der Agent kann und wie die Skills `teach`, `grill-with-docs`, `wayfinder`, `prototype` und `retro` beim Lernen, bei Entwürfen und bei der Abschlussarbeit helfen. Schlag vor, sie gemeinsam kurz anzuschauen, und nenne einen Skill, der zu dem passt, was die Person im Interview über ihr Semester und ihren Vault erzählt hat.
- Neuer Vault: in `~/Obsidian Vaults` anlegen und den Agent bitten, ihn einzurichten.
- Den alten Vault erst nach ein paar Tagen löschen: in Obsidian „Vaults verwalten → Aus Liste entfernen“, dann im Finder in den Papierkorb.

**Fertig, wenn:** alle Prüfungen bestanden sind und die Person die Zusammenfassung bekommen hat.
