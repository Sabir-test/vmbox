#!/usr/bin/env bash
# install-docker.sh
# Installs Docker CE + Compose plugin on Ubuntu/KDE Neon.
# Idempotent — safe to run if Docker is already installed.
# Requires: sudo
set -euo pipefail

if command -v docker &>/dev/null; then
  echo "Docker already installed: $(docker --version)"
  exit 0
fi

echo "Installing Docker CE..."
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add current user to docker group (no-sudo docker access)
usermod -aG docker "${SUDO_USER:-$USER}"

echo "Docker installed: $(docker --version)"
echo "Log out and back in for group membership to take effect."
