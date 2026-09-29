#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOYMENT_DIR="$(dirname "$SCRIPT_DIR")"
DOCKER_DIR="$DEPLOYMENT_DIR/docker"

cd "$DOCKER_DIR"

echo "===================================="
echo "Checking Docker containers..."
echo "===================================="

docker compose ps

echo ""
echo "===================================="
echo "Checking n8n service..."
echo "===================================="

for i in {1..12}
do
    if curl -fsS http://localhost:5678/ > /dev/null; then
        echo ""
        echo "SUCCESS: n8n is reachable."
        echo "URL: http://localhost:5678"
        exit 0
    fi

    echo "Waiting for n8n... attempt $i/12"
    sleep 5
done

echo ""
echo "ERROR: n8n did not become reachable."

echo ""
echo "Recent n8n logs:"
docker compose logs --tail=50 n8n

exit 1