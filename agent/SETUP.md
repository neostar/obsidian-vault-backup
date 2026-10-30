# Setup: Obsidian-Vaults mit Git, Backup und Agent-Werkzeugen

Du richtest den Mac einer Architektur-Studentin oder eines -Studenten ein. Am Ende:

- liegen die gewählten Vaults in `~/Obsidian Vaults/` und werden per Git versioniert,
- sichert ein Hintergrund-Job sie stündlich nach `~/Obsidian-Backup`, und Google Drive lädt diesen Ordner hoch,
- sind Werkzeuge, Obsidian-Plugins und Agent-Skills installiert,
- erklärt jeder Vault in seiner `CLAUDE.md` künftigen Agents, für wen und wofür er da ist.

`PKG` ist der Ordner, in dem diese Datei liegt (eine Ebene über `agent/`), normalerweise `~/Library/Application Support/obsidian-vault-setup`. Das Paket bleibt dort für spätere Läufe: neuer Vault, Fehlerhilfe.

## Arbeitsweise

- Sprich Deutsch, freundlich, einfach und ohne Fachjargon. Die Person programmiert nicht; erkläre das *Warum* in einem Halbsatz („damit nichts verloren geht“).
- Zeig zu Beginn in drei Sätzen den Plan: was passiert, etwa 20–40 Minuten, und was die Person selbst tut (einmal Passwort im Terminal, ein Ordner in Google Drive, ein paar Fragen über sich).
- Kündige jeden Schritt in einem Satz an und warte auf ein OK, bevor du etwas veränderst.
- Bewahre alles Bestehende: Original-Vaults bleiben unangetastet, bis die Person sie selbst löscht; existiert ein Ziel schon, frag nach.
- Setze Pfade in Befehlen immer in Anführungszeichen (Namen enthalten Leerzeichen, Umlaute, `&`) und starte Skripte mit `bash "<Skript>"`.
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

Prüfe `/opt/homebrew/bin/brew --version` (Intel-Mac: `/usr/local/bin/brew`). Fehlt Homebrew: Die Installation braucht das Mac-Passwort, und das tippt nur die Person selbst. Bitte sie, das Programm „Terminal“ zu öffnen (⌘-Leertaste, „Terminal“) und genau diesen Befehl mit dem echten Pfad einzufügen: `bash "PKG/setup-homebrew.sh"`. Warte auf ihre Rückmeldung. Findet deine Shell `brew` danach nicht, nutze den vollen Pfad.

**Fertig, wenn:** `brew --version` (oder der volle Pfad) bei dir eine Version ausgibt.

### 3. Werkzeuge

Sag vorher, dass das 5–15 Minuten dauert. Dann:

```
brew bundle --file "PKG/Brewfile"
brew autoupdate start 1d --upgrade --cleanup --leaves-only
```

Der zweite Befehl hält die Werkzeuge täglich von selbst aktuell.

**Fertig, wenn:** `brew bundle check --file "PKG/Brewfile"` meldet, dass alles installiert ist, und `brew autoupdate status` einen laufenden Job zeigt.

### 4. Agent-Skills für Claude Code

```
claude plugin marketplace add mattpocock/skills
claude plugin install mattpocock-skills@mattpocock
```

Findet die Shell `claude` nicht, such es unter `~/.claude/local/claude`, `~/.local/bin/claude` und `/opt/homebrew/bin/claude`; sonst frag nach.

**Fertig, wenn:** `claude plugin list` den Eintrag `mattpocock-skills@mattpocock` als aktiv zeigt.

### 5. Vaults kopieren

Für jeden gewählten Vault, der noch nicht in `~/Obsidian Vaults` liegt: Größe und Dateianzahl nennen, dann kopieren – das Original bleibt als Sicherheit liegen:

```
mkdir -p ~/"Obsidian Vaults"
ditto "<alt>" "<neu>"
```

Hat die Kopie weniger Dateien, lagen manche nur online: Bitte die Person, den Originalordner im Finder auf „Offline verfügbar“ bzw. „Geladen lassen“ zu stellen, entferne die unvollständige Kopie nach Rückfrage und kopiere erneut.

**Fertig, wenn:** jede Kopie dieselbe Dateianzahl hat wie ihr Original (`find "<Pfad>" -type f | wc -l`).

### 6. Git und Backup

`bash "PKG/install.sh"` richtet Git in jedem Vault unter `~/Obsidian Vaults` ein und startet das stündliche Backup. Erkläre die Ausgabe in zwei, drei Sätzen. macOS meldet dabei „bash can run in the background“ – das ist das Backup; es muss eingeschaltet bleiben.

