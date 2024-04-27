#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR
#
SECRETS_DIR='protected'


#..clearing console
clear

##..ALL_IN_ONE
terraform validate
terraform destroy -var-file="$SECRETS_DIR/protected.tfvars" -target="module.instances.yandex_compute_instance.k8s-master" -target="module.instances.null_resource.k8s-masters-provisioner" -target="output.k8s_masters_ip_external" --auto-approve


##..destroy (manual))
#cd terraform; terraform destroy -var-file="protected/protected.tfvars" -target="module.instances.yandex_compute_instance.k8s-master" -target="module.instances.null_resource.k8s-masters-provisioner" -target="output.k8s_masters_ip_external" --auto-approve; cd ..
