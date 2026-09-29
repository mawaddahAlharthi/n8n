#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOYMENT_DIR="$(dirname "$SCRIPT_DIR")"
DOCKER_DIR="$DEPLOYMENT_DIR/docker"

echo "===================================="
echo "Stopping n8n environment..."
echo "===================================="

cd "$DOCKER_DIR"

docker compose down

echo ""
echo "===================================="
echo "Cleanup completed."
echo "Persistent data volumes were NOT deleted."
echo "===================================="