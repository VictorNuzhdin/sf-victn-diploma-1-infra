#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR
#
SECRETS_DIR='protected'


#..clearing console
clear

#..validate Terraform configuration
#terraform validate;

##..deploy terraform configuration/plan - only GATEWAY
#
#terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target="module.gateway.yandex_compute_instance.gateway"; terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target="module.gateway.yandex_compute_instance.gateway" --auto-approve

## IMPORTANT:
## - with method above, Terraform Provisioners doesnt applies to cloud infrastructrure
##   and "modules/gateway/provisioning.tf" configuration is ignored
## - to fix that behaviour, you need to apply Module level Provisioners SEPARATELY because they are separate Terraform Objects
#
#terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target="module.gateway.null_resource.gateway-provisioner-step00"; terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target="module.gateway.null_resource.gateway-provisioner-step00" --auto-approve

##..print output variables
#terraform output
#


##..ALL_IN_ONE
terraform validate
terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target="module.gateway.yandex_compute_instance.gateway" -target="module.gateway.null_resource.gateway-provisioner-step00" -target="output.gateway_external_endpoint" -target="output.gateway_external_ip"
terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target="module.gateway.yandex_compute_instance.gateway" -target="module.gateway.null_resource.gateway-provisioner-step00" -target="output.gateway_external_endpoint" -target="output.gateway_external_ip" --auto-approve


##..destroy (auto)
#terraform destroy -var-file="$SECRETS_DIR/protected.tfvars" -target="module.gateway.yandex_compute_instance.gateway" -target="module.gateway.null_resource.gateway-provisioner-step00" -target="output.gateway_external_endpoint" -target="output.gateway_external_ip" --auto-approve

##..destroy (manual))
#cd terraform; terraform destroy -var-file="protected/protected.tfvars" -target="module.gateway.yandex_compute_instance.gateway" -target="module.gateway.null_resource.gateway-provisioner-step00" -target="output.gateway_external_endpoint" -target="output.gateway_external_ip" --auto-approve; cd ..
