#!/bin/bash
# User Data Script for Amazon Linux 2023 to install Jenkins Controller
# Refer to docs: https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/#installing-and-configuring-jenkins

# ------------------------------
# Update the systemtall
# -------------------------------
sudo dnf update -y

# -------------------------------
#  Add Jenkins repository and import GPG key
# -------------------------------
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

sudo dnf upgrade -y

# -------------------------------
#  Install Java 21 (required for Jenkins) anf git
# -------------------------------
sudo dnf install -y java-21-amazon-corretto
sudo dnf install -y git
sudo dnf install -y python3-pip


# -------------------------------
#  Install Jenkins
# -------------------------------
sudo dnf install -y jenkins -y

# -------------------------------
#  Start and enable Jenkins service
# -------------------------------
sudo systemctl enable jenkins
sudo systemctl start jenkins
#sudo systemctl status jenkins --no-pager -l

sudo systemctl is-active jenkins

# -------------------------------
#  Print Jenkins version
# -------------------------------
echo "Installed Jenkins version:"
sudo rpm -qi jenkins | grep Version
echo "Jenkins installation completed!"

echo "Connect to http://<your_server_public_DNS>:8080 from your browser"
echo "Enter the initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
