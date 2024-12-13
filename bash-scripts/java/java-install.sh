#!/bin/sh 

# meant for a Centos x86 arch and java with jdk dev tools
# taken from: https://docs.aws.amazon.com/corretto/latest/corretto-21-ug/downloads-list.html
# Instructions taken from https://docs.aws.amazon.com/corretto/latest/corretto-21-ug/amazon-linux-install.html
# Download and Install RPMs Manually
# Will be installed in /usr/lib/jvm/java-21-amazon-corretto

RPM_FILENAME="amazon-corretto-21-x64-linux-jdk.rpm"
RPM_URL="https://corretto.aws/downloads/latest/${RPM_FILENAME}"

echo "RPM_URL= $RPM_URL"

# Update the system
sudo dnf update -y

# Download the Amazon Corretto JDK RPM (curl -L follows redirects)
echo "Downloading Amazon Corretto Java JDK 21 .rpm to the current directory..."
curl -Lo "${RPM_FILENAME}" "${RPM_URL}"

# Verify if the download was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to download ${RPM_FILENAME}"
    exit 1
fi

# Check if the downloaded file is not empty
if [ ! -s "${RPM_FILENAME}" ]; then
    echo "Error: Downloaded file ${RPM_FILENAME} is empty."
    exit 1
fi

# Install the RPM package
echo "Installing Java ..."
sudo dnf localinstall -y "${RPM_FILENAME}"

# Verify if the installation was successful

if [ $? -eq 0 ]; then
    echo "Amazon Corretto Java JDK 21 installed successfully!"
else
    echo "Error: Failed to install ${RPM_FILENAME}"
    exit 1
fi
java  --version

# The following is commented out on purpose in case you want to run these command manually. If ever you had multiple java version installed
# If you see a version string that doesn't mention Corretto, run the following command to change the default java or javac providers. 
# sudo alternatives --config java
# If using the JDK you should also run:
# sudo alternatives --config javac

echo "$0 Complete"
