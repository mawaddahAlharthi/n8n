#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOYMENT_DIR="$(dirname "$SCRIPT_DIR")"
DOCKER_DIR="$DEPLOYMENT_DIR/docker"

echo "===================================="
echo "Redeploying n8n stack..."
echo "===================================="

cd "$DOCKER_DIR"

# Make sure the environment configuration exists
if [ ! -f ".env" ]; then
    echo "ERROR: .env file does not exist."
    echo "Run 03_configure_env.sh first."
    exit 1
fi

# Pull the configured Docker images
docker compose pull

# Recreate/update services if required
docker compose up -d --remove-orphans

echo ""
echo "===================================="
echo "Current container status:"
echo "===================================="

docker compose ps

echo ""
echo "Redeployment completed successfully."