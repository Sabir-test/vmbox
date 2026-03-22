#!/usr/bin/env bash
# install-devpod.sh
# Installs DevPod CLI and configures the local Docker provider.
# Idempotent — safe to run if DevPod is already installed.
set -euo pipefail

DEVPOD_BIN="$HOME/.local/bin/devpod"
DEVPOD_VERSION="${DEVPOD_VERSION:-latest}"

if command -v devpod &>/dev/null; then
  echo "DevPod already installed: $(devpod version)"
else
  echo "Installing DevPod..."
  mkdir -p "$HOME/.local/bin"
  curl -L "https://github.com/loft-sh/devpod/releases/${DEVPOD_VERSION}/download/devpod-linux-amd64" \
    -o "$DEVPOD_BIN"
  chmod +x "$DEVPOD_BIN"
  echo "DevPod installed: $(devpod version)"
fi

# Configure Docker provider if not already set up
if ! devpod provider list 2>/dev/null | grep -q "docker"; then
  echo "Configuring Docker provider..."
  devpod provider add docker --default
else
  echo "Docker provider already configured."
fi
