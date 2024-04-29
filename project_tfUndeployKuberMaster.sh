#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR
#
SECRETS_DIR='protected'


#..clearing console
clear


##..destroy Kubernetes Master NODEs only
#
terraform validate
terraform destroy -var-file="$SECRETS_DIR/protected.tfvars" -target="module.cluster.yandex_compute_instance.k8s-master" -target="module.cluster.null_resource.k8s-masters-provisioner" -target="output.k8s_masters_ip_external" --auto-approve

##..BUG:
##  *terraform doesnt remove some outputs from .tfstate after resources was destroyed with -target flag
##   https://github.com/hashicorp/terraform/issues/13555
##   https://github.com/hashicorp/terraform/issues/11716
##   https://discuss.hashicorp.com/t/output-variables-in-state-are-not-removed-by-refresh/23043/2
##      A:
##          I think this has the same root cause as #12572 and #11716, 
##          which is that outputs are only updated when their graph nodes are visited during apply. 
##          All of these tickets are various reasons why the "apply" step of an output wouldn't be run.
#

##..FIX
##  *manually remove unused master outputs from Terraform State
##   https://stackoverflow.com/questions/75161337/delete-terraform-output-from-state
##   https://stackoverflow.com/questions/47023795/removing-a-key-from-parent-object-with-jq
##   - это очень плохое решение удалять чтото в Terraform State напрямую
##     т.к возможна ситуация когда "terrafrom destroy" вывалится в ошибку, а команды ниже удалять то что еще не нужно удалять
#
cp terraform.tfstate terraform_tfstate_$(date +'%Y%m%d_%H%M%S')
jq 'del(.outputs.k8s_masters_ip_external)' terraform.tfstate | tee terraform.tfstate_tmp
rm -f terraform.tfstate
cp terraform.tfstate_tmp terraform.tfstate
rm -f terraform.tfstate_tmp

##..checks Terraform configuration and State AFTER fix was applied
terraform validate


##..MASTER0_OUTPUT_CHECKS :: must be empty
echo ""
echo "--MASTER_OUTPUT"
echo "\"k8s_master0_external_ipv4_address\": \"$(cat terraform.tfstate | jq -r -c '.resources[] | select ( .name == "k8s-master")'.instances[0].attributes.network_interface[0].nat_ip_address)\""


##..destroy (manual))
#cd terraform; terraform destroy -var-file="protected/protected.tfvars" -target="module.cluster.yandex_compute_instance.k8s-master" -target="module.cluster.null_resource.k8s-masters-provisioner" -target="output.k8s_masters_ip_external" --auto-approve; cd ..
