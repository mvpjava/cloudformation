#!/bin/sh

#Only meant for demo to install aws sam cli on Amazon Linux 2023 AMI on x86 arch

yum install git -y
yum install tree -y
sudo yum install python3.9-pip #  Amz Linux 2023  comes with Python 3.9 pre-installed so, get associated pip needed to

# get sam cli
curl -Lo aws-sam-cli-linux-x86_64.zip https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip
sudo ./install

sam --version
