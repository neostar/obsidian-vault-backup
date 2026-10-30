---
tags:
  - anleitung
---
# Mit Claude arbeiten

Claude ist rechts in Obsidian (Claudian) immer dabei. Es kennt deinen Vault: Was in [[CLAUDE]] steht – wer du bist, was du studierst, woran du arbeitest –, liest es zu Beginn jedes Chats. Du kannst ganz normal schreiben, wie mit einer Kommilitonin. Für größere Vorhaben gibt es fünf **Skills**: eingebaute Arbeitsweisen, die du mit einem Schrägstrich startest.

> [!tip] So startest du einen Skill
> Tippe im Claude-Chat `/` und den Namen, z. B. `/mattpocock-skills:teach`, dahinter in einem Satz, worum es geht. Claude führt dich dann Schritt für Schritt.

## Claude zeigen, worum es geht

Das ist der größte Vorteil von Claude in Obsidian: Du kannst ihm genau das Material geben, mit dem du arbeitest – deine Mitschrift, die Folien deines Profs, deinen Entwurf. Dann antwortet Claude auf Grundlage **deiner** Unterlagen statt aus allgemeinem Wissen, das vom Stoff deiner Vorlesung abweichen kann.

- **Die offene Notiz** schickt Claude automatisch mit. Du siehst sie unten am Eingabefeld. Öffne also die Notiz, um die es geht, und frag dann: „Fass das zusammen“, „Was fehlt hier noch?“
- **Markierter Text:** Markiere einen Absatz in der Notiz und frag nach genau diesem Teil – „Formulier das verständlicher“, „Stimmt diese Rechnung?“
- **`@` für weitere Dateien und Ordner:** Tippe `@` und den Anfang eines Namens, z. B. `@Vorlesung 5` oder `@Attachments/Plan_EG.pdf`. So gibst du Claude auch mehrere Notizen, ganze Ordner oder PDFs auf einmal. Mit `@` erreichst du auch frühere Chats.
- **Bilder und Screenshots:** mit ⌘V direkt ins Eingabefeld einfügen – ein Foto vom Tafelbild, ein Ausschnitt aus einem Plan, eine Fehlermeldung.
- **Direkt im Text ändern lassen:** Text markieren, ⌘P drücken und „Claudian: Inline edit“ wählen (oder dafür ein Tastenkürzel festlegen: Einstellungen → Tastenkürzel). Claude zeigt die Änderung Wort für Wort, du nimmst sie an oder verwirfst sie.
- **Dauerhaftes Wissen** gehört in [[CLAUDE]]: Was Claude in *jedem* Chat wissen soll – dein aktuelles Projekt, Abgabetermine, wie du Quellen zitierst –, schreib es dort unter „Über diesen Vault“.

> [!example] Material zuerst in den Vault
> Leg Vorlesungsfolien (PDF), Mitschriften, Aufgabenstellungen, Pläne und Literatur in deinen Vault – am besten in einen Ordner pro Modul, z. B. `Lernen/Bau- und Planungsrecht I/`. Ein PDF ziehst du einfach in den Obsidian-Dateibaum. Ab dann kann Claude damit arbeiten.

## Die fünf Skills

Die Beispiele stammen aus dem Studiengang Stadtplanung (B.Sc.) – vom Einstiegs- und Analyseprojekt bis zur Bachelorarbeit.

### `/mattpocock-skills:teach` – etwas Neues lernen

Claude wird zur Tutorin über mehrere Sitzungen: baut kurze Lektionen mit Übungsfragen und Fallbeispielen, fragt dich ab und hält fest, was du schon kannst. Alles liegt im Ordner `Lernen/<Thema>/` – die Lektionen öffnest du per Klick im Browser –, so geht es nächste Woche genau dort weiter.

**Am besten mit deinem eigenen Vorlesungsmaterial.** Leg Folien oder Mitschrift in den Vault und gib sie mit `@` an:

> `/mattpocock-skills:teach` Hilf mir, die wichtigsten Inhalte aus `@Lernen/Bau- und Planungsrecht I/Vorlesung 4 – Bebauungsplan.pdf` zu lernen. Halte dich an dieses Material; wenn du etwas ergänzt, sag dazu, dass es nicht aus der Vorlesung stammt.

Claude zieht die Kernaussagen heraus, baut Lektionen und Übungsfälle genau zu diesem Stoff und fragt dich ab. So lernst du, was in deiner Vorlesung dran war – mit den Begriffen und Schwerpunkten deiner Lehrenden – und nicht eine allgemeine Version aus dem Internet. Weitere Vorlesungen gibst du in den nächsten Sitzungen dazu.

