# Interview: Kontext für künftige Agents

Ziel: Jeder Agent, der später im Vault arbeitet, weiß aus `Profil.md`, für wen er arbeitet, was die Person studiert, welche Vorgaben gelten und wobei er helfen soll. `AGENTS.md` weist jeden Agent an, `Profil.md` zu Beginn zu lesen; für Claude Code bindet `CLAUDE.md` sie zusätzlich über `@Profil.md` ein.

Das Interview hat zwei Teile:

- **Teil 1 – Fragen** (Setup-Schritt 2, gleich nach der Orientierung): Fragen stellen, Antworten sichern. Noch nichts installieren und nichts in den Vault schreiben – so ist die Person beschäftigt, bevor die langen Downloads laufen.
- **Teil 2 – Eintragen** (Setup-Schritt 9, nach dem Einrichten der Vaults): Studienverlauf, Modulnotizen und Profil anlegen. Dafür braucht es die Werkzeuge (z. B. `pdftotext`) und die Vorlagen im Vault.

Führe ein kurzes, freundliches Interview: eine Frage pro Nachricht, mit einem Beispiel als Hilfe. Übernimm die Antworten in den Worten der Person. „Möchte ich nicht sagen“ ist eine gültige Antwort – dann bleibt die Zeile leer. Halte das Profil schlank: Adresse, Matrikelnummer, Noten und Ähnliches gehören nicht hinein.

## Teil 1: Fragen

Einmal pro Person:

1. Wie heißt du, und wie soll der Agent dich ansprechen? (z. B. „Lea, du“)
2. Was studierst du, wo und im wievielten Semester? (z. B. „Stadtplanung B.Sc., TH Lübeck, 3. Semester“)
3. Hast du einen Link zum Studienverlauf oder Modulhandbuch deines Studiengangs? (z. B. die Seite „Studienverlauf“ auf der Website deiner Hochschule)
4. In welcher Sprache soll der Agent antworten?
5. Welche Module und Projekte hast du dieses Semester? (z. B. „Stadt Land Projekt, Verkehrsplanung, Wohn- und Stadtsoziologie“) – Hat die Person bei Frage 3 einen Link genannt, lies die Seite gleich (Webseite, ohne Werkzeuge vom Mac), schlag die Module des genannten Semesters vor und lass sie korrigieren.
6. Mit welchen Programmen arbeitest du im Studium? (z. B. QGIS, AutoCAD, Excel, Zotero, InDesign)
7. Gibt es Vorgaben deiner Lehrenden für Abgaben – Zitierstil, Vorlage der Hochschule, Regeln zum Einsatz von KI?
8. Wie lernst du am liebsten? (z. B. „kurze Erklärungen mit Beispielen“, „Übungsfragen“, „Skizzen und Karten“)
9. Wobei soll der Agent dir helfen – und was machst du lieber selbst? (z. B. „Feedback auf meine Texte, aber schreiben will ich selbst“)

Für jeden eingerichteten Vault:

10. Wofür nutzt du diesen Vault? (z. B. „alles fürs Studium“, „nur Bachelorarbeit“)
11. Woran arbeitest du gerade, und gibt es Abgaben oder Termine?

### Antworten sichern

Schreib die Antworten nach jeder Frage in `~/Library/Application Support/obsidian-vault-setup-interview.md` (eine Überschrift je Frage, Vaults getrennt) – so überstehen sie einen Neustart von Obsidian. Die Datei liegt außerhalb des Paketordners, weil der beim Aktualisieren ersetzt wird. Sag der Person danach, dass jetzt die Downloads kommen und du die Antworten später einträgst.

**Fertig (Teil 1), wenn:** jede Frage beantwortet oder ausgelassen ist und die Datei die Antworten enthält.

## Teil 2: Eintragen

Lies die Antworten aus `~/Library/Application Support/obsidian-vault-setup-interview.md`.

### Studienverlauf

Gibt es einen Link, lies die Seite (bei Reitern oder PDF-Modulhandbüchern auch die verlinkten Teile) und leg im Vault die Notiz `Studium/Studienverlauf.md` an:

- Studiengang, Quelle (Link) und Abrufdatum oben,
- je Semester die Module mit Leistungspunkten, Projekte, Praxisphase und Abschlussarbeit – nur, was auf der Seite steht,
- Hinweise der Seite selbst (z. B. „wird aktualisiert“, gültige Prüfungsordnung).

