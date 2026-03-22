#!/usr/bin/env bash
# build-dev-base.sh
# Builds the shared dev-base:latest Docker image used by all devcontainers.
# Run this once after cloning vmbox, or after updating the Dockerfile.
# Requires: sudo-less docker access (user in docker group)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKERFILE="$SCRIPT_DIR/../templates/devcontainer/Dockerfile"

echo "Building dev-base:latest..."
docker build -t dev-base:latest -f "$DOCKERFILE" "$(dirname "$DOCKERFILE")"
echo "Done. Run 'docker images dev-base' to verify."
