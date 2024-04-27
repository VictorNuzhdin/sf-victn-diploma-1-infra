#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR
#
SECRETS_DIR='protected'


#..clearing console
clear

##..deploy terraform configuration/plan - only NETWORK -- doesnt_work
#
#TF_TARGET_1=module.yandex_vpc_network.networks.k8s-net
#TF_TARGET_1='module.yandex_vpc_network.networks.k8s-net'
#TF_TARGET_1=\'module.yandex_vpc_network.networks.k8s-net\'
#
#terraform validate; terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target=$TF_TARGET_1; terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target=$TF_TARGET_1 --auto-approve
#terraform validate; terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target="$TF_TARGET_1"; terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target="$TF_TARGET_1" --auto-approve
#terraform validate; terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target='$TF_TARGET_1'; terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target='$TF_TARGET_1' --auto-approve
#terraform validate; terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target=\"$TF_TARGET_1\"; terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target=\"$TF_TARGET_1\" --auto-approve
#terraform validate; terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target=\'$TF_TARGET_1\'; terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target=\'$TF_TARGET_1\' --auto-approve


##..deploy terraform configuration/plan - only NETWORK -- works_fine
#
#terraform validate; terraform plan; terraform apply -var-file=protected/protected.tfvars --auto-approve
#terraform validate; terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target='module.networks.yandex_vpc_network.k8s-net'; terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target='module.networks.yandex_vpc_network.k8s-net' --auto-approve
#terraform validate; terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target="module.networks.yandex_vpc_network.k8s-net"; terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target="module.networks.yandex_vpc_network.k8s-net" --auto-approve
#
#terraform validate; terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target="module.networks.yandex_vpc_network.k8s-net"; terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target="module.networks.yandex_vpc_network.k8s-net" --auto-approve
#terraform validate; terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target="module.networks.yandex_vpc_subnet.k8s-subnet1"; terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target="module.networks.yandex_vpc_subnet.k8s-subnet1" --auto-approve


##..ALL_IN_ONE
terraform validate
terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target="module.networks.yandex_vpc_network.k8s-net" -target="module.networks.yandex_vpc_subnet.k8s-subnet1"
terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target="module.networks.yandex_vpc_network.k8s-net" -target="module.networks.yandex_vpc_subnet.k8s-subnet1" --auto-approve


##..destroy (auto)
#terraform destroy -var-file="$SECRETS_DIR/protected.tfvars" -target="module.networks.yandex_vpc_network.k8s-net" -target="module.networks.yandex_vpc_subnet.k8s-subnet1" --auto-approve

##..destroy (manual)
#cd terraform; terraform destroy -var-file="protected/protected.tfvars" -target="module.networks.yandex_vpc_network.k8s-net" -target="module.networks.yandex_vpc_subnet.k8s-subnet1" --auto-approve; cd ..

