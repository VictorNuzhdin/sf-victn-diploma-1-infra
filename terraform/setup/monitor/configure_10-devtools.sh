#!/bin/sh

SCRIPTS_PATH="/home/ubuntu/setup"
LOG_PATH="$SCRIPTS_PATH/configure_10-devtools.log"
SYSTEM_USER_LOGIN="ubuntu"
NEW_USER_LOGIN="devops"



##--STEP#10 :: Installing development tools
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs started.." >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "" >> $LOG_PATH

##..prechecks
echo "--PRECHECKS" >> $LOG_PATH
whoami >> $LOG_PATH                 # root
pwd >> $LOG_PATH                    # /home/ubuntu
echo "" >> $LOG_PATH
echo "" >> $LOG_PATH


##..disable interactive prompt for restart services when apt-get upgrade
#
export DEBIAN_FRONTEND=noninteractive
sudo bash -c 'echo "nrconf" > /etc/needrestart/conf.d/90-autorestart.conf'
sudo sed -i "/nrconf/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/conf.d/90-autorestart.conf


##..updating package database
#
sudo apt-get update
#sudo DEBIAN_FRONTEND="$DEBIAN_FRONTEND" apt-get upgrade -y         # ОТКЛЮЧЕНО :: слишком медленно происходит обновление
#sudo apt-get upgrade -y                                            # Need to get 113 MB of archives.. т.е это будет долго (минут 5 и потом будет интерактивное окно и нужна перезагрузка)
#sudo apt-get -y autoremove >> $LOG_PATH                            # After this operation, 596 MB disk space will be freed.


##..installing base packages
#
sudo apt-get install -y curl gpg gnupg2 software-properties-common apt-transport-https ca-certificates


##..installing useful utils
#
sudo apt-get install -y zip jq


##..installing dev tools: git + github cli
#
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update; sudo apt-get install -y git
#
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt-get update; sudo apt-get install -y gh
#
git --version                                                               # git version 2.43.2
gh --version | head -n1                                                     # gh version 2.49.0 (2024-04-30)


##..installing dev tools: docker with compose
#
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
sudo usermod -aG docker $SYSTEM_USER_LOGIN
sudo usermod -aG docker $NEW_USER_LOGIN
sudo rm -f get-docker.sh
#
docker --version                                                            # Docker version 26.1.1, build 4cf5afa
docker compose version                                                      # Docker Compose version v2.27.0


##..installing dev tools: python + pip + venv
#
#sudo apt install -y python3                                                # Python 3.10+ (3.10.12) is already exists in new Ubuntu 22.04 Yandex Cloud Images
#whereis python3                                                            # python3: /usr/bin/python3 /usr/lib/python3 /etc/python3 /usr/share/python3 /usr/share/man/man1/python3.1.gz
#which python3                                                              # /usr/bin/python3
#
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 20

##..installing pip for ROOT_USER
curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py                                                           # WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager
python -m pip install --upgrade pip                                         # Requirement already satisfied: pip in ./.local/lib/python3.10/site-packages (24.0)
rm -f get-pip.py
#
##..installing pip for NEW_USER_LOGIN (devops)
sudo -u $NEW_USER_LOGIN curl -s https://bootstrap.pypa.io/get-pip.py -o /home/$NEW_USER_LOGIN/get-pip.py
sudo -u $NEW_USER_LOGIN python /home/$NEW_USER_LOGIN/get-pip.py
sudo -u $NEW_USER_LOGIN python -m pip install --upgrade pip
sudo rm -f /home/$NEW_USER_LOGIN/get-pip.py
#
pip install virtualenv
sudo apt-get install -y python3-virtualenv
#
python --version                                                            # Python 3.10.12
pip --version                                                               # pip 24.0 from /home/ubuntu/.local/lib/python3.10/site-packages/pip (python 3.10)
echo "virtualenv $(pip show virtualenv | grep Version | awk '{print $2}')"  # virtualenv 20.26.1
virtualenv --version                                                        # virtualenv 20.26.1 from /home/ubuntu/.local/lib/python3.10/site-packages/virtualenv/__init__.py


##..configuring Git CLI (git) :: for SYSTEM_USER_LOGIN (ubuntu)
#
cp $SCRIPTS_PATH/configs/srv__v4_cicd/user_profile/.gitconfig /home/$SYSTEM_USER_LOGIN/.gitconfig
chmod 600 /home/$SYSTEM_USER_LOGIN/.gitconfig
chown $SYSTEM_USER_LOGIN:$SYSTEM_USER_LOGIN /home/$SYSTEM_USER_LOGIN/.gitconfig


##..configuring GitHub CLI (gh) :: for SYSTEM_USER_LOGIN (ubuntu)
#
mkdir -p /home/$SYSTEM_USER_LOGIN/.config/gh
chmod 700 /home/$SYSTEM_USER_LOGIN/.config
chmod 771 /home/$SYSTEM_USER_LOGIN/.config/gh
#
cp $SCRIPTS_PATH/configs/srv__v4_cicd/user_profile/.config/gh/config.yml /home/$SYSTEM_USER_LOGIN/.config/gh/config.yml
cp $SCRIPTS_PATH/configs/srv__v4_cicd/user_profile/.config/gh/hosts.yml  /home/$SYSTEM_USER_LOGIN/.config/gh/hosts.yml
#
chmod 600 /home/$SYSTEM_USER_LOGIN/.config/gh/config.yml
chmod 600 /home/$SYSTEM_USER_LOGIN/.config/gh/hosts.yml
chown $SYSTEM_USER_LOGIN:$SYSTEM_USER_LOGIN -R /home/$SYSTEM_USER_LOGIN/.config
#
gh auth status
gh auth status >> $LOG_PATH


