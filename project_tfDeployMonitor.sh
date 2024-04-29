#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR
#
SECRETS_DIR='protected'


#..clearing console
clear

##..create Kubernetes Monitoring Host ONLY (monitor/srv) only
#
terraform validate
terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target="module.monitor.yandex_compute_instance.monitor" -target="module.monitor.null_resource.monitor-provisioner-step00"
terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target="module.monitor.yandex_compute_instance.monitor" -target="module.monitor.null_resource.monitor-provisioner-step00" --auto-approve


##..destroy (auto)
#terraform destroy -var-file="$SECRETS_DIR/protected.tfvars" -target="module.monitor.yandex_compute_instance.monitor" -target="module.monitor.null_resource.monitor-provisioner-step00" --auto-approve

##..destroy (manual)
#cd terraform; terraform destroy -var-file="protected/protected.tfvars" -target="module.monitor.yandex_compute_instance.monitor" -target="module.monitor.null_resource.monitor-provisioner-step00" --auto-approve; cd ..
