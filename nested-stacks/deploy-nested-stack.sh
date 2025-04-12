#!/bin/sh

STACK_NAME=nested-stack-demo
ROOT_CFN_TEMPLATE=main.yaml
echo "Creating Stack"

./validate-template.sh "$ROOT_CFN_TEMPLATE" || { echo "CloudFormation template Validation failed"; exit 1; }

# Adding the --capabilities CAPABILITY_NAMED_IAM option tells CloudFormation that you’re aware the stack will create or modify IAM resources. This is a security precaution to prevent accidental modifications to IAM roles and permissions.
#
aws cloudformation create-stack \
  --stack-name $STACK_NAME  \
  --region eu-west-2 \
  --template-body file://main.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters \
    ParameterKey=AvailabilityZones,ParameterValue="eu-west-2a \, eu-west-2b" \
    ParameterKey=EnvironmentType,ParameterValue=Test \
    ParameterKey=PublicSubnet1Cidr,ParameterValue=10.0.0.0/24 \
    ParameterKey=PublicSubnet2Cidr,ParameterValue=10.0.1.0/24 \
    ParameterKey=VPCCidr,ParameterValue=10.0.0.0/16 \
    ParameterKey=VPCName,ParameterValue=nested-stack-vpc


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
WEBSITE_URL=$(aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --query "Stacks[0].Outputs[?OutputKey=='WebsiteURL'].OutputValue" \
  --output text)

echo " WEBSITE_URL = $WEBSITE_URL"
set -x
curl $WEBSITE_URL

echo "Complete."