Sag der Person in zwei Sätzen, was du gefunden hast. Ohne Link: frag, ob du die Seite suchen sollst; findest du sie nicht sicher, lass den Punkt leer.

### Modulnotizen

Für jedes Modul eine Notiz `Studium/Module/<Modulname>.md` mit den Eigenschaften aus `Vorlagen/Modul.md` – in dieser Reihenfolge, gleiche Namen:

- Werte aus dem **Modulhandbuch** (PDF, meist auf der Studienverlaufsseite verlinkt; lesen mit `pdftotext -layout`), nicht aus dem Gedächtnis: `kürzel`, `fachsemester`, `ects`, `verpflichtungsgrad`, `angebot` (Angebotshäufigkeit, z. B. WiSe), `lehrform` (Lehrveranstaltungsart, z. B. Vorlesung, Seminar, Projekt), `prüfungsleistung`, `modulverantwortliche`. Was das Handbuch nicht nennt, bleibt leer.
- `status`: `aktuell` für die Module aus Frage 5, `bestanden` für frühere Semester (nach Rückfrage), sonst `geplant`.
- Weichen Studienverlaufsseite und Modulhandbuch voneinander ab (Name, Semester, ECTS), gilt das Handbuch mit dem jüngeren Datum; nenne die Abweichungen der Person.
- **Wahlmodule** sind eine spätere Wahl: Für jeden Wahlbereich im Studienverlauf eine Platzhalter-Notiz, z. B. `Wahlmodule (5. Semester).md` mit `verpflichtungsgrad: Wahlmodul`, `status: geplant`, `ects` = Summe laut Studienverlauf und dem Satz „Sobald du gewählt hast, sag deinem Agent: ‚Ich habe <Modul> als Wahlmodul gewählt.‘“
- Darunter in jeder Notiz nur die Überschriften der Vorlage; Lernergebnisse und Inhalte aus dem Handbuch in zwei, drei Sätzen unter „Worum es geht“.
- **Symbole:** Gib jeder Modulnotiz ein Lucide-Symbol, das zum Inhalt passt (https://lucide.dev/icons – z. B. `lucide-scale` Recht, `lucide-bus` Verkehr, `lucide-trees` Landschaft, `lucide-pencil-ruler` Entwerfen, `lucide-chart-column` Statistik, `lucide-users` Soziologie). Farbe `cyan` für Pflichtmodule, `purple` für Wahlmodule, Platzhalter `lucide-circle-dashed` in `gray`. Alle in einem Aufruf, Pfade relativ zum Vault:

  ```bash
  ~/Library/Application\ Support/obsidian-vault-setup/set-icons.sh "<Vault-Pfad>" \
    "Studium/Module/Bau- und Planungsrecht I.md=lucide-scale=cyan" \
    "Studium/Module/Verkehrsplanung und -technik.md=lucide-bus=cyan"
  ```

  Meldet das Skript „Unbekanntes Symbol“, wähl für diese Notizen ein anderes und ruf es nur mit ihnen erneut auf.

### Profil

Füll `Profil.md` (Abschnitte Person, Studium, Vorgaben für Abgaben, Zusammenarbeit mit dem Agent, Dieser Vault) mit den Antworten und trag bei „Studienverlauf“ den Link und `[[Studienverlauf]]` ein. Zeig das fertige Profil vor dem Schreiben und schreib erst nach dem OK. Sag dazu, dass `Profil.md` eine normale Notiz ist, die sie jederzeit ändern kann – etwa zu Semesterbeginn. Lösch danach die Antwortdatei – ihr Inhalt steht jetzt im Vault.

**Fertig (Teil 2), wenn:** `Profil.md` die bestätigten Antworten enthält, die Antwortdatei gelöscht ist, `Studium/Studienverlauf.md` und eine Notiz je Modul in `Studium/Module/` existieren (sofern ein Link da war), `Studium/Studium.base` sie unter „Module nach Semester“ zeigt, `set-icons.sh` ohne Warnung durchläuft, `AGENTS.md` auf `Profil.md` verweist und `CLAUDE.md` die Zeilen `@AGENTS.md` und `@Profil.md` enthält.
