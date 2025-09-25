#!/bin/bash
set -e

echo "[INFO] Updating system packages..."
sudo dnf update -y

# Check for Python3
if command -v python3 >/dev/null 2>&1; then
    echo "[INFO] Python3 is already installed: $(python3 --version)"
else
    echo "[INFO] Installing Python3..."
    sudo dnf install -y python3
fi

# Check for pip3
if command -v pip3 >/dev/null 2>&1; then
    echo "[INFO] pip3 is already installed: $(pip3 --version)"
else
    echo "[INFO] Installing pip3..."
    sudo dnf install -y python3-pip
fi

# Install setuptools if not installed
if ! python3 -c "import setuptools" >/dev/null 2>&1; then
    echo "[INFO] Installing python3-setuptools..."
    sudo dnf install -y python3-setuptools
else
    echo "[INFO] setuptools is already installed"
fi

# Check if ansible is installed system-wide
if command -v ansible >/dev/null 2>&1; then
    echo "[INFO] Ansible is already installed: $(ansible --version | head -n1)"
else
    echo "[INFO] Installing system-wide Ansible..."
    sudo dnf install -y ansible
fi

# Verify Ansible installation
echo "[INFO] Verifying Ansible installation..."
ansible --version

# Install amazon.aws collection if not already installed
if ! ansible-galaxy collection list | grep -q "amazon.aws"; then
    echo "[INFO] Installing amazon.aws collection..."
    sudo ansible-galaxy collection install amazon.aws:5.4.0
else
    echo "[INFO] amazon.aws collection is already installed"
fi

echo "[SUCCESS] System-wide Ansible installation complete!"
echo "[INFO] You can now use dynamic EC2 inventory with IAM role authentication."

