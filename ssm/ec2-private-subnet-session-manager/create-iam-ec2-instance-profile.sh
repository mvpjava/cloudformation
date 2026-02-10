#!/bin/sh

STACK_NAME="ec2-iam-instance-profile-session-manager"
CFN_TEMPLATE_FILE="iam-ec2-instance-profile.yml"

aws cloudformation validate-template --template-body file://"$CFN_TEMPLATE_FILE" && \
aws cloudformation create-stack \
  --stack-name "$STACK_NAME" \
  --template-body file://"$CFN_TEMPLATE_FILE" \
  --capabilities CAPABILITY_NAMED_IAM
