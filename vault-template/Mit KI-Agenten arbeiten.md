---
tags:
  - anleitung
---
# Mit KI-Agenten arbeiten

Dein KI-Agent – Claude oder Codex – ist rechts in Obsidian (Claudian) immer dabei. Er kennt dich und deinen Vault: Was in [[Profil]] steht – wer du bist, was du studierst, woran du arbeitest, wobei du Hilfe willst –, liest er zu Beginn jedes Chats. Deinen Studienplan findet er in [[Studienverlauf]]. Du kannst ganz normal schreiben, wie mit einer Kommilitonin. Für größere Vorhaben gibt es fünf **Skills**: eingebaute Arbeitsweisen, die du mit einem Befehl startest.

> [!tip] So startest du einen Skill
> Tippe im Chat den Namen des Skills, dahinter in einem Satz, worum es geht. Der Agent führt dich dann Schritt für Schritt.
>
> | Skill | mit Claude | mit Codex |
> |---|---|---|
> | teach | `/mattpocock-skills:teach` | `$teach` |
> | grill-with-docs | `/mattpocock-skills:grill-with-docs` | `$grill-with-docs` |
> | wayfinder | `/mattpocock-skills:wayfinder` | `$wayfinder` |
> | prototype | `/mattpocock-skills:prototype` | `$prototype` |
> | retro | `/mattpocock-skills:retro` | `$retro` |
>
> In den Beispielen unten steht die Schreibweise für Claude; mit Codex nimm `$` und nur den Namen.

## Dem Agent zeigen, worum es geht

Das ist der größte Vorteil eines KI-Agents in Obsidian: Du kannst ihm genau das Material geben, mit dem du arbeitest – deine Mitschrift, die Folien deines Profs, deinen Entwurf. Dann antwortet er auf Grundlage **deiner** Unterlagen statt aus allgemeinem Wissen, das vom Stoff deiner Vorlesung abweichen kann.

- **Die offene Notiz** schickt Claudian automatisch mit. Du siehst sie unten am Eingabefeld. Öffne also die Notiz, um die es geht, und frag dann: „Fass das zusammen“, „Was fehlt hier noch?“
- **Markierter Text:** Markiere einen Absatz in der Notiz und frag nach genau diesem Teil – „Formulier das verständlicher“, „Stimmt diese Rechnung?“
- **`@` für weitere Dateien und Ordner:** Tippe `@` und den Anfang eines Namens, z. B. `@Vorlesung 5` oder `@Attachments/Plan_EG.pdf`. So gibst du dem Agent auch mehrere Notizen, ganze Ordner oder PDFs auf einmal. Mit `@` erreichst du auch frühere Chats.
- **Bilder und Screenshots:** mit ⌘V direkt ins Eingabefeld einfügen – ein Foto vom Tafelbild, ein Ausschnitt aus einem Plan, eine Fehlermeldung.
- **Direkt im Text ändern lassen:** Text markieren, ⌘P drücken und „Claudian: Inline edit“ wählen (oder dafür ein Tastenkürzel festlegen: Einstellungen → Tastenkürzel). Der Agent zeigt die Änderung Wort für Wort, du nimmst sie an oder verwirfst sie.
- **Dauerhaftes Wissen** gehört in [[Profil]]: Was der Agent in *jedem* Chat wissen soll – dein aktuelles Projekt, Abgabetermine, wie du Quellen zitierst, die KI-Regeln deiner Lehrenden –, schreib es dort hinein.

> [!example] Material zuerst in den Vault
> Leg Vorlesungsfolien (PDF), Mitschriften, Aufgabenstellungen, Pläne und Literatur in deinen Vault – am besten in einen Ordner pro Modul, z. B. `Lernen/Bau- und Planungsrecht I/`. Ein PDF ziehst du einfach in den Obsidian-Dateibaum. Ab dann kann der Agent damit arbeiten.

## Größere Vorhaben – und der passende Skill

Wähl, was du vorhast – der Befehl dahinter startet die passende Arbeitsweise. Die Beispiele stammen aus dem Studiengang Stadtplanung (B.Sc.) – vom Einstiegs- und Analyseprojekt bis zur Bachelorarbeit.

### Etwas Neues lernen → `/mattpocock-skills:teach`

Der Agent wird zum Tutor über mehrere Sitzungen: baut kurze Lektionen mit Übungsfragen und Fallbeispielen, fragt dich ab und hält fest, was du schon kannst. Alles liegt im Ordner `Lernen/<Thema>/` – die Lektionen öffnest du per Klick im Browser –, so geht es nächste Woche genau dort weiter.

