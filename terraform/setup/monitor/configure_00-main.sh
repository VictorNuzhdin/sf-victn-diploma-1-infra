#!/bin/sh

SCRIPTS_PATH=/home/ubuntu/setup
LOG_PATH=$SCRIPTS_PATH/configure_00-main.log





##--STEP#00 :: Execution of individual scripts
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Scripts execution started.." >> $LOG_PATH
#
#..configuring users
chmod +x $SCRIPTS_PATH/configure_01-users.sh
sudo bash $SCRIPTS_PATH/configure_01-users.sh
#
#..installing base packages
chmod +x $SCRIPTS_PATH/configure_02-packages.sh
sudo bash $SCRIPTS_PATH/configure_02-packages.sh
#
#..installing nginx web and proxy server
chmod +x $SCRIPTS_PATH/configure_03-nginx.sh
sudo bash $SCRIPTS_PATH/configure_03-nginx.sh
#
#..sending current dynamic ip to external freedns service
chmod +x $SCRIPTS_PATH/configure_04-freedns.sh
sudo bash $SCRIPTS_PATH/configure_04-freedns.sh
#
#..configuring https :: request NEW ssl certificate
#chmod +x $SCRIPTS_PATH/configure_05-ssl-letsencrypt-cert-request-new.sh
#sudo bash $SCRIPTS_PATH/configure_05-ssl-letsencrypt-cert-request-new.sh
#
#..configuring https :: reuse OLD ssl certificate
chmod +x $SCRIPTS_PATH/configure_05-ssl-letsencrypt-cert-reuse-old.sh
sudo bash $SCRIPTS_PATH/configure_05-ssl-letsencrypt-cert-reuse-old.sh
#
#..updating website files
chmod +x $SCRIPTS_PATH/configure_06-nginx-updateSite.sh
sudo bash $SCRIPTS_PATH/configure_06-nginx-updateSite.sh
#
#..installing dev tools
chmod +x $SCRIPTS_PATH/configure_10-devtools.sh
sudo bash $SCRIPTS_PATH/configure_10-devtools.sh
#
#..deploying webapp from GitHub and DockerHub repoes (testing)
chmod +x $SCRIPTS_PATH/configure_20-deploy-webapp-test.sh
sudo bash $SCRIPTS_PATH/configure_20-deploy-webapp-test.sh
#
#..configuring firewall
chmod +x $SCRIPTS_PATH/configure_66-firewall.sh
sudo bash $SCRIPTS_PATH/configure_66-firewall.sh
#
#..collecting final info
chmod +x $SCRIPTS_PATH/configure_99-getinfo.sh
sudo bash $SCRIPTS_PATH/configure_99-getinfo.sh
#
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Scripts execution done!" >> $LOG_PATH
