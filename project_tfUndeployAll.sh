#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR

CONFIG_DIR='configs'
SECRETS_DIR='protected'


##..check if cloud-init config is exists; if not - create an empty one
##  *this trick supress error when "terraform destroy" executes, when file is not exists
test -e $CONFIG_DIR/cloud-init.yaml && echo "file exists" || touch $CONFIG_DIR/cloud-init.yaml

##..destroy cloud resources
clear; terraform destroy -var-file="$SECRETS_DIR/protected.tfvars" --auto-approve

##..remove cloud-init config
rm -f $CONFIG_DIR/cloud-init.yaml
