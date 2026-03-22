#!/usr/bin/env bash
# fix-dev-network.sh
# Creates the shared Docker bridge network used by all devcontainers.
# Safe to run multiple times — exits cleanly if network already exists.
set -euo pipefail

NETWORK_NAME="dev-network"

if docker network inspect "$NETWORK_NAME" &>/dev/null; then
  echo "Network '$NETWORK_NAME' already exists."
else
  docker network create "$NETWORK_NAME"
  echo "Network '$NETWORK_NAME' created."
fi
