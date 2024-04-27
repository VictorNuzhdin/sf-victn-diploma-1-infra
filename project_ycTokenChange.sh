#!/bin/bash

##..sets local variables
TERRAFORM_PROJECT_DIR="./terraform"
#
TFVARS_CONFIG="$TERRAFORM_PROJECT_DIR/protected/protected.tfvars"
#
NEW_YC_TOKEN=$(yc iam create-token)
#NEW_YC_TOKEN_TS_ISO=$(date +'%Y-%m-%dT%H:%M:%S')        ## 2024-04-16T22:15:01
#NEW_YC_TOKEN_TS_CUSTOM_1=$(date +'%Y-%m-%d %H:%M:%S')   ## 2024-04-16 22:15:01
NEW_YC_TOKEN_TS_CUSTOM_2=$(date +'%Y%m%d_%H%M%S')        ## 20240416_221501


##..replaces all "yc_token" substrings  with NEW one
#sed -i -e "s/^yc_token.*/yc_token = \"$NEW_YC_TOKEN\"/" $TFVARS_CONFIG

##..replaces current "yc_token" value with NEW one, and sets Timestamp to "yc_token_ts" field
sed -i -e "/^yc_token =/c yc_token = \"$NEW_YC_TOKEN\"" -e "/^yc_token_ts =/c yc_token_ts = \"$NEW_YC_TOKEN_TS_CUSTOM_2\"" $TFVARS_CONFIG
