#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR
#
SECRETS_DIR='protected'


#..clearing console
clear

##..create Kubernetes Master/ControlPlane NODEs only
#
terraform validate
terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target="module.cluster.yandex_compute_instance.k8s-master" -target="module.cluster.null_resource.k8s-masters-provisioner" -target="output.k8s_masters_ip_external"
terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target="module.cluster.yandex_compute_instance.k8s-master" -target="module.cluster.null_resource.k8s-masters-provisioner" -target="output.k8s_masters_ip_external" --auto-approve


##..OUTPUTS_CHECKS
echo ""
echo "--OUTPUTS"
echo "\"k8s_master0_external_ipv4_address\": \"$(cat terraform.tfstate | jq -r -c '.resources[] | select ( .name == "k8s-master")'.instances[0].attributes.network_interface[0].nat_ip_address)\""
