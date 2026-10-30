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
| Notiz → Word | `pandoc notiz.md -o notiz.docx` | PDF lieber über HTML + `weasyprint` als über LaTeX (nicht installiert) |
| DWG → DXF | `dwg2dxf -y -o "Attachments/plan.dxf" "Attachments/plan.dwg"` | ohne `-o` landet die Datei im aktuellen Ordner; `-y` überschreibt eine ältere Fassung |
| DXF → PDF/PNG | `uvx --from "ezdxf[draw]" ezdxf draw -o plan.pdf plan.dxf` | Layer, Flächen, Maße per Skript: `uv run --with ezdxf` |
| Video kürzen / komprimieren | `ffmpeg -ss 00:01:00 -to 00:02:00 -i in.mp4 -c copy out.mp4`; `ffmpeg -i in.mov -vcodec libx264 -crf 26 out.mp4` | |
| Tonspur herauslösen | `ffmpeg -i in.mp4 -vn -c:a aac out.m4a` | |

## Programme mit Fenster (Casks)

`brew install --cask <app>` installiert Mac-Programme (z. B. Inkscape, QGIS, LibreOffice, Blender). Das sind große Downloads; manche fragen nach dem Passwort. Frag vorher, ob die Person das Programm wirklich will, und nenne die Größe.

## Aktuell halten

Homebrew aktualisiert sich täglich selbst (`brew autoupdate status`). Läuft kein Job: `brew autoupdate start 1d --upgrade --cleanup --leaves-only`. Funktioniert ein Werkzeug nach einem Update nicht mehr: `brew doctor`, dann `brew reinstall <paket>`. `uv` aktualisiert Python-Pakete bei `uvx`/`uv run` von selbst; für die neueste Version `uvx <paket>@latest`.
