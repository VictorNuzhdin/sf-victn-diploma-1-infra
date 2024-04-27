#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR

SSH_USER="ubuntu"
SSH_PORT="22"
SSH_HOST="$(jq -r '.outputs.monitor_external_ip.value' terraform.tfstate)"


##
ssh -o StrictHostKeyChecking=no -p $SSH_PORT $SSH_USER@$SSH_HOST
