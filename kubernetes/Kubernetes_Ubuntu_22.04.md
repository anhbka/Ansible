## Install kubernetes Ubuntu 22.04 with repository gcr.io

### * Prerequisites
```
* Minimal install Ubuntu 22.04
* Minimum 2GB RAM or more
* Minimum 2 CPU cores / or 2 vCPU
* 20 GB free disk space on /var or more
* Sudo user with admin rights
* Internet connectivity on each node
```
### Lab Setup

- Change mirrors to `http://mirror.viettelcloud.vn/ubuntu/` (`https://launchpad.net/ubuntu/+archivemirrors`)

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
  version: 2

sudo apt install yamllint -y

yamllint /etc/netplan/01-netplan.yaml ### Check syntax

sudo netplan --debug apply

```
### Allowing SSH root login on Ubuntu 22.04

```
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl restart ssh
```
### Master node

- Run command `curl -Ls https://raw.githubusercontent.com/anhbka/Ansible/master/kubernetes/install_master_node.sh | bash` 

### Worker node

- Run command `curl -Ls https://raw.githubusercontent.com/anhbka/Ansible/master/kubernetes/install_worker_node.sh | bash` 

* Get token after finished install master node join cluster
```
kubeadm join 192.168.30.180:6443 --token b51du7.3eoxpsjf20w97z06 \
        --discovery-token-ca-cert-hash sha256:6a6cc8c9c91b04dfd410a0309d1d9bc4239710f7d6dd83cb883efb8e627f87a5
```
### Test Your Kubernetes Cluster Installation

```
kubectl create deployment nginx-app --image=nginx --replicas=2

kubectl get deployment nginx-app

kubectl expose deployment nginx-app --type=NodePort --port=80

kubectl get svc nginx-app

kubectl describe svc nginx-app

curl http://<woker-node-ip-addres>:31246
```