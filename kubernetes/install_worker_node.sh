#!/bin/bash

sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

sudo swapoff -a 
sudo sed -i '/^\/swap.img/ s/^\(.*\)$/#\1/g' /etc/fstab 
cat /etc/fstab


# Install containerd
## Set up the repository
### Install packages to allow apt to use a repository over HTTPS
apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common

### Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

### Add Docker apt repository.
echo "ENTER" | add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

## Install containerd
apt-get update && apt-get install -y containerd.io

# Configure containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml

sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sed -i '/\[plugins."io.containerd.grpc.v1.cri".registry.mirrors\]/a \
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."gcr.io"] \
          endpoint = ["https://gcr.io"]' /etc/containerd/config.toml
          
cat /etc/containerd/config.toml | egrep "registry.mirrors|io.containerd.grpc.v1.cri" -C5          

# Restart containerd
systemctl restart containerd
systemctl enable containerd
systemctl status containerd


curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubeadm kubelet kubectl
apt-mark hold kubelet 

sysctl net.bridge.bridge-nf-call-iptables=1

crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock