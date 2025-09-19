#!/bin/sh 

# Install maven
# Pre-requisite: Java pre-installed
# Ref: https://tecadmin.net/install-apache-maven-on-centos/


MVN_FILENAME="apache-maven-3.9.11-bin.tar.gz"
MVN_URL="https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/${MVN_FILENAME}"
cd /tmp


# Extract Maven version from the filename
# -o: Stands for "only matching." Ensures that grep outputs only the part of the line that matches the pattern, rather than the whole line.
# -P: Enables Perl-compatible regular expressions (PCRE), which allow advanced regex features such as lookaheads and lookbehinds.
#'apache-maven-[0-9]+\.[0-9]+\.[0-9]+':
#    This is the regular expression to match the Maven version prefix (apache-maven-) followed by a semantic version number. Here's a breakdown:
#        apache-maven-: Matches the literal string "apache-maven-".
#        [0-9]+: Matches one or more digits (e.g., "3").
#        \.: Matches a literal period (".").
#        [0-9]+: Matches one or more digits after the period (e.g., "9").
#        Repeats: The above pattern repeats for another segment (e.g., "6").
#        Example match: "apache-maven-3.9.9".
MAVEN_VERSION=$(echo "$MVN_FILENAME" | grep -oP 'apache-maven-[0-9]+\.[0-9]+\.[0-9]+')
M2_HOME="/opt/${MAVEN_VERSION}"

# Function to set up Maven environment variables
configure_maven_env() {
    PROFILE_FILE="/etc/profile.d/maven.sh"
    
    echo "Configuring Maven environment variables..."
    
    sudo touch $PROFILE_FILE 
    sudo bash -c "echo export M2_HOME=$M2_HOME > $PROFILE_FILE"
    sudo bash -c "echo export PATH=$M2_HOME/bin:$PATH >> $PROFILE_FILE"

    # Make the script executable
    sudo chmod +x "$PROFILE_FILE"
    
    # Load the new environment variables
    source "$PROFILE_FILE"
    
    # Verify the environment variables are set
    if [[ "$PATH" == *"${M2_HOME}/bin"* ]]; then
        echo "Maven environment variables have been configured successfully."
    else
        echo "Error: Failed to configure Maven environment variables."
        exit 1
    fi
}

# Function to download and install Maven
install_maven() {
    echo "Downloading Maven..."
    curl -Lo "${MVN_FILENAME}" "${MVN_URL}"

    if [ $? -ne 0 ]; then
        echo "Error: Failed to download Maven from $MVN_URL."
        exit 1
    fi

    # Check if the downloaded file is not empty
    if [ ! -s "${MVN_FILENAME}" ]; then
        echo "Error: Downloaded file ${MVN_URL} is empty."
        exit 1
    fi

    echo "Extracting Maven file: $MVN_FILENAME..."
    sudo tar xzf "$MVN_FILENAME" -C /opt/
    if [ $? -eq 0 ]; then
        echo "Maven has been successfully extracted to /opt/${MAVEN_VERSION}."
    else
        echo "Error: Failed to extract Maven."
        exit 1
    fi
}

############################################################################
################################## MAIN ####################################
############################################################################


echo "Installing maven ..."

# Check if java is installed
if ! java -version &>/dev/null; then
    echo "Error: Java is not installed. Please install Java before installing Maven."
    exit 1
else
    echo "java is installed. Pre-requisite meet."
fi
# Update the system
sudo dnf update -y

install_maven

configure_maven_env

echo "Verifying Maven installation..."
if mvn -version &>/dev/null; then
    echo "Maven is installed and configured correctly."
    mvn -version
else
    echo "Error: Maven installation verification failed."
    exit 1
fi
