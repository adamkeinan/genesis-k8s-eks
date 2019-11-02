#!/bin/bash
if [[ $# -eq 0 ]]; then
    echo "Must pass name of CloudFormation Stack as first argument"
    exit 1
else
  echo "Deleting stacks with name *$1*"
  for ng in $(aws cloudformation describe-stacks | jq -r '.[][].StackName' | grep $1); do 
    echo "aws cloudformation delete-stack --stack-name $ng"
    aws cloudformation delete-stack --stack-name $ng
  done
fi
