#!/bin/bash

SETUP_PATH="/home/ubuntu/setup_kuber"
LOG_FILE="kuber_setup_master.log"
LOG_PATH="$SETUP_PATH/$LOG_FILE"


##..clear log
cat /dev/null > $LOG_PATH
clear

echo "--KUBERNETES_MASTER_NODE_BASE_SETUP__BEGINS.."
##--STEP00: system setup (all nodes)
##..setting timezone
sudo timedatectl set-timezone Asia/Omsk
#
echo "$(date +'%Y-%m-%dT%H:%M:%S') :: --KUBERNETES_MASTER_NODE_BASE_SETUP__BEGINS" >> $LOG_PATH
#
##..disabling OS apt/get interactive mode
DEBIAN_FRONTEND=noninteractive
sudo bash -c 'echo "nrconf" > /etc/needrestart/conf.d/90-autorestart.conf'
sudo sed -i "/nrconf/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/conf.d/90-autorestart.conf


##--STEP01: install some tools (all nodes)
##..update local packages
sudo apt-get update
sudo DEBIAN_FRONTEND="$DEBIAN_FRONTEND" apt-get upgrade -y
sudo apt-get install -y curl gpg gnupg2 software-properties-common apt-transport-https ca-certificates


##--STEP02: disabling swap file (all nodes)
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab


##--STEP03: do kubernetes specific os configurations (all nodes)
##..configuring Linux kernel modules
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
#
sudo modprobe overlay
sudo modprobe br_netfilter
#
##..make kubernetes config 
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
#
sudo sysctl --system


##--STEP04: configuring "Container Runtime" (all nodes)
##..removing Docker "Container Runtime" if exists
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
#
##..installing Containerd as "Container Runtime"
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/keyrings/docker-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/docker-apt-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
#
sudo apt-get update
sudo apt-get install -y containerd.io
#
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
#
sudo systemctl restart containerd
sudo systemctl enable containerd


##--STEP05: installing Kubernetes components (all nodes)
##..adding package repositories
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
#
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl


##--STEP06: base setup post check (all nodes)
##..check container runtime
systemctl status containerd | grep Active | awk '{$1=$1;print}' >> $LOG_PATH
systemctl status containerd | grep 'msg="containerd' >> $LOG_PATH
echo "" >> $LOG_PATH
##..check kube tools version
kubectl version >> $LOG_PATH
kubelet --version >> $LOG_PATH
echo "Kubeadm v$(kubeadm version | awk '{print $5}' | sed 's/\GitVersion:"v//g' | sed 's/\",//g')" >> $LOG_PATH
#
echo "--KUBERNETES_MASTER_NODE_BASE_SETUP__DONE!"
echo "$(date +'%Y-%m-%dT%H:%M:%S') :: --KUBERNETES_MASTER_NODE_BASE_SETUP__DONE" >> $LOG_PATH
echo "" >> $LOG_PATH


##---
##--STEP07: initializing Kubernetes Cluster (master node)
##..log message
echo "$(date +'%Y-%m-%dT%H:%M:%S') :: --KUBERNETES_MASTER_NODE_CLUSTER_INIT__BEGINS.." >> $LOG_PATH
#
##..init cluster (~80 seconds duration)
sudo kubeadm init
#sleep 80
sleep 20
#
##..make kube config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
#
##..post checking
ls -la $HOME/.kube/config >> $LOG_PATH
echo "" >> $LOG_PATH
#
kubectl get nodes
kubectl get nodes >> $LOG_PATH
echo "" >> $LOG_PATH
#
##..installing Kubernetes Network Plugin: Calico (~60 seconds duration)
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/calico.yaml
#sleep 60
sleep 20
#
##..post checking
kubectl get nodes
kubectl get nodes >> $LOG_PATH
echo "" >> $LOG_PATH
#
echo "$(date +'%Y-%m-%dT%H:%M:%S') :: --KUBERNETES_MASTER_NODE_CLUSTER_INIT__DONE!" >> $LOG_PATH
