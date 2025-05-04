#!/bin/sh

#Only meant for demo to install aws sam cli on Amazon Linux 2023 AMI on x86 arch

curl -Lo aws-sam-cli-linux-x86_64.zip https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip
sudo ./install

sam --version
