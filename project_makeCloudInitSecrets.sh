#!/bin/bash

TERRAFORM_PROJECT_DIR="./terraform"
cd $TERRAFORM_PROJECT_DIR
#
CONFIG_DIR='configs'
CONFIG_TEMPLATE='cloud-init.tpl'
CONFIG_FILE='cloud-init.yaml'
#
SECRETS_DIR='protected'
SECRETS_FILE='cloud-init_instance-data.json'


##..copy template cloud-init config
rm -f $CONFIG_DIR/$CONFIG_FILE
cp $CONFIG_DIR/$CONFIG_TEMPLATE $CONFIG_DIR/$CONFIG_FILE

##..retrieving data from external json config and inject into cloud-init config
declare -A project_secrets

project_secrets=(
  [_CUSTOM_SSH_PORT_]=822
  [_CUSTOM_USER_NAME_]=$(cloud-init query --instance-data $SECRETS_DIR/$SECRETS_FILE customdata.user_name)
  [_CUSTOM_USER_PASSWORD_]=$(cloud-init query --instance-data $SECRETS_DIR/$SECRETS_FILE customdata.user_password)
  [_CUSTOM_USER_PUBKEY_]=$(cloud-init query --instance-data $SECRETS_DIR/$SECRETS_FILE customdata.user_pubkey)
  [_CUSTOM_USER_OWNERSHIP_]=$(cloud-init query --instance-data $SECRETS_DIR/$SECRETS_FILE customdata.user_ownersip)
  [_CUSTOM_GIT_USER_NAME_]=$(cloud-init query --instance-data $SECRETS_DIR/$SECRETS_FILE customdata.github_user_name)
  [_CUSTOM_GIT_USER_MAIL_]=$(cloud-init query --instance-data $SECRETS_DIR/$SECRETS_FILE customdata.github_user_mail)
  [_CUSTOM_GIT_USER_TOKEN_]=$(cloud-init query --instance-data $SECRETS_DIR/$SECRETS_FILE customdata.github_user_token)
)

##..replace template variables with values
for s in "${!project_secrets[@]}"
do
	find="$s"
	replace=${project_secrets[$s]}
  #
  sed -i -e "s/${find}/${replace}/" $CONFIG_DIR/$CONFIG_FILE
done
