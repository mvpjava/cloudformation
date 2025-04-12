#!/bin/sh

# Check if the required number of parameters is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <Cloudformation template name>"
  exit 1
fi

CFN_TEMPLATE_NAME=$1

echo "Starting $0"

aws cloudformation validate-template --output table --template-body file://$1

echo "$0 Complete."
