#!/usr/bin/env bash

set -e

echo "===================================="
echo "Installing required dependencies..."
echo "===================================="

sudo apt-get update

sudo apt-get install -y \
  ca-certificates \
  curl \
  git \
  jq \
  unzip \
  openssl

echo "===================================="
echo "Dependencies installed successfully."
echo "===================================="