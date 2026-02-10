#!/bin/sh

STACK_NAME="ec2-iam-instance-profile-session-manager"

aws cloudformation delete-stack --stack-name "$STACK_NAME"

echo "Waiting to be deleted ..."
aws cloudformation wait stack-delete-complete --stack-name "$STACK_NAME"
echo "Stack $STACK_NAME successfully deleted."
