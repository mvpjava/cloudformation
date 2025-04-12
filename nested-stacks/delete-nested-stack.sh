#!/bin/sh

STACK_NAME=nested-stack-demo

aws cloudformation delete-stack --stack-name $STACK_NAME

echo "Waiting for stack to be deleted ..."

aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME

