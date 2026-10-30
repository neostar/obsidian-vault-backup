# Backup-Fehler beheben

Die Person zeigt dir meist ein Bildschirmfoto des Dialogs „Obsidian-Backup fehlgeschlagen“ oder „Obsidian-Backup“. Erkläre in einfachen Worten, was los ist, und behebe es mit ihr gemeinsam; ändere erst nach ihrem OK etwas.

## Diagnose – in dieser Reihenfolge

1. **Dialogtext lesen.** Der Pfad oder Vault-Name darin zeigt oft schon die Ursache.
2. **Log:** `tail -n 30 ~/Library/Logs/obsidian-vault-backup.log` – steht der Fehler dort, und wann kam zuletzt `FERTIG: … gesichert`?
3. **Konfiguration:** `cat ~/Library/Application\ Support/obsidian-vault-backup/config` – existieren `VAULTS_ROOT` und `BACKUP_ROOT`?
4. **Job:** `launchctl print gui/$(id -u)/com.obsidian-vault-backup | grep -E 'state|runs|last exit'` – vorhanden, letzter Exit-Code?
5. **Probelauf:** `bash ~/Library/Application\ Support/obsidian-vault-backup/backup.sh; echo $?` – danach erneut ins Log schauen.

**Fertig, wenn:** der Probelauf mit Exit-Code 0 endet und das Log mit `FERTIG: … gesichert` schließt – oder die Ursache benannt ist und nur die Person sie beheben kann (dann sag genau, was sie tun soll).

## Häufige Ursachen

| Meldung | Ursache | Lösung |
|---|---|---|
| `Vault-Ordner nicht gefunden` | `~/Obsidian Vaults` umbenannt, verschoben oder auf externer Platte | Ordner zurück an seinen Platz; sonst `install.sh` mit dem neuen Ort neu ausführen (vorher `uninstall.sh`) |
| `FEHLER <Vault>: Kopieren fehlgeschlagen` | Datei ohne Leserecht, Platte voll | Log zeigt die Datei (`rsync … Permission denied`); Rechte prüfen; `df -h ~` |
| `Git-Bundle konnte nicht erstellt werden` | Git-Repository beschädigt | `git -C "<Vault>" fsck`; Ergebnis der Kursleitung zeigen |
| `Vault ohne Git: <Name>` | Neuer Vault in `~/Obsidian Vaults` | `install.sh` und `vault-setup.sh` aus dem Setup-Paket ausführen |
| `Konfiguration fehlt` | `uninstall.sh` lief oder Ordner gelöscht | `install.sh` neu ausführen |
| Kein Dialog, aber Log-Einträge fehlen seit Stunden | Job aus („bash“ in Systemeinstellungen → Allgemein → Anmeldeobjekte deaktiviert) oder Mac war aus | Schalter wieder an; danach Probelauf |

Das Setup-Paket (`install.sh`, `vault-setup.sh`) liegt in `~/Library/Application Support/obsidian-vault-setup`. Fehlt es, lade es mit dem Befehl aus `AGENT-PROMPT.md` neu: https://github.com/neostar/obsidian-vault-backup/blob/main/AGENT-PROMPT.md

## Wiederherstellen

Ein Vault lässt sich aus `~/Obsidian-Backup/<Name>/` zurückholen – in einen **neuen** Ordner, nie über den bestehenden Vault:

1. `git clone "$HOME/Obsidian-Backup/<Name>/vault.bundle" "<Ziel>"` – Versionsverlauf
2. `git -C "<Ziel>" remote remove origin` – der Klon soll nicht auf das Backup zeigen
3. `rsync -a "$HOME/Obsidian-Backup/<Name>/vault/" "<Ziel>/"` – überschreibt mit dem neueren Dateistand und ergänzt Anhänge

Gelöschte oder überschriebene Einzeldateien der letzten 90 Tage liegen in `~/Obsidian-Backup/<Name>/Alte-Versionen/<Zeitpunkt>/`.
