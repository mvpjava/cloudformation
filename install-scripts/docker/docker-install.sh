#!/bin/bash

# Docker repository URL
DOCKER_REPO_URL="https://download.docker.com/linux/centos/docker-ce.repo"

# Step 1: Uninstall old versions
echo "Uninstalling old versions of Docker..."
# Handle cases where Docker is not installed, using || true to suppress errors. 
# Ensures script continues without exiting if no Docker packages are present.
sudo dnf remove -y \
    docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine || true

# Step 2: Set up the repository
echo "Setting up the Docker repository..."
sudo dnf -y install dnf-plugins-core
if [ $? -ne 0 ]; then
    echo "Failed to install dnf-plugins-core. Exiting."
    exit 1
fi

sudo dnf config-manager --add-repo $DOCKER_REPO_URL
if [ $? -ne 0 ]; then
    echo "Failed to add Docker repository. Exiting."
    exit 1
fi

# Step 3: Install Docker Engine
echo "Installing Docker Engine..."
sudo dnf install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin
if [ $? -ne 0 ]; then
    echo "Failed to install Docker Engine. Exiting."
    exit 1
fi

# Step 4: Start Docker Engine
echo "Starting and enabling Docker Engine..."
sudo systemctl enable --now docker
if [ $? -ne 0 ]; then
    echo "Failed to start Docker Engine. Exiting."
    exit 1
fi

# Verify installation
echo "Verifying Docker installation by running hello-world..."
sudo docker run hello-world
if [ $? -ne 0 ]; then
    echo "Failed to run Docker hello-world. Exiting."
    exit 1
fi

# Step 5: Fix Docker socket permissions
echo "Adding current user '$USER' to the docker group to fix permissions..."
sudo usermod -aG docker $USER
newgrp docker # apply group changes

if [ $? -ne 0 ]; then
    echo "Failed to add user to the docker group. Exiting."
    exit 1
fi

echo "Docker installation completed successfully."