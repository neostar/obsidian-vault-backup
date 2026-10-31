# Werkzeuge für Agents – installiert im Hintergrund mit:  bash tools.sh start  (oder direkt: brew bundle --file Brewfile)
# Automatische Updates: tools.sh gibt den Befehl nach Prüfung der Herkunft per brew trust frei und startet den Job
# Inoffiziell seit Ende 2023 (früher homebrew/autoupdate); feste Adresse – brew bricht ab, wenn ein Tap gleichen Namens woanders herkommt
tap "domt4/autoupdate", "https://github.com/domt4/homebrew-autoupdate"
# Basis
brew "git"
brew "python"        # Skripte, die Agents schreiben
brew "uv"            # Python-Pakete isoliert nutzen (uv run, uvx)
# Tabellen & Daten
brew "duckdb"        # SQL direkt auf CSV, Excel, Parquet
brew "miller"        # CSV filtern, sortieren, rechnen, zusammenführen (mlr)
# Bilder
brew "imagemagick"   # konvertieren, skalieren, zuschneiden
brew "librsvg"       # SVG → PNG/PDF
brew "exiftool"      # Bild-Metadaten
# PDF
brew "poppler"       # pdftotext, pdfimages, pdftoppm
brew "ghostscript"   # PDFs verkleinern
brew "qpdf"          # PDFs zusammenfügen, teilen, reparieren
# Layout
brew "weasyprint"    # HTML/CSS → PDF
brew "pandoc"        # Markdown ↔ Word/PDF/HTML
# CAD
brew "libredwg"      # DWG → DXF/JSON
# Video & Audio
brew "ffmpeg"
