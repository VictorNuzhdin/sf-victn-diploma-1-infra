#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR
#
SECRETS_DIR='protected'


#..clearing console
clear

##..deploy NETWORK only
#
terraform validate
terraform plan -var-file="$SECRETS_DIR/protected.tfvars" -target="module.network.yandex_vpc_network.k8s-net" -target="module.network.yandex_vpc_subnet.k8s-subnet1"
terraform apply -var-file="$SECRETS_DIR/protected.tfvars" -target="module.network.yandex_vpc_network.k8s-net" -target="module.network.yandex_vpc_subnet.k8s-subnet1" --auto-approve


##..destroy (auto)
#terraform destroy -var-file="$SECRETS_DIR/protected.tfvars" -target="module.network.yandex_vpc_network.k8s-net" -target="module.network.yandex_vpc_subnet.k8s-subnet1" --auto-approve

##..destroy (manual)
#cd terraform; terraform destroy -var-file="protected/protected.tfvars" -target="module.network.yandex_vpc_network.k8s-net" -target="module.network.yandex_vpc_subnet.k8s-subnet1" --auto-approve; cd ..
