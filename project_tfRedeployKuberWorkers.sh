#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
CURRENT_PATH="$(dirname "$0")"




#..clearing console
clear


##..redeploy Kubernetes Worker NODEs only
#
$CURRENT_PATH/project_tfUndeployKuberWorkers.sh
$CURRENT_PATH/project_tfDeployKuberWorkers.sh
