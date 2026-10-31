# Werkzeuge: Dateien bearbeiten für Studierende

Die Person studiert kein Programmieren, sondern z. B. Architektur, Bauingenieurwesen, Naturwissenschaften oder Wirtschaft. Sie will Ergebnisse – ein kleineres PDF, ein Plakat, ein Diagramm –, keinen Code. Arbeite deshalb so:

- **Originale bleiben unberührt.** Schreib Ergebnisse in neue Dateien mit sprechendem Namen (`Plan_EG_A3.pdf`, `Foto_klein.jpg`) neben das Original – im Anhänge-Ordner der Notiz, `Attachments/<Ordner der Notiz>/<Notizname>/` –, und verlinke sie in dieser Notiz.
- **Ergebnis zeigen, nicht den Befehl.** Nenne Datei, Größe vorher/nachher, Seitenzahl – und öffne PDFs/Bilder bei Bedarf mit `open`.
- **Erst fragen, dann installieren.** Fehlt ein Werkzeug, sag in einem Satz, wofür es ist, und installiere nach dem OK. `sudo` braucht hier nichts; meldet ein Befehl, dass er Admin-Rechte will, halte an und frag.

## Python: immer mit uv

Python-Pakete laufen über `uv`, nie über `pip install` – so bleibt das System sauber, und jedes Skript bringt seine Pakete selbst mit.

- **Einmal-Werkzeug** (Kommandozeilenprogramm aus PyPI): `uvx <paket> …` – z. B. `uvx --from 'markitdown[all]' markitdown datei.docx` (Word/PowerPoint/Excel/PDF → Markdown).
- **Skript mit Paketen:** `uv run --with pandas --with matplotlib skript.py`. Für wiederkehrende Skripte die Abhängigkeiten als Inline-Metadaten in den Kopf schreiben (`# /// script` … `dependencies = [...]`) und `uv run skript.py` nutzen.
- **Wohin mit Skripten:** wiederverwendbare nach `.scratch/skripte/` (in Obsidian ausgeblendet, aber im Backup); Einmal-Skripte in einen Temp-Ordner.
- **Diagramme:** `matplotlib` als PNG/SVG nach `Attachments/`, in der Notiz einbetten (`![[diagramm.png]]`).

## Texte: Hausarbeit, Bericht, Bachelorarbeit (pandoc)

Die Person schreibt in Obsidian (Markdown); `pandoc` macht daraus, was abgegeben wird. Quelle bleibt die Notiz – nach Änderungen einfach neu erzeugen.

- **Word:** `pandoc text.md -o text.docx`. Mit Vorlage der Hochschule oder des Lehrstuhls: `--reference-doc vorlage.docx` (übernimmt Schriften, Überschriften, Ränder). Eine leere Vorlage zum Anpassen: `pandoc -o vorlage.docx --print-default-data-file reference.docx`.
- **Zitate und Literaturverzeichnis:** Quellen als `.bib` (Export aus Zotero: Rechtsklick auf die Sammlung → Exportieren → BibTeX) neben die Notiz, im Text `[@schlüssel, S. 12]`, ans Ende `# Literatur`. Aufruf mit `--citeproc --bibliography quellen.bib --csl stil.csl`. Den Zitierstil als `.csl`-Datei aus https://github.com/citation-style-language/styles laden (z. B. `apa.csl`) – welcher gilt, gibt die Lehrperson vor; frag nach. Kopf der Notiz: `lang: de-DE` für deutsche Ausgabe („S.“, „und“).
- **PDF:** über WeasyPrint, kein LaTeX nötig: `pandoc text.md --citeproc --pdf-engine=weasyprint --css stil.css -o text.pdf`.
- **Folien:** `pandoc text.md -o folien.pptx` – jede `#`-Überschrift wird eine Folie; mit `--reference-doc vorlage.pptx` im Hochschul-Design.
- **Fremde Dateien in den Vault holen:** `pandoc datei.docx -t markdown -o datei.md --extract-media "<Anhänge-Ordner>"`; für PowerPoint/Excel/PDF `markitdown` (siehe oben).
- **Obsidian-Eigenheiten vorher umsetzen:** `[[Wikilinks]]` und `![[Bild.png]]` versteht pandoc nicht – für den Export in normale Links/`![](Pfad)` wandeln (in einer Kopie, nicht in der Notiz), `%% … %%`-Kommentare entfernen.

## Tabellen und CSV

Für Auswertungen (Umfragen, Zählungen, Flächenbilanzen, Statistik-Downloads):

- **Deutsche CSV-Dateien** (Excel, Statistikämter) nutzen meist `;` als Trenner und `,` als Dezimalzeichen, oft in Windows-Kodierung: `pd.read_csv(f, sep=";", decimal=",", encoding="utf-8-sig")` – klappt das nicht, `encoding="cp1252"`. Für Excel wieder so speichern: `to_csv(f, sep=";", decimal=",", encoding="utf-8-sig", index=False)`.
- **Excel lesen/schreiben:** `uv run --with pandas --with openpyxl` (`pd.read_excel`, `to_excel`); mehrere Blätter mit `sheet_name=None`.
- **Schnell nachschauen, filtern, rechnen** ohne Skript: `mlr --icsv --ifs ';' --opprint head -n 10 daten.csv`; `mlr --icsv --opprint put '$Dichte = $Einwohner / $Flaeche_ha' then sort -nr Dichte daten.csv`.
- **Große oder mehrere Dateien verknüpfen:** `duckdb -c "SELECT … FROM 'daten.csv' JOIN read_xlsx('liste.xlsx') USING (Stadtteil)"` (für Excel vorher `INSTALL excel; LOAD excel;`).
- **Ergebnis für die Person:** eine Tabelle als Markdown in die Notiz, das Diagramm als PNG im Anhänge-Ordner, die bereinigten Daten als neue `.xlsx` daneben.

