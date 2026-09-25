#!/usr/bin/env bash

set -e

echo "===================================="
echo "Installing Docker and Docker Compose"
echo "===================================="

# Update package index
sudo apt-get update

# Install packages required to use Docker repository
sudo apt-get install -y \
  ca-certificates \
  curl

# Create directory for Docker's GPG key
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker's official GPG key
sudo curl -fsSL \
  https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker's official repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again after adding Docker repository
sudo apt-get update

# Install Docker Engine, CLI, and Docker Compose
sudo apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

# Start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Add current user to docker group
sudo usermod -aG docker "$USER"

echo ""
echo "===================================="
echo "Docker installation completed"
echo "===================================="

echo ""
echo "Docker version:"
sudo docker --version

echo ""
echo "Docker Compose version:"
sudo docker compose version

echo ""
echo "IMPORTANT:"
echo "Log out and reconnect to SSH before using Docker without sudo."