---
tags:
  - anleitung
---
# Mit Claude arbeiten

Claude ist rechts in Obsidian (Claudian) immer dabei. Es kennt deinen Vault: Was in [[CLAUDE]] steht – wer du bist, was du studierst, woran du arbeitest –, liest es zu Beginn jedes Chats. Du kannst ganz normal schreiben, wie mit einer Kommilitonin. Für größere Vorhaben gibt es fünf **Skills**: eingebaute Arbeitsweisen, die du mit einem Schrägstrich startest.

> [!tip] So startest du einen Skill
> Tippe im Claude-Chat `/` und den Namen, z. B. `/mattpocock-skills:teach`, dahinter in einem Satz, worum es geht. Claude führt dich dann Schritt für Schritt.

## Die fünf Skills

### `/mattpocock-skills:teach` – etwas Neues lernen

Claude wird zur Tutorin über mehrere Sitzungen: sucht verlässliche Quellen, baut kurze Lektionen mit Übungen und hält fest, was du schon kannst. Alles liegt im Ordner `Lernen/<Thema>/` – die Lektionen öffnest du per Klick im Browser –, so geht es nächste Woche genau dort weiter.

- *Architektur:* „Ich will die Grundlagen der Tragwerkslehre für Holzbau verstehen.“
- *Bauingenieurwesen:* „Erklär mir Schritt für Schritt die Bemessung nach Eurocode 2.“
- *Naturwissenschaften:* „Bring mir Statistik für meine Laborauswertungen bei.“
- *Wirtschaft:* „Ich muss bis zur Klausur Kostenrechnung können.“

### `/mattpocock-skills:grill-with-docs` – einen Plan auf Herz und Nieren prüfen

Claude stellt dir hartnäckig eine Frage nach der anderen zu deinem Konzept – so lange, bis Lücken und Widersprüche sichtbar sind. Nebenbei entstehen ein **Glossar** (`GLOSSARY.md`: was meinst du genau mit „Quartier“, „Nutzungseinheit“, „Prozess“?) und **Entscheidungsnotizen** (`docs/adr/`: was hast du warum entschieden?). Ideal vor einer Zwischenkritik oder Sprechstunde.

- *Architektur:* Entwurfskonzept vor der Zwischenkritik schärfen.
- *Bachelor- oder Masterarbeit:* Forschungsfrage und Methode festzurren.
- *Projektarbeit:* klären, wer was entscheidet und welche Annahmen gelten.

### `/mattpocock-skills:wayfinder` – ein großes Vorhaben in Etappen planen

Für Vorhaben, die zu groß für einen Nachmittag sind: Claude legt im Ordner `Planung/` eine **Karte** an – Ziel, offene Fragen, getroffene Entscheidungen – und zerlegt den Weg in einzelne Fragen, die ihr nacheinander klärt, Sitzung für Sitzung. Karte und Fragen sind normale Notizen, die du lesen und ergänzen kannst. Wayfinder plant; das Erledigen kommt danach.

- *Abschlussarbeit:* von „Ich habe ein Thema“ bis zur fertigen Gliederung mit Zeitplan.
- *Semesterentwurf:* von der Aufgabenstellung über Recherche und Varianten bis zur Abgabeliste.
- *Wettbewerb oder Gruppenprojekt:* Aufgaben, Abhängigkeiten, Termine.

### `/mattpocock-skills:prototype` – eine Idee schnell zum Ausprobieren bauen

Claude baut ein kleines interaktives Wegwerf-Modell – eine einzelne HTML-Datei in `Planung/Prototypen/`, die du per Doppelklick im Browser öffnest –, um eine Frage zu beantworten: *Geht diese Rechnung auf? Was passiert, wenn ich hier etwas ändere?*

- *Architektur:* Raumprogramm-Rechner – Flächen verschieben und sofort sehen, ob das Programm noch passt.
- *Bauwesen:* Varianten einer Kostenschätzung oder eines Bauablaufs durchspielen.
- *Wirtschaft:* Break-even- oder Preisrechner zum Herumprobieren.
- *Naturwissenschaften:* ein Versuchsablauf mit Reglern, um zu sehen, wie Parameter das Ergebnis verändern.

### `/mattpocock-skills:retro` – aus einer Sitzung lernen

Nach einer längeren Arbeitssitzung schaut Claude zurück: Wo hat es gesucht, gehakt, falsch verstanden? Daraus schlägt es Verbesserungen vor – etwa neue Hinweise in [[CLAUDE]] –, damit die nächste Sitzung glatter läuft. Der Skill stammt aus der Softwareentwicklung; manche Vorschläge klingen technisch. Frag nach, was sie bedeuten, und übernimm nur, was du verstehst.

## Was Claude sonst für dich tun kann

Auf deinem Mac sind Werkzeuge installiert, die Claude direkt nutzt. Frag einfach:

- **Bilder:** Fotos verkleinern, iPhone-Fotos (HEIC) in JPG umwandeln, Standortdaten vor dem Teilen entfernen.
- **PDFs:** zusammenfügen, Seiten herausnehmen, für den Upload verkleinern, Text oder Bilder herausziehen.
- **Pläne:** DWG-Dateien öffnen und als PDF/Bild ausgeben, Flächen aus Plänen auslesen.
- **Layout:** Portfolio, Plakat oder Abgabeblatt aus deinen Notizen als PDF setzen – gern in drei Varianten zum Vergleichen –, Word-Dateien erzeugen.
- **Video und Audio:** Clips kürzen, für den Upload komprimieren, Tonspur herauslösen.
- **Auswertungen:** Messdaten oder Tabellen auswerten und als Diagramm darstellen.

## Gut zu wissen

- **Nichts geht verloren.** Alle 10 Minuten wird eine Version gespeichert, jede Stunde ein Backup erstellt. Etwas versehentlich gelöscht? Frag Claude: „Hol mir die Notiz von gestern zurück.“
- **Ordnung:** Anhänge landen in `Attachments/`, Zeichnungen in `Excalidraw/`, Pläne der Skills in `Planung/`, Lernmaterial in `Lernen/`.
- **[[CLAUDE]] ist deine Notiz.** Neues Projekt, neues Semester? Ändere dort „Über diesen Vault“ – oder bitte Claude darum.
- **Fehlerfenster „Obsidian-Backup fehlgeschlagen“?** Bildschirmfoto machen (⇧⌘4, Leertaste, Fenster anklicken) und Claude geben.
- **Claude kann sich irren.** Prüfe Zahlen, Normen und Quellen, bevor sie in eine Abgabe gehen.
