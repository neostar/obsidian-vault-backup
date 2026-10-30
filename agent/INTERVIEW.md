# Interview: Kontext für künftige Agents

Ziel: Jeder Agent, der später im Vault arbeitet, weiß aus `Profil.md`, für wen er arbeitet, was die Person studiert, welche Vorgaben gelten und wobei er helfen soll. `CLAUDE.md` bindet `Profil.md` über `@Profil.md` in jeden Chat ein.

Führe ein kurzes, freundliches Interview: eine Frage pro Nachricht, mit einem Beispiel als Hilfe. Übernimm die Antworten in den Worten der Person. „Möchte ich nicht sagen“ ist eine gültige Antwort – dann bleibt die Zeile leer. Halte das Profil schlank: Adresse, Matrikelnummer, Noten und Ähnliches gehören nicht hinein.

## Fragen

Einmal pro Person:

1. Wie heißt du, und wie soll Claude dich ansprechen? (z. B. „Lea, du“)
2. Was studierst du, wo und im wievielten Semester? (z. B. „Stadtplanung B.Sc., TH Lübeck, 3. Semester“)
3. Hast du einen Link zum Studienverlauf oder Modulhandbuch deines Studiengangs? (z. B. die Seite „Studienverlauf“ auf der Website deiner Hochschule)
4. In welcher Sprache soll Claude antworten?
5. Welche Module und Projekte hast du dieses Semester? (z. B. „Stadt Land Projekt, Verkehrsplanung, Wohn- und Stadtsoziologie“) – Hast du den Studienverlauf schon geladen (Frage 3), schlag die Module des genannten Semesters vor und lass die Person korrigieren.
6. Mit welchen Programmen arbeitest du im Studium? (z. B. QGIS, AutoCAD, Excel, Zotero, InDesign)
7. Gibt es Vorgaben deiner Lehrenden für Abgaben – Zitierstil, Vorlage der Hochschule, Regeln zum Einsatz von KI?
8. Wie lernst du am liebsten? (z. B. „kurze Erklärungen mit Beispielen“, „Übungsfragen“, „Skizzen und Karten“)
9. Wobei soll Claude dir helfen – und was machst du lieber selbst? (z. B. „Feedback auf meine Texte, aber schreiben will ich selbst“)

Für jeden eingerichteten Vault:

10. Wofür nutzt du diesen Vault? (z. B. „alles fürs Studium“, „nur Bachelorarbeit“)
11. Woran arbeitest du gerade, und gibt es Abgaben oder Termine?

## Studienverlauf laden (nach Frage 3)

Gibt die Person einen Link, lies die Seite (bei Reitern oder PDF-Modulhandbüchern auch die verlinkten Teile) und leg im Vault die Notiz `Studium/Studienverlauf.md` an:

- Studiengang, Quelle (Link) und Abrufdatum oben,
- je Semester die Module mit Leistungspunkten, Projekte, Praxisphase und Abschlussarbeit – nur, was auf der Seite steht,
- Hinweise der Seite selbst (z. B. „wird aktualisiert“, gültige Prüfungsordnung).

Sag der Person in zwei Sätzen, was du gefunden hast. Ohne Link: frag, ob du die Seite suchen sollst; findest du sie nicht sicher, lass den Punkt leer.

### Modulnotizen anlegen

Für jedes Modul eine Notiz `Studium/Module/<Modulname>.md` mit den Eigenschaften aus `Vorlagen/Modul.md` – in dieser Reihenfolge, gleiche Namen:

- Werte aus dem **Modulhandbuch** (PDF, meist auf der Studienverlaufsseite verlinkt; lesen mit `pdftotext -layout`), nicht aus dem Gedächtnis: `kürzel`, `fachsemester`, `ects`, `verpflichtungsgrad`, `angebot` (Angebotshäufigkeit, z. B. WiSe), `lehrform` (Lehrveranstaltungsart, z. B. Vorlesung, Seminar, Projekt), `prüfungsleistung`, `modulverantwortliche`. Was das Handbuch nicht nennt, bleibt leer.
- `status`: `aktuell` für die Module aus Frage 5, `bestanden` für frühere Semester (nach Rückfrage), sonst `geplant`.
- Weichen Studienverlaufsseite und Modulhandbuch voneinander ab (Name, Semester, ECTS), gilt das Handbuch mit dem jüngeren Datum; nenne die Abweichungen der Person.
- **Wahlmodule** sind eine spätere Wahl: Für jeden Wahlbereich im Studienverlauf eine Platzhalter-Notiz, z. B. `Wahlmodule (5. Semester).md` mit `verpflichtungsgrad: Wahlmodul`, `status: geplant`, `ects` = Summe laut Studienverlauf und dem Satz „Sobald du gewählt hast, sag Claude: ‚Ich habe <Modul> als Wahlmodul gewählt.‘“
- Darunter in jeder Notiz nur die Überschriften der Vorlage; Lernergebnisse und Inhalte aus dem Handbuch in zwei, drei Sätzen unter „Worum es geht“.
- **Symbole:** Gib jeder Modulnotiz ein Lucide-Symbol, das zum Inhalt passt (https://lucide.dev/icons – z. B. `lucide-scale` Recht, `lucide-bus` Verkehr, `lucide-trees` Landschaft, `lucide-pencil-ruler` Entwerfen, `lucide-chart-column` Statistik, `lucide-users` Soziologie). Farbe `cyan` für Pflichtmodule, `purple` für Wahlmodule, Platzhalter `lucide-circle-dashed` in `gray`. Alle in einem Aufruf, Pfade relativ zum Vault:

  ```bash
  ~/Library/Application\ Support/obsidian-vault-setup/set-icons.sh "<Vault-Pfad>" \
    "Studium/Module/Bau- und Planungsrecht I.md=lucide-scale=cyan" \
    "Studium/Module/Verkehrsplanung und -technik.md=lucide-bus=cyan"
  ```

  Meldet das Skript „Unbekanntes Symbol“, wähl für diese Notizen ein anderes und ruf es nur mit ihnen erneut auf.

## Ergebnis

Füll `Profil.md` (Abschnitte Person, Studium, Vorgaben für Abgaben, Zusammenarbeit mit Claude, Dieser Vault) mit den Antworten und trag bei „Studienverlauf“ den Link und `[[Studienverlauf]]` ein. Zeig das fertige Profil vor dem Schreiben und schreib erst nach dem OK. Sag dazu, dass `Profil.md` eine normale Notiz ist, die sie jederzeit ändern kann – etwa zu Semesterbeginn.

**Fertig, wenn:** `Profil.md` die bestätigten Antworten enthält, `Studium/Studienverlauf.md` und eine Notiz je Modul in `Studium/Module/` existieren (sofern ein Link da war), `Studium/Studium.base` sie unter „Module nach Semester“ zeigt, `set-icons.sh` ohne Warnung durchläuft und `CLAUDE.md` die Zeile `@Profil.md` enthält.
