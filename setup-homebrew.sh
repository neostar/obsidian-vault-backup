#!/bin/bash
# shellcheck disable=SC1111  # deutsche Anführungszeichen „…“ sind gewollt
# Installiert Homebrew (Paketmanager), damit der KI-Agent bei Bedarf Programme
# installieren kann. Bringt auch Apples Command Line Tools inkl. Git mit.
#
# WICHTIG: Im Programm „Terminal“ ausführen, nicht über den Agent –
# die Installation fragt nach dem Mac-Passwort.
#   bash setup-homebrew.sh
set -euo pipefail

die()  { echo "❌ $*" >&2; exit 1; }
ok()   { echo "✅ $*"; }

ARCH="$(uname -m)"
if [[ "$ARCH" == "arm64" ]]; then
  PREFIX="/opt/homebrew"
else
  PREFIX="/usr/local"
fi
BREW="$PREFIX/bin/brew"
SHELLENV="eval \"\$($BREW shellenv)\""

# --- Homebrew installieren -------------------------------------------------
if [[ -x "$BREW" ]]; then
  ok "Homebrew ist bereits installiert"
else
  id -Gn | tr ' ' '\n' | grep -qx admin \
    || die "Dein Benutzerkonto hat keine Administratorrechte. Homebrew kann so nicht installiert werden."
  [[ -t 0 ]] \
    || die "Bitte dieses Skript direkt im Programm „Terminal“ ausführen (es fragt nach deinem Passwort)."

  cat <<'EOF'
Homebrew wird jetzt installiert.
- Du wirst nach deinem Mac-Passwort gefragt. Beim Tippen erscheinen keine
  Zeichen – das ist normal. Danach Enter drücken.
- Falls nötig, werden Apples „Command Line Tools“ mitinstalliert.
- Das kann 5–15 Minuten dauern.

EOF
  INSTALLER="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
    || die "Download fehlgeschlagen. Bitte Internetverbindung prüfen und erneut starten."
  /bin/bash -c "$INSTALLER"
  [[ -x "$BREW" ]] || die "Installation nicht abgeschlossen. Bitte die Meldungen oben an den KI-Agent weitergeben."
  ok "Homebrew installiert"
fi

# --- Im Terminal (und für den Agent) verfügbar machen ------------------------
touch "$HOME/.zprofile"
if ! grep -qF "$BREW shellenv" "$HOME/.zprofile"; then
  printf '\n# Homebrew\n%s\n' "$SHELLENV" >>"$HOME/.zprofile"
  ok "Homebrew zu ~/.zprofile hinzugefügt"
fi

# --- Prüfen -----------------------------------------------------------------
VERSION="$(/bin/zsh -lc 'brew --version' 2>/dev/null)" \
  || die "brew ist in einer neuen Shell nicht auffindbar."
ok "${VERSION%%$'\n'*}"
/usr/bin/git --version >/dev/null 2>&1 && ok "Git vorhanden"

cat <<'EOF'

Fertig. Schreib dem KI-Agent jetzt: „Homebrew ist installiert.“
EOF
