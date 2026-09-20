#!/bin/sh -xe

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <AWS_REGION>"
  exit 1
fi

REGION=$1

echo "========================================"
echo "TaskCat Webserver Tests"
echo "Region: $REGION"
echo "========================================"

STACK_NAMES=$(aws cloudformation --region "$REGION" describe-stacks \
  --query "Stacks[?starts_with(StackName, 'tCaT') && StackStatus != 'DELETE_COMPLETE'].StackName" \
  --output text)

if [ -z "$STACK_NAMES" ]; then
    echo "ERROR: No TaskCat CloudFormation stacks found in $REGION"
    exit 1
fi

FAILED=0
TESTED=0

for STACK_NAME in $STACK_NAMES; do

    echo ""
    echo "========================================"
    echo "Testing stack: $STACK_NAME"
    echo "========================================"

    TESTED=$((TESTED + 1))

    # Retrieve PublicIP CloudFormation output
    PUBLIC_IP=$(aws cloudformation --region "$REGION" describe-stacks \
      --stack-name "$STACK_NAME" \
      --query "Stacks[0].Outputs[?OutputKey=='PublicIP'].OutputValue" \
      --output text)

    if [ -z "$PUBLIC_IP" ] || [ "$PUBLIC_IP" = "None" ]; then
        echo "ERROR: No PublicIP output for $STACK_NAME"
        FAILED=$((FAILED + 1))
        continue
    fi

    echo "Public IP: $PUBLIC_IP"

    # Test HTTP endpoint
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
      --connect-timeout 10 \
      --max-time 30 \
      "http://$PUBLIC_IP")

    if [ "$HTTP_STATUS" -eq 200 ]; then
        echo "SUCCESS: $STACK_NAME returned HTTP $HTTP_STATUS"
    else
        echo "FAILED: $STACK_NAME returned HTTP $HTTP_STATUS"
        FAILED=$((FAILED + 1))
    fi

done

echo ""
echo "========================================"
echo "TaskCat Test Summary"
echo "========================================"
echo "Stacks tested: $TESTED"
echo "Failures:      $FAILED"
echo "========================================"

if [ "$FAILED" -eq 0 ]; then
    echo "ALL WEBSERVER TESTS PASSED"
    exit 0
else
    echo "WEBSERVER TESTS FAILED"
    exit 1
fi