**Am besten mit deinem eigenen Vorlesungsmaterial.** Leg Folien oder Mitschrift in den Vault und gib sie mit `@` an:

> `/mattpocock-skills:teach` Hilf mir, die wichtigsten Inhalte aus `@Lernen/Bau- und Planungsrecht I/Vorlesung 4 – Bebauungsplan.pdf` zu lernen. Halte dich an dieses Material; wenn du etwas ergänzt, sag dazu, dass es nicht aus der Vorlesung stammt.

Er zieht die Kernaussagen heraus, baut Lektionen und Übungsfälle genau zu diesem Stoff und fragt dich ab. So lernst du, was in deiner Vorlesung dran war – mit den Begriffen und Schwerpunkten deiner Lehrenden – und nicht eine allgemeine Version aus dem Internet. Weitere Vorlesungen gibst du in den nächsten Sitzungen dazu.

Weitere Ideen:

- *Bau- und Planungsrecht:* „Üb mit mir an Fällen: Was darf in einem allgemeinen Wohngebiet gebaut werden? Grundlage sind meine Mitschriften in `@Lernen/Bau- und Planungsrecht I/`.“
- *Geoinformationssysteme:* „Bring mir bei, wie Koordinatensysteme und Layer funktionieren – an den Übungsdaten aus `@Lernen/GIS/`.“
- *Methoden der empirischen Sozialforschung:* „Erklär mir Stichprobe, Fragebogenaufbau und Auswertung so, dass ich meine eigene Umfrage machen kann.“
- *Verkehrsplanung und -technik:* „Ich muss bis zur Klausur Leistungsfähigkeit und Querschnitte können. Hier sind die Übungsblätter: `@Lernen/Verkehrsplanung/`.“

### Einen Plan auf Herz und Nieren prüfen → `/mattpocock-skills:grill-with-docs`

Der Agent stellt dir hartnäckig eine Frage nach der anderen zu deinem Konzept – so lange, bis Lücken und Widersprüche sichtbar sind. Nebenbei entstehen ein **Glossar** (`GLOSSARY.md`: was meinst du genau mit „Quartier“, „Innenentwicklung“, „Nachverdichtung“?) und **Entscheidungsnotizen** (`docs/adr/`: was hast du warum entschieden?). Ideal vor einer Zwischenkritik oder Sprechstunde.

- *Städtebauliches Entwurfsprojekt:* Leitidee, Dichte, Freiraum und Erschließung vor der Zwischenkritik schärfen.
- *Planspiel Projekt:* die Position deiner Rolle durchdenken – welche Argumente bringen Verwaltung, Investorin, Bürgerinitiative?
- *Bachelorarbeit:* Forschungsfrage, Untersuchungsgebiet und Methode festzurren.

### Ein großes Vorhaben in Etappen planen → `/mattpocock-skills:wayfinder`

Für Vorhaben, die zu groß für einen Nachmittag sind: Der Agent legt im Ordner `Planung/` eine **Karte** an – Ziel, offene Fragen, getroffene Entscheidungen – und zerlegt den Weg in einzelne Fragen, die ihr nacheinander klärt, Sitzung für Sitzung. Karte und Fragen sind normale Notizen, die du lesen und ergänzen kannst. Wayfinder plant; das Erledigen kommt danach.

- *Stadt Land Projekt:* von der Aufgabenstellung über Bestandsanalyse und Leitbild bis zur Abgabeliste.
- *Praktikumsprojekt:* Aufgaben im Büro oder in der Verwaltung, was in den Bericht gehört, Termine.
- *Bachelorarbeit:* von „Ich habe ein Thema“ bis zur fertigen Gliederung mit Zeitplan.

### Eine Idee schnell zum Ausprobieren bauen → `/mattpocock-skills:prototype`

Der Agent baut ein kleines interaktives Wegwerf-Modell – eine einzelne HTML-Datei in `Planung/Prototypen/`, die du per Doppelklick im Browser öffnest –, um eine Frage zu beantworten: *Geht diese Rechnung auf? Was passiert, wenn ich hier etwas ändere?*

- *Städtebaulicher Entwurf:* Dichte-Rechner für dein Baufeld – Geschosse und Grundflächen verschieben und sofort GRZ, GFZ, Wohneinheiten und Einwohner sehen.
- *Flächenbilanz:* Bauland, Grün- und Verkehrsflächen per Regler verteilen und prüfen, ob die Ziele des Leitbilds erreicht werden.
- *Verkehr:* Stellplatzbedarf und Wege nach Verkehrsmittel für verschiedene Mobilitätskonzepte durchspielen.
- *Daseinsvorsorge:* Wie viele Kita- oder Schulplätze braucht das neue Quartier bei unterschiedlichen Bewohnerzahlen?

