#!/bin/bash
set -e

# Step 1: Download and run the official Trivy install script
echo "Downloading and installing Trivy..."
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh


# Step 2: Move the installed binary to /usr/local/bin
echo "Moving Trivy to /usr/local/bin..."
sudo mv ./bin/trivy /usr/local/bin/

# Step 3: Ensure /usr/local/bin is in PATH (optional, just for confirmation)
if ! echo $PATH | grep -q "/usr/local/bin"; then
    echo "Adding /usr/local/bin to PATH..."
    export PATH=$PATH:/usr/local/bin
fi

# Step 4: Verify installation
echo "Verifying Trivy installation..."
trivy --version

echo "Trivy installation completed successfully!"