Weitere Ideen:

- *Bau- und Planungsrecht:* „Üb mit mir an Fällen: Was darf in einem allgemeinen Wohngebiet gebaut werden? Grundlage sind meine Mitschriften in `@Lernen/Bau- und Planungsrecht I/`.“
- *Geoinformationssysteme:* „Bring mir bei, wie Koordinatensysteme und Layer funktionieren – an den Übungsdaten aus `@Lernen/GIS/`.“
- *Methoden der empirischen Sozialforschung:* „Erklär mir Stichprobe, Fragebogenaufbau und Auswertung so, dass ich meine eigene Umfrage machen kann.“
- *Verkehrsplanung und -technik:* „Ich muss bis zur Klausur Leistungsfähigkeit und Querschnitte können. Hier sind die Übungsblätter: `@Lernen/Verkehrsplanung/`.“

### `/mattpocock-skills:grill-with-docs` – einen Plan auf Herz und Nieren prüfen

Claude stellt dir hartnäckig eine Frage nach der anderen zu deinem Konzept – so lange, bis Lücken und Widersprüche sichtbar sind. Nebenbei entstehen ein **Glossar** (`GLOSSARY.md`: was meinst du genau mit „Quartier“, „Innenentwicklung“, „Nachverdichtung“?) und **Entscheidungsnotizen** (`docs/adr/`: was hast du warum entschieden?). Ideal vor einer Zwischenkritik oder Sprechstunde.

- *Städtebauliches Entwurfsprojekt:* Leitidee, Dichte, Freiraum und Erschließung vor der Zwischenkritik schärfen.
- *Planspiel Projekt:* die Position deiner Rolle durchdenken – welche Argumente bringen Verwaltung, Investorin, Bürgerinitiative?
- *Bachelorarbeit:* Forschungsfrage, Untersuchungsgebiet und Methode festzurren.

### `/mattpocock-skills:wayfinder` – ein großes Vorhaben in Etappen planen

Für Vorhaben, die zu groß für einen Nachmittag sind: Claude legt im Ordner `Planung/` eine **Karte** an – Ziel, offene Fragen, getroffene Entscheidungen – und zerlegt den Weg in einzelne Fragen, die ihr nacheinander klärt, Sitzung für Sitzung. Karte und Fragen sind normale Notizen, die du lesen und ergänzen kannst. Wayfinder plant; das Erledigen kommt danach.

- *Stadt Land Projekt:* von der Aufgabenstellung über Bestandsanalyse und Leitbild bis zur Abgabeliste.
- *Praktikumsprojekt:* Aufgaben im Büro oder in der Verwaltung, was in den Bericht gehört, Termine.
- *Bachelorarbeit:* von „Ich habe ein Thema“ bis zur fertigen Gliederung mit Zeitplan.

### `/mattpocock-skills:prototype` – eine Idee schnell zum Ausprobieren bauen

Claude baut ein kleines interaktives Wegwerf-Modell – eine einzelne HTML-Datei in `Planung/Prototypen/`, die du per Doppelklick im Browser öffnest –, um eine Frage zu beantworten: *Geht diese Rechnung auf? Was passiert, wenn ich hier etwas ändere?*

- *Städtebaulicher Entwurf:* Dichte-Rechner für dein Baufeld – Geschosse und Grundflächen verschieben und sofort GRZ, GFZ, Wohneinheiten und Einwohner sehen.
- *Flächenbilanz:* Bauland, Grün- und Verkehrsflächen per Regler verteilen und prüfen, ob die Ziele des Leitbilds erreicht werden.
- *Verkehr:* Stellplatzbedarf und Wege nach Verkehrsmittel für verschiedene Mobilitätskonzepte durchspielen.
- *Daseinsvorsorge:* Wie viele Kita- oder Schulplätze braucht das neue Quartier bei unterschiedlichen Bewohnerzahlen?

### `/mattpocock-skills:retro` – aus einer Sitzung lernen

Nach einer längeren Arbeitssitzung schaut Claude zurück: Wo hat es gesucht, gehakt, falsch verstanden? Daraus schlägt es Verbesserungen vor – etwa neue Hinweise in [[CLAUDE]] –, damit die nächste Sitzung glatter läuft. Der Skill stammt aus der Softwareentwicklung; manche Vorschläge klingen technisch. Frag nach, was sie bedeuten, und übernimm nur, was du verstehst.

