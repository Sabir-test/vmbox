#!/usr/bin/env bash
# install-ides.sh
# Installs VS Code and Cursor IDE on KDE Neon / Ubuntu.
# Idempotent — skips already-installed tools.
set -euo pipefail

# VS Code
if command -v code &>/dev/null; then
  echo "VS Code already installed: $(code --version | head -1)"
else
  echo "Installing VS Code..."
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] \
    https://packages.microsoft.com/repos/code stable main" \
    | tee /etc/apt/sources.list.d/vscode.list
  apt-get update && apt-get install -y code
  echo "VS Code installed."
fi

# Cursor IDE
if command -v cursor &>/dev/null; then
  echo "Cursor already installed."
else
  echo "Cursor: download the .deb or AppImage from https://cursor.sh and install manually."
  echo "No automated installer available — Cursor uses a proprietary distribution."
fi

# Antigravity (already installed at /usr/bin/antigravity)
if command -v antigravity &>/dev/null; then
  echo "Antigravity already installed: $(antigravity --version 2>/dev/null | head -1)"
fi