##..configuring Docker CLI (docker) :: for SYSTEM_USER_LOGIN (ubuntu)
#
mkdir -p /home/$SYSTEM_USER_LOGIN/.docker
chmod 700 /home/$SYSTEM_USER_LOGIN/.docker
chown $SYSTEM_USER_LOGIN:$SYSTEM_USER_LOGIN /home/$SYSTEM_USER_LOGIN/.docker
#
cp $SCRIPTS_PATH/configs/srv__v4_cicd/user_profile/.docker/config.json /home/$SYSTEM_USER_LOGIN/.docker/config.json
#
chmod 600 /home/$SYSTEM_USER_LOGIN/.docker/config.json
chown $SYSTEM_USER_LOGIN:$SYSTEM_USER_LOGIN ~/.docker/config.json


##..final checks: tools
#
git --version
gh --version | head -n1
docker --version
docker compose version
python --version
pip --version
virtualenv --version
jq --version
mkpasswd --version | head -n1


##..final checks: GitHub Auth Status and DockerHub Auth
#
echo "" >> $LOG_PATH
gh auth status
gh auth status >> $LOG_PATH
#
#docker stop $(docker ps -aq)
#docker rm -vf $(docker ps -aq)
#docker rmi -f $(docker images -aq)
#docker container prune --force
#
#docker pull hello-world
#docker images
#docker images >> $LOG_PATH
#
#         REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
#         hello-world   latest    d2c94e258dcb   12 months ago   13.3kB
#
#echo $(date +'%Y.%m%d.%H%M%S')		## 2024.0502.171441
#
#echo "" >> $LOG_PATH
#docker tag hello-world:latest dotspace2019/hello-world:$(date +'%Y.%m%d.%H%M%S')
#docker tag dotspace2019/hello-world:$(date +'%Y.%m%d.%H%M%S') dotspace2019/hello-world:latest
#
#docker images
#docker images >> $LOG_PATH
#
#         REPOSITORY                 TAG                IMAGE ID       CREATED         SIZE
#         dotspace2019/hello-world   2024.0502.172150   d2c94e258dcb   12 months ago   13.3kB
#         dotspace2019/hello-world   latest             d2c94e258dcb   12 months ago   13.3kB
#         hello-world                latest             d2c94e258dcb   12 months ago   13.3kB
#
#docker push dotspace2019/hello-world:$(date +'%Y.%m%d.%H%M%S') && docker push dotspace2019/hello-world:latest
#
#https://hub.docker.com/repository/docker/dotspace2019/hello-world/general
#- изменения пришли
#
#docker stop $(docker ps -aq)
#docker rm -vf $(docker ps -aq)
#docker rmi -f $(docker images -aq)
#
#echo "" >> $LOG_PATH
#docker run dotspace2019/hello-world:latest | grep Hello
#docker run dotspace2019/hello-world:latest | grep Hello >> $LOG_PATH
#
#         Hello from Docker!
#


##..final checks: authorization for GitHub and DockerHub
echo "" >> $LOG_PATH
#
git config --global user.name  >> $LOG_PATH      # "VictorNuzhdin"
git config --global user.email >> $LOG_PATH      # "nuzhdin.vicx@yandex.ru"
echo "" >> $LOG_PATH
gh auth status >> $LOG_PATH
#
echo "" >> $LOG_PATH


##--STEP#77 :: Debug Logging
#
echo "" >> $LOG_PATH
echo "" >> $LOG_PATH
#
echo '##--PACKAGE_VERSIONS' >> $LOG_PATH
echo '##..Git CLI & GitHub CLI' >> $LOG_PATH
git --version >> $LOG_PATH
gh --version | head -n1 >> $LOG_PATH
which git >> $LOG_PATH
which gh >> $LOG_PATH
echo "" >> $LOG_PATH
#
echo '##..Docker & Docker Compose' >> $LOG_PATH
docker --version >> $LOG_PATH
docker compose version >> $LOG_PATH
which docker >> $LOG_PATH
echo "" >> $LOG_PATH
#
echo '##..Python and Python Utils' >> $LOG_PATH
python --version >> $LOG_PATH
pip --version >> $LOG_PATH
virtualenv --version >> $LOG_PATH
echo "" >> $LOG_PATH
whereis python >> $LOG_PATH
which python >> $LOG_PATH
echo "" >> $LOG_PATH
whereis pip >> $LOG_PATH
which pip >> $LOG_PATH
echo "" >> $LOG_PATH
whereis virtualenv >> $LOG_PATH
which virtualenv >> $LOG_PATH
#
echo '##..Other Utils' >> $LOG_PATH
jq --version >> $LOG_PATH
whereis jq >> $LOG_PATH
which jq >> $LOG_PATH


echo "" >> $LOG_PATH
echo "" >> $LOG_PATH
echo "-----------------------------------------------------------------------------" >> $LOG_PATH
echo "[$(date +'%Y-%m-%d %H:%M:%S')] :: Jobs done!" >> $LOG_PATH
