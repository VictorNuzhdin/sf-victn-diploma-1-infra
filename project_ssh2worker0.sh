#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR

SSH_USER="ubuntu"
SSH_PORT="22"


##..tests
# ssh ubuntu@130.193.41.24 -p 22 -i ~/.ssh/id_ed25519
# ssh ubuntu@130.193.41.24 -o StrictHostKeyChecking=no -p 22 -i ~/.ssh/id_ed25519
#
# echo $(jq '.outputs' terraform.tfstate)                                         # { "k8s_workers_ip_external": { "value": [ [ "51.250.30.49" ] ], "type": [ "tuple", [ [ "tuple", [ "string" ] ] ] ] }, "k8s_workers_ip_external": { "value": [ [ "130.193.41.24", "84.252.136.128" ] ], "type": [ "tuple", [ [ "tuple", [ "string", "string" ] ] ] ] } }
# echo $(jq -r '.outputs.k8s_workers_ip_external' terraform.tfstate)              # { "value": [ [ "130.193.41.24", "84.252.136.128" ] ], "type": [ "tuple", [ [ "tuple", [ "string", "string" ] ] ] ] }
# echo $(jq -r '.outputs.k8s_workers_ip_external.value[][0]' terraform.tfstate)   # 130.193.41.24
#

##..finally
SSH_HOST="$(jq -r '.outputs.k8s_workers_ip_external.value[][0]' terraform.tfstate)"

ssh -o StrictHostKeyChecking=no -p $SSH_PORT $SSH_USER@$SSH_HOST
