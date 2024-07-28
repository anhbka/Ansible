## Install kubernetes Ubuntu 22.04 with repository gcr.io

### Prerequisites
```
* Minimal install Ubuntu 22.04
* Minimum 2GB RAM or more
* Minimum 2 CPU cores / or 2 vCPU
* 20 GB free disk space on /var or more
* Sudo user with admin rights
* Internet connectivity on each node
```
### Lab Setup

- Change mirrors to http://mirror.viettelcloud.vn/ubuntu/
https://launchpad.net/ubuntu/+archivemirrors

```
root@master:~# cat /etc/apt/sources.list.d/ubuntu.sources
Types: deb
#URIs: http://vn.archive.ubuntu.com/ubuntu/
URIs: http://mirror.viettelcloud.vn/ubuntu/
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://security.ubuntu.com/ubuntu/
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
```

- Add DNS:

```
mkdir -p /etc/resolvconf/resolv.conf.d/tail
cat /etc/resolvconf/resolv.conf.d/tail

nameserver 8.8.8.8
nameserver 8.8.4.4
```

- Config IP static:

```
cat /etc/netplan/50-cloud-init.yaml
---
network:
  ethernets:
    ens33:
      dhcp4: false
      addresses:
        - 192.168.30.180/24
      routes:
        - to: default
          via: 192.168.30.2
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
    ens34:
      dhcp4: false
      addresses:
        - 10.10.0.128/24
  version: 2
```

sudo apt install yamllint -y

yamllint /etc/netplan/01-netplan.yaml ### Check syntax

sudo netplan --debug apply



### Allowing SSH root login on Ubuntu 22.04

```
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart ssh
```
### Master node

- Create script bash with content bellow:

```
vi install_master_node.sh 

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
          
cat /etc/containerd/config.toml | egrep -iE "registry.mirrors|io.containerd.grpc.v1.cri" -C5          

# Restart containerd
systemctl restart containerd
systemctl enable containerd
systemctl status containerd


curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt-get update -y
apt-get install -y kubeadm kubelet kubectl
apt-mark hold kubelet 

sysctl net.bridge.bridge-nf-call-iptables=1

crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock

sudo systemctl daemon-reload && sudo systemctl restart kubelet


sudo kubeadm init

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

### Install calico https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises

curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml -O

kubectl apply -f calico.yaml

### Install bash-completion https://kubernetes.io/vi/docs/tasks/tools/install-kubectl/

source /usr/share/bash-completion/bash_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
kubectl completion bash >/etc/bash_completion.d/kubectl
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc
source ~/.bashrc

k get pod -A

crictl image ls
```

### Worker node

- Create script bash with content bellow:

```
vi install_worker_node.sh

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

apt-get update -y
apt-get install -y kubeadm kubelet kubectl
apt-mark hold kubelet 

sysctl net.bridge.bridge-nf-call-iptables=1

crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock
EOF
* Get token after finished install master node

kubeadm join 192.168.30.180:6443 --token b51du7.3eoxpsjf20w97z06 \
        --discovery-token-ca-cert-hash sha256:6a6cc8c9c91b04dfd410a0309d1d9bc4239710f7d6dd83cb883efb8e627f87a5
```		