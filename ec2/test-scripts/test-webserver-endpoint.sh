#!/bin/sh -xe

echo "Testing webserver endpoint"

#Retrieve Stackname from taskcat which all start with 'tCaT'. This is a simple test and should be made more robust
#as more than 1 CloudFormation template could start with this but for this demo, it will do.
STACK_NAME=$(aws cloudformation describe-stacks --query "Stacks[?starts_with(StackName, 'tCaT')].StackName" --output text)

# Retrieve output parameter 'PublicIP' for testing
PUBLIC_IP=$(aws cloudformation describe-stacks \
  --stack-name $STACK_NAME \
  --query "Stacks[0].Outputs[?OutputKey=='PublicIP'].OutputValue" \
  --output text)

http_status=$(curl -s -o /dev/null -w "%{http_code}" $PUBLIC_IP)

# Check if the status code is 200 (OK)
if [ $http_status -eq 200 ]; then
    echo "webserver endpoint test is a SUCCESS. HTTP status code: $http_status"
    exit 0
else
    echo "webserver endpoint FAILED with HTTP status code: $http_status"
    exit 1
fi

exit 1
