#!/bin/sh

SCRIPTS_PATH="/home/ubuntu/setup"
LOG_PATH="$SCRIPTS_PATH/configure_20-deploy-webapp-test.log"
SYSTEM_USER_LOGIN="ubuntu"
APP_REPO_HTTPS_URL="https://github.com/VictorNuzhdin/sf-victn-diploma-0-app1.git"
APP_REPO_NAME="sf-victn-diploma-0-app1"
APP_ENTRIPOINT="project_docker21ComposeUp.sh"


##--STEP#20 :: Deploying Webap from GitHub and DockerHub Ropoes
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs started.." >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "" >> $LOG_PATH

##..prechecks
echo "--PRECHECKS" >> $LOG_PATH
docker --version >> $LOG_PATH
docker compose version >> $LOG_PATH
git --version >> $LOG_PATH
gh --version | head -n1 >> $LOG_PATH
echo "" >> $LOG_PATH
gh auth status >> $LOG_PATH
echo "" >> $LOG_PATH
ls -ll ~/.docker/config.json >> $LOG_PATH
echo "" >> $LOG_PATH
cat ~/.docker/config.json >> $LOG_PATH
echo "" >> $LOG_PATH
echo "" >> $LOG_PATH


##..creating project directory && cloning github repo && fixing permissions
#
mkdir -p /home/$SYSTEM_USER_LOGIN/projects
cd /home/$SYSTEM_USER_LOGIN/projects
git clone $APP_REPO_HTTPS_URL
#
chown -R $SYSTEM_USER_LOGIN:$SYSTEM_USER_LOGIN $APP_REPO_NAME

##..running webapp
#
cd /home/$SYSTEM_USER_LOGIN/projects/$APP_REPO_NAME
chmod +x *.sh
bash ./$APP_ENTRIPOINT


echo "" >> $LOG_PATH
echo "" >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs done!" >> $LOG_PATH
