#!/bin/bash
# shellcheck disable=SC1111  # deutsche Anführungszeichen „…“ sind gewollt
# Entfernt den stündlichen Backup-Job.
# Vault, Git-Historie und vorhandene Backups bleiben unangetastet.
set -euo pipefail

LABEL="com.obsidian-vault-backup"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
APP_DIR="$HOME/Library/Application Support/obsidian-vault-backup"

launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
rm -f "$PLIST"
rm -rf "$APP_DIR"

echo "✅ Backup-Job entfernt."
echo "   Vault, .git und ~/Obsidian-Backup wurden nicht verändert."
echo "   Den Ordner in Google Drive („My Mac“) bei Bedarf dort selbst entfernen."