## Karten und Geodaten (GIS)

Für Stadt- und Raumplanung zentral. Alles über `uv`, ohne GDAL-Installation – `geopandas` bringt eine eigene mit:

- **Lesen, umwandeln, zuschneiden:** `uv run --with geopandas` – Shapefile, GeoJSON, GeoPackage, KML. Ergebnis bevorzugt als **GeoPackage** (`.gpkg`, eine Datei statt vieler).
- **Koordinatensystem:** in Deutschland meist **ETRS89 / UTM 32N (`EPSG:25832`)** – darin rechnen Flächen und Abstände in Metern; Web- und GPS-Daten kommen in `EPSG:4326`. Vor jeder Flächen-/Abstandsberechnung `to_crs(25832)`.
- **OpenStreetMap-Daten** (Gebäude, Straßen, Grünflächen, Einrichtungen der Daseinsvorsorge): `uv run --with osmnx` – z. B. Fußwegenetz eines Quartiers und Erreichbarkeit („Welche Kitas liegen in 10 Minuten Fußweg?“). Quelle angeben: „© OpenStreetMap-Mitwirkende“.
- **Karten für Abgaben:** statisch mit `geopandas` + `matplotlib` (PNG/PDF, Maßstabsleiste und Nordpfeil ergänzen), interaktiv mit `folium` als HTML-Datei.
- **QGIS** ist das Standardprogramm im Studium: `brew install --cask qgis` (groß, ca. 1–2 GB – vorher fragen). Ergebnisse als GeoPackage übergeben, dann öffnet die Person sie direkt in QGIS.
- **Amtliche Daten** (Zensus, Bebauungspläne, Geoportale der Länder) haben eigene Nutzungsbedingungen: Quelle und Stand notieren, Lizenzhinweis übernehmen.

## Rezepte

| Aufgabe | Werkzeug | Hinweis |
|---|---|---|
| Bild verkleinern / umwandeln | `magick in.jpg -resize 2000x2000\> out.jpg` | `magick`, nicht das veraltete `convert`; HEIC → JPG geht genauso (oder `sips -s format jpeg`) |
| Standortdaten aus Fotos entfernen | `exiftool -gps:all= -o out.jpg in.jpg` | vor dem Teilen/Hochladen |
| SVG → PNG/PDF | `rsvg-convert -f pdf -o out.pdf in.svg` | |
| PDFs zusammenfügen / Seiten wählen | `qpdf --empty --pages a.pdf b.pdf 3-5 -- out.pdf` | verlustfrei |
| PDF verkleinern | `gs -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -o out.pdf in.pdf` | `/printer` für Druckqualität; Größe vorher/nachher nennen |
| PDF → Bilder / Text | `pdftoppm -png -r 150 in.pdf seite`, `pdftotext -layout in.pdf -` | |
| Gescannte PDFs durchsuchbar machen | `ocrmypdf -l deu in.pdf out.pdf` | nicht vorinstalliert – erst fragen, dann `brew install ocrmypdf tesseract-lang` |
| Layout als PDF (Plakat, Portfolio, Abgabeblatt) | HTML + CSS schreiben, `weasyprint layout.html out.pdf` | Seitenformat per CSS `@page { size: A3 landscape; }`; Bilder aus `Attachments/` |
| Notiz → Word / PDF / Folien | `pandoc notiz.md -o notiz.docx` | Details, Zitate, Vorlagen: Abschnitt „Texte“ oben; PDF über `--pdf-engine=weasyprint` (LaTeX ist nicht installiert) |
| DWG → DXF | `dwg2dxf -y -o "Attachments/plan.dxf" "Attachments/plan.dwg"` | ohne `-o` landet die Datei im aktuellen Ordner; `-y` überschreibt eine ältere Fassung |
| DXF → PDF/PNG | `uvx --from "ezdxf[draw]" ezdxf draw -o plan.pdf plan.dxf` | Layer, Flächen, Maße per Skript: `uv run --with ezdxf` |
| Video kürzen / komprimieren | `ffmpeg -ss 00:01:00 -to 00:02:00 -i in.mp4 -c copy out.mp4`; `ffmpeg -i in.mov -vcodec libx264 -crf 26 out.mp4` | |
| Tonspur herauslösen | `ffmpeg -i in.mp4 -vn -c:a aac out.m4a` | |

## Programme mit Fenster (Casks)

`brew install --cask <app>` installiert Mac-Programme (z. B. Inkscape, QGIS, LibreOffice, Blender). Das sind große Downloads; manche fragen nach dem Passwort. Frag vorher, ob die Person das Programm wirklich will, und nenne die Größe.

## Aktuell halten

Homebrew aktualisiert sich täglich selbst; `brew autoupdate status` zeigt den Job. Läuft keiner oder meldet brew einen Fehler mit `autoupdate`: `bash "$HOME/Library/Application Support/obsidian-vault-setup/tools.sh" start` – richtet den Job mit Prüfung der Herkunft neu ein; danach `tools.sh status` wie beim Setup. Funktioniert ein Werkzeug nach einem Update nicht mehr: `brew doctor`, dann `brew reinstall <paket>`. `uv` aktualisiert Python-Pakete bei `uvx`/`uv run` von selbst; für die neueste Version `uvx <paket>@latest`.
