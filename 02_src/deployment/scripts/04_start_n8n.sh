#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOYMENT_DIR="$(dirname "$SCRIPT_DIR")"
DOCKER_DIR="$DEPLOYMENT_DIR/docker"

echo "===================================="
echo "Starting n8n stack..."
echo "===================================="

# Move to Docker Compose directory
cd "$DOCKER_DIR"

# Check that the real .env file exists
if [ ! -f ".env" ]; then
    echo "ERROR: .env file does not exist."
    echo "Run 03_configure_env.sh first."
    exit 1
fi

# Pull required Docker images
docker compose pull

# Start services in the background
docker compose up -d

echo ""
echo "===================================="
echo "Running containers:"
echo "===================================="

docker compose ps

echo ""
echo "n8n stack started successfully."