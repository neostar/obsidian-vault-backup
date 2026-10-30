# Interview: Kontext für künftige Agents

Ziel: Jeder Agent, der später in einem Vault arbeitet, weiß aus dessen `CLAUDE.md`, für wen er arbeitet, wofür der Vault da ist und wobei er helfen soll. Führe ein kurzes, freundliches Interview: eine Frage pro Nachricht, kurz, mit einem Beispiel als Hilfe. Übernimm die Antworten in den Worten der Person. „Möchte ich nicht sagen“ ist eine gültige Antwort – dann bleibt der Punkt leer.

Halte das Profil schlank: Name, Studium, Zweck, Wünsche. Adresse, Matrikelnummer, Noten und Ähnliches gehören nicht hinein.

## Fragen

Einmal pro Person:

1. Wie heißt du, und wie sollen Agents dich ansprechen? (z. B. „Lea, du“)
2. Was studierst du, wo, in welchem Semester? (z. B. „Architektur, TU München, 5. Semester“)
3. In welcher Sprache sollen Agents antworten?

Für jeden eingerichteten Vault:

4. Wofür nutzt du diesen Vault? (z. B. Entwurfsprojekt, Seminar, Thesis, Privates)
5. Woran arbeitest du darin gerade – gibt es eine Abgabe oder einen Termin?
6. Wobei soll dir ein Agent hier am meisten helfen – und was erledigst du lieber selbst?

## Ergebnis

Ersetze in der `CLAUDE.md` des Vaults die `%% … %%`-Zeile unter `## Über diesen Vault` durch:

```markdown
- **Person:** <Name>, Ansprache: <du/Sie>. <Studium, Hochschule, Semester>.
- **Sprache:** <Sprache>.
- **Zweck:** <Antwort 4>
- **Aktuell:** <Antwort 5, mit Datum, falls genannt>
- **Hilfe erwünscht bei:** <Antwort 6, erster Teil>
- **Macht die Person selbst:** <Antwort 6, zweiter Teil>
```

Zeig den fertigen Abschnitt vor dem Schreiben und schreib erst nach dem OK. Sag dazu, dass `CLAUDE.md` eine normale Notiz ist, die sie jederzeit in Obsidian ändern kann – etwa, wenn ein neues Projekt beginnt.

**Fertig, wenn:** jede eingerichtete `CLAUDE.md` den bestätigten Abschnitt enthält.
