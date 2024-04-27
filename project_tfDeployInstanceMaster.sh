#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR
#
SECRETS_DIR='protected'


#..clearing console
clear

##..ALL_IN_ONE
terraform validate
terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target="module.instances.yandex_compute_instance.k8s-master" -target="module.instances.null_resource.k8s-masters-provisioner"
terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target="module.instances.yandex_compute_instance.k8s-master" -target="module.instances.null_resource.k8s-masters-provisioner" --auto-approve
#
#terraform destroy -var-file="$SECRETS_DIR/protected.tfvars" -target="module.instances.null_resource.k8s-masters-deploy-provisioner" --auto-approve
terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target="module.instances.null_resource.k8s-masters-deploy-provisioner"
terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target="module.instances.null_resource.k8s-masters-deploy-provisioner" --auto-approve


##..destroy (auto)
#terraform destroy -var-file="$SECRETS_DIR/protected.tfvars" -target="module.instances.yandex_compute_instance.k8s-master" -target="module.instances.null_resource.k8s-masters-provisioner" -target="output.k8s_masters_ip_external" --auto-approve

##..destroy (manual))
#cd terraform; terraform destroy -var-file="protected/protected.tfvars" -target="module.instances.yandex_compute_instance.k8s-master" -target="module.instances.null_resource.k8s-masters-provisioner" -target="output.k8s_masters_ip_external" --auto-approve; cd ..


##..OUTPUTS
##..doesnt_work
#terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target "module.instances.output.k8s_masters_wan_ip" -target="output.k8s_masters_ip_external"
#terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target "module.instances.output.k8s_masters_wan_ip" -target="output.k8s_masters_ip_external" --auto-approve
#
#value = yandex_compute_instance.k8s-master[0].network_interface.0.nat_ip_address
#
#..works_fine
echo ""
echo ""
echo "--OUTPUTS"
echo "\"k8s_master-0_external_ipv4_address\": \"$(cat terraform.tfstate | jq -r -c '.resources[] | select ( .name == "k8s-master")'.instances[0].attributes.network_interface[0].nat_ip_address)\""
