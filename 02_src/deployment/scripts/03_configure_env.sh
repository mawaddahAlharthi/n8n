#!/usr/bin/env bash

set -e

# ------------------------------------------------------------
# Determine project paths
# ------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOYMENT_DIR="$(dirname "$SCRIPT_DIR")"

ENV_FILE="$DEPLOYMENT_DIR/docker/.env"


echo "===================================="
echo "Configuring environment variables..."
echo "===================================="


# ------------------------------------------------------------
# Prevent overwriting an existing environment file
# ------------------------------------------------------------

if [ -f "$ENV_FILE" ]; then
    echo ""
    echo ".env already exists."
    echo "No changes were made."
    echo "Existing file: $ENV_FILE"
    exit 0
fi


# ------------------------------------------------------------
# Generate secure random credentials
# ------------------------------------------------------------

POSTGRES_PASSWORD=$(openssl rand -hex 24)
N8N_ENCRYPTION_KEY=$(openssl rand -hex 32)


# ------------------------------------------------------------
# Create the runtime .env file
# ------------------------------------------------------------

cat > "$ENV_FILE" <<EOF
# ===============================
# n8n Configuration
# ===============================

N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http
WEBHOOK_URL=http://localhost:5678/

GENERIC_TIMEZONE=Asia/Riyadh
N8N_VERSION=2.40.6


# ===============================
# PostgreSQL Configuration
# ===============================

POSTGRES_DB=n8n
POSTGRES_USER=n8n
POSTGRES_PASSWORD=$POSTGRES_PASSWORD


# ===============================
# n8n Security
# ===============================

N8N_ENCRYPTION_KEY=$N8N_ENCRYPTION_KEY
EOF


# ------------------------------------------------------------
# Restrict access to the environment file
# ------------------------------------------------------------

chmod 600 "$ENV_FILE"


# ------------------------------------------------------------
# Confirmation
# ------------------------------------------------------------

echo ""
echo "===================================="
echo "Environment configuration completed"
echo "===================================="

echo ""
echo "Environment file created successfully:"
echo "$ENV_FILE"

echo ""
echo "File permissions:"
ls -l "$ENV_FILE"

echo ""
echo "Security note:"
echo "The generated .env file contains secrets."
echo "Do NOT commit it to Git or include its contents in reports."