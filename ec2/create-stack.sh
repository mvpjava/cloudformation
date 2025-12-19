#!/bin/sh

# Check if the required number of parameters is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <SSH Key Name>"
  exit 1
fi

KEY_NAME_ARG1=$1
STACK_NAME=apache-web-server
CFN_TEMPLATE_FILENAME=cfn-EC2-SG-cfn-init-signal.json

echo "Creating Stack"

./validate-template.sh "$CFN_TEMPLATE_FILENAME" || { echo "CloudFormation template Validation failed"; exit 1; }

# Adding the --capabilities CAPABILITY_NAMED_IAM option tells CloudFormation that you’re aware the stack will create or modify IAM resources. This is a security precaution to prevent accidental modifications to IAM roles and permissions.
aws cloudformation create-stack \
  --stack-name $STACK_NAME  \
  --template-body file://$CFN_TEMPLATE_FILENAME \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
    ParameterKey=KeyName,ParameterValue="$KEY_NAME_ARG1" \
    ParameterKey=InstanceType,ParameterValue=t2.micro \
    ParameterKey=SSHLocation,ParameterValue=0.0.0.0/0

# Check if the last command was successful
if [ $? -ne 0 ]; then
  echo "Previous command failed, exiting $0"
  exit 1
fi

echo "Waiting for Stack to be complete ..."

aws cloudformation wait stack-create-complete \
	    --stack-name $STACK_NAME


echo "testing web server endpoint"
# Retrieve output parameter 'PublicIP' for testing
PUBLIC_IP=$(aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --query "Stacks[0].Outputs[?OutputKey=='PublicIP'].OutputValue" \
  --output text)

set -x
curl http://$PUBLIC_IP

echo "Complete."
