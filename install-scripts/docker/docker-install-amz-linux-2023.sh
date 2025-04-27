#!/bin/bash

set -e

echo "Updating packages..."
sudo dnf update -y

echo "Installing required packages..."
sudo dnf install -y \
    docker \
    git \
    bash-completion

echo "Starting and enabling Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "Adding your user ($USER) to the docker group..."
sudo usermod -aG docker "$USER"

echo "Setting up Docker CLI auto-completion..."
# This enables docker auto-complete in your shell
DOCKER_COMPLETION_FILE="/etc/bash_completion.d/docker"
if [ ! -f "$DOCKER_COMPLETION_FILE" ]; then
    echo "Downloading Docker bash completion script..."
    sudo curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/bash/docker -o "$DOCKER_COMPLETION_FILE"
fi

echo "Reloading bash completion..."
source /etc/profile.d/bash_completion.sh || true
source "$DOCKER_COMPLETION_FILE" || true

echo "All done! You may need to log out and log back in for group changes to take effect."
echo "Test docker is installed with: docker version"