## Was Claude sonst für dich tun kann

Auf deinem Mac sind Werkzeuge installiert, die Claude direkt nutzt. Such dir einen Bereich aus und kopier das Beispiel in den Chat.

> [!example] 🗺️ Karten und Geodaten
> Gebäude, Straßen, Grünflächen und Einrichtungen aus OpenStreetMap holen, Shapefiles und GeoJSON umwandeln, Flächen und Abstände berechnen, Karten als PDF zeichnen – Ergebnisse als GeoPackage für QGIS.
>
> 💬 *„Hol mir alle Gebäude und Grünflächen in St. Lorenz Nord als GeoPackage und zeichne eine Übersichtskarte als PDF.“*

> [!example] 🚶 Erreichbarkeit
> Was liegt wie weit entfernt – zu Fuß, mit dem Rad, entlang des echten Wegenetzes.
>
> 💬 *„Welche Supermärkte, Kitas und Haltestellen erreicht man im Quartier in 10 Minuten zu Fuß?“*

> [!info] 📊 Tabellen und Statistik
> Bevölkerungs- und Zensusdaten zusammenführen, Verkehrszählungen auswerten, Umfragen aus der Sozialforschung zählen, Excel-Tabellen bereinigen – mit Diagrammen für den Bericht.
>
> 💬 *„Werte die Umfrage in @Attachments/…/Umfrage.xlsx aus und mach je Frage ein Balkendiagramm.“*

> [!tip] 📝 Hausarbeit, Projektbericht, Bachelorarbeit
> Du schreibst in Obsidian, Claude macht daraus Word, PDF oder Folien – im Layout der Hochschulvorlage, mit Zitaten und automatischem Literaturverzeichnis (z. B. aus Zotero). Ändert sich der Text, ist die Datei in Sekunden neu erzeugt. Word-Dateien von anderen holt Claude als Notiz in deinen Vault.
>
> 💬 *„Mach aus dieser Notiz eine Word-Datei mit der Hochschulvorlage und Literaturverzeichnis im APA-Stil.“*

> [!abstract] 📐 Pläne und PDFs
> DWG-Pläne als PDF ausgeben, Flächen und Layer auslesen; PDFs zusammenfügen, Seiten herausnehmen, für den Upload verkleinern.
>
> 💬 *„Verkleinere @Abgabe.pdf auf unter 10 MB, ohne dass die Pläne unscharf werden.“*

> [!abstract] 🎨 Layout
> Plakat, Portfolio oder Abgabeblatt aus deinen Notizen als PDF – gern in drei Varianten zum Vergleichen.
>
> 💬 *„Setz meine Bestandsanalyse als A1-Plakat im Querformat, drei Varianten.“*

> [!quote] 📷 Bilder, Video und Audio
> Fotos aus der Bestandsaufnahme verkleinern und Standortdaten entfernen, Clips kürzen, Interviews als Tonspur speichern.
>
> 💬 *„Verkleinere alle Fotos in diesem Ordner auf 2000 px und entferne die GPS-Daten.“*

## Gut zu wissen

- **Nichts geht verloren.** Alle 10 Minuten wird eine Version gespeichert, jede Stunde ein Backup erstellt. Etwas versehentlich gelöscht? Frag Claude: „Hol mir die Notiz von gestern zurück.“
- **Ordnung bei Bildern und PDFs:** Was du in eine Notiz einfügst oder ziehst, landet automatisch in einem eigenen Ordner für genau diese Notiz – `Attachments/<Ordner>/<Notizname>/` – und ein eingefügter Screenshot heißt wie die Notiz statt „Pasted image 2026…“. Verschiebst oder benennst du die Notiz um, ziehen die Anhänge mit. Lose Dateien von früher? Sag Claude: „Räum Attachments auf.“ Zeichnungen liegen in `Excalidraw/`, Pläne der Skills in `Planung/`, Lernmaterial in `Lernen/`.
- **[[CLAUDE]] ist deine Notiz.** Neues Projekt, neues Semester? Ändere dort „Über diesen Vault“ – oder bitte Claude darum.
- **Fehlerfenster „Obsidian-Backup fehlgeschlagen“?** Bildschirmfoto machen (⇧⌘4, Leertaste, Fenster anklicken) und Claude geben.
- **Claude kann sich irren.** Prüfe Zahlen, Quellen und vor allem Rechtsfragen (BauGB, BauNVO, Landesbauordnung) an der aktuellen Fassung und deinem Vorlesungsmaterial, bevor sie in eine Abgabe gehen.
