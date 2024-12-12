#!/bin/sh

sudo yum update -y # For Amazon Linux/RedHat-based systems


############################## Install AWS CDK ##############################
# We will use nvm to install Node.js because nvm can install multiple versions of Node.js and allow you to switch between them.
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Load nvm by typing the following at the command line
source ~/.bashrc

# Use nvm to install the latest LTS version of Node.js by typing the following at the command line.
# Installing Node.js also installs the Node Package Manager (npm) so you can install additional modules as needed.
nvm install --lts
node -e "console.log('Running Node.js ' + process.version)"

nvm -v
node -v
npm -v

npm install -g aws-cdk
cdk --version