**Fertig, wenn:** die Ausgabe „Stündliches Backup eingerichtet“ und „Testlauf erfolgreich“ enthält. (Direkt danach startet das erste reguläre Backup im Hintergrund; das Log kann deshalb kurz mitten in einem Lauf stehen.)

### 7. Obsidian einrichten – pro Vault

Prüfe die Obsidian CLI: `/Applications/Obsidian.app/Contents/MacOS/obsidian version`. Antwortet sie nicht, führe die Person hin: Obsidian → Einstellungen → Allgemein → „Command line interface“ einschalten und die Abfrage bestätigen. Prüfe dann erneut. Nur wenn sie weiter nicht antwortet, ist ein Neustart von Obsidian nötig – und der beendet diesen Chat. Sag deshalb **vorher**: „Nach dem Neustart öffne Claudian, wähle im Chat-Verlauf diesen Chat und schreib ‚weiter mit Schritt 7‘.“ Erst dann ⌘Q und Obsidian neu öffnen.

Dann für jeden Vault `bash "PKG/vault-setup.sh" "<neuer Pfad>"`. Das Skript öffnet den Vault in einem eigenen Obsidian-Fenster, installiert die Plugins, stellt das Git-Plugin auf „Commit alle 10 Minuten“, legt `CLAUDE.md`, `docs/agents/` und die Einführung „Mit Claude arbeiten“ an ordnet Anhänge künftig je Notiz in eigene Ordner unter `Attachments/` und setzt Symbole für Ordner und Notizen. Fragt Obsidian, ob es dem Vault vertrauen soll, bitte die Person, „Vertrauen“ zu klicken. Liegen im Vault schon lose Bilder oder PDFs (z. B. „Pasted image …“ direkt in `Attachments/` oder im Vault-Root), biete an, sie einmal aufzuräumen – wie in der `CLAUDE.md` des Vaults unter „Aufräumen“ beschrieben.

**Fertig, wenn:** das Skript für jeden Vault mit „Fertig: <Name>“ endet.

### 8. Interview

Lies `PKG/agent/INTERVIEW.md` und führe es durch.

**Fertig, wenn:** jede eingerichtete `Profil.md` die von der Person bestätigten Antworten enthält und `Studium/Studienverlauf.md` angelegt ist, sofern sie einen Link zum Studienverlauf hatte.

### 9. Google Drive

Führe die Person Klick für Klick: Google Drive (Symbol in der Menüleiste) → Zahnrad → Einstellungen → „My Mac“ → „Add folder“ → im Finder ⌘⇧H, Ordner `Obsidian-Backup` wählen → „Sync with Google Drive“ → Fertig → Speichern. Hat sie kein Google Drive, sag es offen: Das Backup liegt dann nur auf diesem Mac; eine Alternative klärt sie mit der Kursleitung.

**Fertig, wenn:** die Person unter „My Mac“ den Ordner „Obsidian-Backup“ mit einer Größe über 0 Bytes sieht.

### 10. Prüfen und abschließen

Prüfe je Vault mit Befehlen: Log endet mit `FERTIG`; `~/Obsidian-Backup/<Name>/` enthält `vault/` und `vault.bundle`; `git -C "<neuer Pfad>" log --oneline` zeigt Commits.

Gib dann eine kurze Zusammenfassung in Alltagssprache:

- **Ab jetzt im neuen Vault arbeiten:** das Obsidian-Fenster von `~/Obsidian Vaults/<Name>` nutzen und dort einen neuen Claude-Chat beginnen – dieser Chat läuft noch im alten Vault.
- Was automatisch passiert: Versionen alle 10 Minuten, Backup stündlich, Google Drive lädt hoch, Werkzeuge aktualisieren sich täglich.
- Erscheint „Obsidian-Backup fehlgeschlagen“: Bildschirmfoto an Claude.
- **Zum Weiterlesen:** die Notiz „Mit Claude arbeiten“ im Vault – was Claude kann und wie die Skills `teach`, `grill-with-docs`, `wayfinder`, `prototype` und `retro` beim Lernen, bei Entwürfen und bei der Abschlussarbeit helfen. Schlag vor, sie gemeinsam kurz anzuschauen, und nenne einen Skill, der zu dem passt, was die Person im Interview über ihr Semester und ihren Vault erzählt hat.
- Neuer Vault: in `~/Obsidian Vaults` anlegen und Claude bitten, ihn einzurichten.
- Den alten Vault erst nach ein paar Tagen löschen: in Obsidian „Vaults verwalten → Aus Liste entfernen“, dann im Finder in den Papierkorb.

**Fertig, wenn:** alle Prüfungen bestanden sind und die Person die Zusammenfassung bekommen hat.
