#!/bin/bash -e

# Script installs latest version of Terraform on centos/RHEL distros.
echo "test"

# Verify the script is running on a supported OS (CentOS/RHEL)
if ! grep -Ei "(centos|rhel)" /etc/os-release > /dev/null 2>&1; then
    echo "This script is only supported on CentOS/RHEL Linux distributions." >&2
    exit 1
fi

# HashiCorp repository
HASHICORP_REPO="https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo"

sudo yum install -y yum-utils

# Add the official HashiCorp repository to yum configuration
echo "Adding the HashiCorp repository..."
if ! sudo yum-config-manager --add-repo $HASHICORP_REPO; then
    echo "Failed to add HashiCorp repository. Exiting." >&2
    exit 1
fi

# Install Terraform based on the specified or default version
echo "Installing the latest version of Terraform..."
if ! sudo yum install -y terraform; then
	echo "Failed to install the latest version of Terraform. Exiting." >&2
	exit 1
fi

# Display the installed version of Terraform
terraform --version

# Enable tab completion for Terraform commands
echo "Enabling tab completion for Terraform..."
touch ~/.bashrc  # Ensure the .bashrc file exists

# The following command enables autocomplete functionality in the shell
eval "$(terraform -install-autocomplete)"

# Define common Terraform aliases to simplify command usage
ALIASES=(
    "alias tfi='terraform init'"       # Alias for initializing a Terraform project
    "alias tfa='terraform apply'"      # Alias for applying Terraform changes
    "alias tfp='terraform plan'"       # Alias for creating an execution plan
    "alias tfd='terraform destroy'"    # Alias for destroying Terraform-managed resources
    "alias tfv='terraform validate'"   # Alias for validating Terraform configurations
    "alias tff='terraform fmt'"        # Alias for formatting Terraform code
)

# Append the aliases to the .bashrc file if they do not already exist
echo "Adding Terraform aliases to .bashrc..."

# grep options used:
# -F: Treat the search pattern ($ALIAS) as a fixed string, not a regular expression. 
#     This ensures that special characters in the alias (like =) are treated literally.
# -x: Matches only if the entire line in the file is identical to the search pattern. 
#      This ensures no partial matches are considered.
# -q: Suppresses all output from grep.
# Will only add specific alias in .bashrc if not already there
for ALIAS in "${ALIASES[@]}"; do
    if ! grep -Fxq "$ALIAS" ~/.bashrc; then
        echo "$ALIAS" >> ~/.bashrc
    fi
done

# Final message to the user
echo "Terraform installation and setup are complete."
echo "Restart your terminal or run 'source ~/.bashrc' to apply changes."