### Aus einer Sitzung lernen → `/mattpocock-skills:retro`

Nach einer längeren Arbeitssitzung schaut der Agent zurück: Wo hat er gesucht, gehakt, falsch verstanden? Daraus schlägt er Verbesserungen vor – etwa neue Hinweise in [[AGENTS]] –, damit die nächste Sitzung glatter läuft. Der Skill stammt aus der Softwareentwicklung; manche Vorschläge klingen technisch. Frag nach, was sie bedeuten, und übernimm nur, was du verstehst.

## Was der Agent sonst für dich tun kann

Auf deinem Mac sind Werkzeuge installiert, die der Agent direkt nutzt. Such dir einen Bereich aus und kopier das Beispiel in den Chat.

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
> Du schreibst in Obsidian, der Agent macht daraus Word, PDF oder Folien – im Layout der Hochschulvorlage, mit Zitaten und automatischem Literaturverzeichnis (z. B. aus Zotero). Ändert sich der Text, ist die Datei in Sekunden neu erzeugt. Word-Dateien von anderen holt er als Notiz in deinen Vault.
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

## Ordnung nach Modulen

Jedes Modul deines Studiengangs hat eine eigene Notiz in `Studium/Module/` – mit Kürzel, Semester, ECTS und Prüfungsleistung wie im Modulhandbuch. Deine eigenen Notizen ordnest du einem Modul zu:

1. Neue Notiz anlegen, dann ⌘P → **„Vorlagen: Vorlage einfügen“** → **Notiz**.
2. Bei **modul** den Namen zu tippen beginnen – Obsidian schlägt die Module vor. Bei **typ** z. B. Vorlesung, Übung, Projekt, Abgabe oder Literatur.

> [!tip] 📚 Alles auf einen Blick: [[Studium.base]]
> - **Module nach Semester** – dein ganzer Studienplan mit Status.
> - **Dieses Semester** – nur die Module mit `status: aktuell`.
> - **Notizen nach Modul** – alle deine Mitschriften, Übungen und Abgaben, sortiert nach Modul.
>
> In jeder Modulnotiz siehst du unten unter „Backlinks“ zusätzlich alle Notizen, die zu ihr gehören.

- **Neues Semester:** „Setz die Module des 4. Semesters auf aktuell und die vom 3. auf bestanden.“
- **Wahlmodule** wählst du später. Sobald es so weit ist: „Ich habe *Stadtmarketing* als Wahlmodul gewählt“ – der Agent legt die Modulnotiz an.
- **Namen passen dir nicht?** Eigenschaften umbenennen: rechte Seitenleiste → „Alle Eigenschaften“ → Rechtsklick → Umbenennen; Obsidian ändert sie in allen Notizen. Für Werte (z. B. „geplant“ → „offen“) sag dem Agent Bescheid.

## Gut zu wissen

- **Nichts geht verloren.** Alle 10 Minuten wird eine Version gespeichert, jede Stunde ein Backup erstellt. Etwas versehentlich gelöscht? Frag den Agent: „Hol mir die Notiz von gestern zurück.“
- **Ordnung bei Bildern und PDFs:** Was du in eine Notiz einfügst oder ziehst, landet automatisch in einem eigenen Ordner für genau diese Notiz – `Attachments/<Ordner>/<Notizname>/` – und ein eingefügter Screenshot heißt wie die Notiz statt „Pasted image 2026…“. Verschiebst oder benennst du die Notiz um, ziehen die Anhänge mit. Lose Dateien von früher? Sag dem Agent: „Räum Attachments auf.“ Zeichnungen liegen in `Excalidraw/`, Pläne der Skills in `Planung/`, Lernmaterial in `Lernen/`.
- **[[Profil]] ist deine Notiz.** Neues Semester, neues Projekt, neue Termine? Ändere sie dort – oder sag dem Agent: „Aktualisier mein Profil fürs 4. Semester.“
- **Fehlerfenster „Obsidian-Backup fehlgeschlagen“?** Bildschirmfoto machen (⇧⌘4, Leertaste, Fenster anklicken) und dem Agent geben.
- **Der Agent kann sich irren.** Prüfe Zahlen, Quellen und vor allem Rechtsfragen (BauGB, BauNVO, Landesbauordnung) an der aktuellen Fassung und deinem Vorlesungsmaterial, bevor sie in eine Abgabe gehen.
