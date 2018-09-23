#!/bin/bash

# Setup environment variables
export AWS_REGION=us-east-1
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

cd ../terraform/dev
echo "### CREATING WEBSERVER ###"
terraform init
terraform apply -auto-approve
terraform output --json > ../test/verify-aws/files/terraform.json
terraform output --json > ../test/verify-website/files/terraform.json

cd ..
echo "### RUNNING AWS VALIDATION ###"
inspec exec test/verify-aws -t aws://
echo "### RUNNING WEBSITE VALIDATION ###"
inspec exec test/verify-website