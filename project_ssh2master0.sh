#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR

SSH_USER="ubuntu"
SSH_PORT="22"


##..tests
# ssh ubuntu@51.250.30.49 -p 22 -i ~/.ssh/id_ed25519
# ssh ubuntu@51.250.30.49 -o StrictHostKeyChecking=no -p 22 -i ~/.ssh/id_ed25519
#
# echo $(jq '.outputs' terraform.tfstate)                                        # { "k8s_masters_ip_external": { "value": [ [ "51.250.30.49" ] ], "type": [ "tuple", [ [ "tuple", [ "string" ] ] ] ] }, "k8s_workers_ip_external": { "value": [ [ "130.193.41.24", "84.252.136.128" ] ], "type": [ "tuple", [ [ "tuple", [ "string", "string" ] ] ] ] } }
# echo $(jq -r '.outputs.k8s_masters_ip_external' terraform.tfstate)             # { "value": [ [ "51.250.30.49" ] ], "type": [ "tuple", [ [ "tuple", [ "string" ] ] ] ] }
# echo $(jq '.outputs.k8s_masters_ip_external[]' terraform.tfstate)              # [ [ "51.250.30.49" ] ] [ "tuple", [ [ "tuple", [ "string" ] ] ] ]
# echo $(jq '.outputs.k8s_masters_ip_external[][]' terraform.tfstate)            # [ "51.250.30.49" ] "tuple" [ [ "tuple", [ "string" ] ] ]
# echo $(jq '.outputs.k8s_masters_ip_external[][0]' terraform.tfstate)           # [ "51.250.30.49" ] "tuple"
#
# echo $(jq -r '.outputs.k8s_masters_ip_external' terraform.tfstate)             # { "value": [ [ "51.250.30.49" ] ], "type": [ "tuple", [ [ "tuple", [ "string" ] ] ] ] }
# echo $(jq -r '.outputs.k8s_masters_ip_external.value' terraform.tfstate)       # [ [ "51.250.30.49" ] ]
# echo $(jq -r '.outputs.k8s_masters_ip_external.value[][]' terraform.tfstate)   # 51.250.30.49
# echo $(jq -r '.outputs.k8s_masters_ip_external.value[][0]' terraform.tfstate)  # 51.250.30.49
# echo $(jq -r '.outputs.k8s_masters_ip_external.value[][1]' terraform.tfstate)  # null
#

##..finally v1
#SSH_HOST="$(jq -r '.outputs.k8s_masters_ip_external.value[][0]' terraform.tfstate)"

##..finally v2
SSH_HOST="$(cat terraform.tfstate | jq -r -c '.resources[] | select ( .name == "k8s-master")'.instances[0].attributes.network_interface[0].nat_ip_address)"

ssh -o StrictHostKeyChecking=no -p $SSH_PORT $SSH_USER@$SSH_HOST
