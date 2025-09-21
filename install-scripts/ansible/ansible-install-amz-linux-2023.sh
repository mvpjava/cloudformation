#!/bin/bash
set -e

# Update package index
echo "[INFO] Updating system packages..."
sudo dnf update -y

# Enable EPEL and required repos
echo "[INFO] Installing dependencies..."
sudo dnf install -y python3 python3-pip python3-setuptools

# Install Ansible from pip (recommended on AL2023)
echo "[INFO] Installing Ansible..."
pip3 install --user ansible

# Add ~/.local/bin to PATH if not already present
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
  export PATH=$PATH:$HOME/.local/bin
fi

# Verify installation
echo "[INFO] Verifying Ansible installation..."
ansible --version

echo "[SUCCESS] Ansible installation complete!"

