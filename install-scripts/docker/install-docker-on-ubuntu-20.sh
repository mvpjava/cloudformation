#!/usr/bin/env bash

# Exit immediately if a command fails
set -e

TARGET_USER="ubuntu"

# Function to install Docker Engine & Enable Autocomplete
install_docker() {
    echo "=========================================="
    echo "Starting Docker Installation..."
    echo "=========================================="

    echo "[1/7] Updating apt package index..."
    sudo apt update -y

    echo "[2/7] Installing prerequisites and bash-completion..."
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common bash-completion

    echo "[3/7] Adding Docker's official GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    echo "[4/7] Adding Docker repository to APT sources..."
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" -y

    echo "[5/7] Installing Docker Engine & CLI..."
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    echo "[6/7] Adding user '$TARGET_USER' to the 'docker' group..."
    if id "$TARGET_USER" &>/dev/null; then
        sudo usermod -aG docker "$TARGET_USER"
    else
        echo "Warning: User '$TARGET_USER' does not exist on this machine. Adding current user ($USER) instead."
        sudo usermod -aG docker "$USER"
    fi

    echo "[7/7] Configuring Docker bash auto-completion..."
    sudo docker completion bash | sudo tee /etc/bash_completion.d/docker > /dev/null

    echo "=========================================="
    echo "Docker installed successfully!"
    echo "Status check:"
    sudo systemctl status docker --no-pager | head -n 5
    echo "=========================================="
    echo "NOTE FOR USER '$TARGET_USER':"
    echo "1. Run 'exec su - $TARGET_USER' (or log out and back in) to apply group changes."
    echo "2. Autocomplete is enabled globally! Run 'source /etc/bash_completion' or open a new terminal session."
}

# Function to completely purge Docker from Ubuntu 20.04
uninstall_docker() {
    echo "=========================================="
    echo "Starting Docker Uninstallation..."
    echo "=========================================="

    echo "[1/5] Stopping Docker service..."
    sudo systemctl stop docker.socket || true
    sudo systemctl stop docker || true

    echo "[2/5] Purging Docker packages..."
    sudo apt purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin || true
    sudo apt autoremove -y --purge

    echo "[3/5] Removing Docker directories (containers, images, volumes)..."
    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd
    sudo rm -rf /etc/docker

    echo "[4/5] Removing Docker APT source and keyring..."
    sudo rm -f /etc/apt/sources.list.d/archive_uri-https_download_docker_com_linux_ubuntu-focal.list
    sudo apt-key del 0EBFCD88 2>/dev/null || true

    echo "[5/5] Removing Docker auto-completion..."
    sudo rm -f /etc/bash_completion.d/docker

    echo "=========================================="
    echo "Docker has been completely removed."
    echo "=========================================="
}

# Main script logic - parse input argument
case "$1" in
    install)
        install_docker
        ;;
    uninstall)
        uninstall_docker
        ;;
    *)
        echo "Usage: $0 {install|uninstall}"
        exit 1
        ;;
esac
