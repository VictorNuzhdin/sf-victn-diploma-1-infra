#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR

SSH_USER="ubuntu"
SSH_PORT="22"


##..getting 1st Kubernetes Master host current public IPv4 address from Terraform State
SSH_HOST="$(cat terraform.tfstate | jq -r -c '.resources[] | select ( .name == "k8s-master")'.instances[0].attributes.network_interface[0].nat_ip_address)"

##..make ssh connection to K8S Master host
ssh -o StrictHostKeyChecking=no -p $SSH_PORT $SSH_USER@$SSH_HOST
