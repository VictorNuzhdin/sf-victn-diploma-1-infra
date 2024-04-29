#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR
#
SECRETS_DIR='protected'


#..clearing console
clear

##..create Kubernetes Worker NODEs only
#
terraform validate
terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target="module.cluster.yandex_compute_instance.k8s-worker" -target="module.cluster.null_resource.k8s-workers-provisioner" -target="output.k8s_workers_ip_external"
terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target="module.cluster.yandex_compute_instance.k8s-worker" -target="module.cluster.null_resource.k8s-workers-provisioner" -target="output.k8s_workers_ip_external" --auto-approve


##..OUTPUTS_CHECKS
echo ""
echo "--WORKERS_OUTPUT_CHECKS"
echo "\"k8s_worker0_external_ipv4_address\": \"$(cat terraform.tfstate | jq -r -c '.resources[] | select ( .name == "k8s-worker")'.instances[0].attributes.network_interface[0].nat_ip_address)\""
echo
