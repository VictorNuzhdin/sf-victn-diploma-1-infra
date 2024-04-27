#!/bin/sh

SCRIPTS_PATH=/home/ubuntu/setup
LOG_PATH=$SCRIPTS_PATH/configure_02-packages.log

##..disable interactive prompts when apt installs
export DEBIAN_FRONTEND=noninteractive



##--STEP#02 :: Installing packages :: Python
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs started.." >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "" >> $LOG_PATH


echo '## Updating local apt packages database..' >> $LOG_PATH
sudo apt update -y
sleep 30
#sudo apt upgrade -y                             ## Need to get 113 MB of archives.. т.е это будет долго (минут 5 и потом будет интерактивное окно и нужна перезагрузка)
#sudo apt -y autoremove >> $LOG_PATH             ## After this operation, 596 MB disk space will be freed.
echo "" >> $LOG_PATH


##..installing_packages
#sudo apt install -y python3                     ## Python 3.10+ is already exists in new Ubuntu 22.04 Cloud Images (from 2023.08.28 and newest)
sudo apt install -y whois
sudo apt install -y mc
sudo apt install -y tree


#..debug_logging
echo '## Installing Python 3' >> $LOG_PATH
python3 --version
whereis python3
#
echo '## Installing Whois package (includes mkpasswd)..' >> $LOG_PATH
echo "" >> $LOG_PATH
whois --version | head -n 1 >> $LOG_PATH
whereis whois >> $LOG_PATH
echo "" >> $LOG_PATH
mkpasswd --version | head -n 1 >> $LOG_PATH
whereis mkpasswd >> $LOG_PATH
echo "" >> $LOG_PATH
#
echo '## Installing Midnight Commander..' >> $LOG_PATH
echo "" >> $LOG_PATH
mc --version | head -n 1 >> $LOG_PATH
whereis mc >> $LOG_PATH
echo "" >> $LOG_PATH
#
echo '## Installing Tree package..' >> $LOG_PATH
echo "" >> $LOG_PATH
tree --version >> $LOG_PATH
whereis tree >> $LOG_PATH
echo "" >> $LOG_PATH

echo "" >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs done!" >> $LOG_PATH
