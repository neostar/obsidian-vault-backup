# Prompt für den KI-Agent

> Den Text zwischen den Linien kopieren und in den Chat deines Agents einfügen – Claude oder Codex, in Obsidian über Claudian.

---

Richte bitte meinen Mac für Obsidian ein: Git, automatisches Backup, Werkzeuge und Plugins – mit dem Setup-Paket von https://github.com/neostar/obsidian-vault-backup.

Lade es mit diesem Befehl – er ersetzt eine ältere Kopie erst, wenn der Download vollständig ist:

```
D="$HOME/Library/Application Support/obsidian-vault-setup"; T="$(mktemp -d)"; curl -fsSL -o "$T/p.tgz" https://github.com/neostar/obsidian-vault-backup/archive/refs/heads/main.tar.gz && mkdir "$T/p" && tar -xzf "$T/p.tgz" --strip-components 1 -C "$T/p" && test -f "$T/p/agent/SETUP.md" && rm -rf "$D" && mkdir -p "$(dirname "$D")" && mv "$T/p" "$D" && ls "$D"
```

Lies dann `agent/SETUP.md` in diesem Ordner und arbeite die Schritte der Reihe nach ab.

---
