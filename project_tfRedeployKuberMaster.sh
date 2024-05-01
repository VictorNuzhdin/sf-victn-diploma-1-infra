#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
CURRENT_PATH="$(dirname "$0")"




#..clearing console
clear


##..redeploy Kubernetes Master NODEs only
#
$CURRENT_PATH/project_tfUndeployKuberMaster.sh
$CURRENT_PATH/project_tfDeployKuberMaster.sh
