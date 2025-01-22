### Kubernetes install on CentOs 7

* Prerequisites:

Before we begin the installation process, ensure you have the following prerequisites:

A minimum of three nodes (one master and two worker nodes) running either Red Hat Enterprise Linux 7 or CentOS 9.

Each node should have a minimum of 4GB RAM and 2 CPU cores.

If you do not have a DNS setup, each node should have the following entries in the `/etc/hosts` file: 

### 1. Kubernetes Cluster

### * *Setup for master, worker1, worker2*

### Step 1: Download & Install CentOS 7

| Hostname | RAM | CPU | OS | IP Address |
|----------|-----|-----|----|------------|
|  Master  | 4GB |2    |CentOS 7|192.168.99.101|
|  Worker01  | 4GB |2    |CentOS 7|192.168.99.102|
|  Worker02  | 4GB |2    |CentOS 7|192.168.99.103|

```
cat >> /etc/hosts <<EOF
192.168.99.101    master
192.168.99.102    worker1
192.168.99.103    worker2
EOF
```

```
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
systemctl stop firewalld
systemctl disable firewalld
systemctl status firewalld
```
* Update repo

```
vim /etc/yum.repos.d/CentOS-Base.repo

[base]
name=CentOS-$releasever - Base
baseurl=http://vault.centos.org/7.9.2009/os/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-$releasever - Updates
baseurl=http://vault.centos.org/7.9.2009/updates/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-$releasever - Extras
baseurl=http://vault.centos.org/7.9.2009/extras/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[centosplus]
name=CentOS-$releasever - Plus
baseurl=http://vault.centos.org/7.9.2009/centosplus/$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

```

```
yum clean all && yum repolist
yum groupinstall "Development Tools" -y
yum install yum-utils -y
```

### Step 2: Set file hosts, hostname for master, worker1, worker2

```
vi /etc/hosts
192.168.99.101 	master 
192.168.99.102 	worker1
192.168.99.103	worker2
```

```
- Node master:
hostnamectl set-hostname master
exec bash

- Node Worker01:
hostnamectl set-hostname worker01
exec bash

- Node Worker02:
hostnamectl set-hostname worker02
exec bash
```
 
### Step 3: Turn-Off Swap (all nodes)

```
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
 
cat > /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
 
modprobe overlay
modprobe br_netfilter
 
cat << EOF > /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
vm.swappiness = 0
EOF

#Make the above settings applicable without restarting. 

sysctl --system
```

### Step 4: Install containerd

Add the official Docker repository:

```
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum update -y
```

Or use curl file:

```
curl -Lo /etc/yum.repos.d/docker-ce.repo https://raw.githubusercontent.com/anhbka/Ansible/master/Repo/docker-ce.repo
``` 
 
Install the containerd package:

`yum install -y containerd.io `
 
Create a configuration file for containerd and set it to default:
 
```
mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

#If want change to gcr.io repo run command bellow

sed -i '/\[plugins."io.containerd.grpc.v1.cri".registry.mirrors\]/a \
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."gcr.io"] \
          endpoint = ["https://gcr.io"]' /etc/containerd/config.toml
          
cat /etc/containerd/config.toml | egrep -iE "registry.mirrors|io.containerd.grpc.v1.cri" -C5
``` 
 
Restart containerd

To apply the changes made in the last step, restart containerd.

```
systemctl enable --now containerd.service
``` 
 
Verify that containerd is running using this command:

```
[root@master ~]# ps -ef | grep containerd
root       43905       1  1 15:50 ?        00:00:00 /usr/bin/containerd
root       43974     982  0 15:50 pts/0    00:00:00 grep --color=auto containerd
```

### Step 5: Add the Kubernetes repository

```
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
```

Refer: `https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/`

Or you can use other repo bellow:

```
cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
```

### Step 6: Install Modules update your machines and then install all Kubernetes modules.


`yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes`

### Step 7: Enable kubelet

Enable the Kubelet service on all machines.

`systemctl enable kubelet --now`

`crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock` `#Fix warning crictl`

*Don’t worry about any kubelet errors at this point. Once the worker nodes are successfully joined to the Kubernetes cluster using the provided join command, the kubelet service on each worker node will automatically activate and start communicating with the control plane. The kubelet is responsible for managing the containers on the node and ensuring that they run according to the specifications provided by the Kubernetes control plane.*

*NOTE: Up until this point of the installation process, we’ve installed and configured Kubernetes components on all nodes. From this point onward, we will focus on the master node.*

### Step 8: Deploy the Cluster on node Master

Great! Let’s proceed with initializing the Kubernetes control plane on the master node. Here’s how we can do it:

```
kubeadm config images pull

```

After executing this command, Kubernetes will pull the necessary container images from the default container registry (usually Docker Hub) and store them locally on the machine. This step is typically performed before initializing the Kubernetes cluster to ensure that all required images are available locally and can be used without relying on an external registry during cluster setup.

`kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.99.101`

```
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.99.101:6443 --token tp8n7k.t9ac8ffvyrz0zt82 \
        --discovery-token-ca-cert-hash sha256:33f0e8633a735d82ea3df16127a7374333d2511d3f3a739228081939c5f6fea8
```

```
export KUBECONFIG=/etc/kubernetes/admin.conf
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl get nodes
NAME     STATUS     ROLES           AGE   VERSION
master   NotReady   control-plane   82s   v1.30.6

[root@master ~]# kubectl get pods -n kube-system
NAME                             READY   STATUS    RESTARTS   AGE
coredns-55cb58b774-d2jgj         0/1     Pending   0          91s
coredns-55cb58b774-nkffq         0/1     Pending   0          91s
etcd-master                      1/1     Running   0          107s
kube-apiserver-master            1/1     Running   0          107s
kube-controller-manager-master   1/1     Running   0          107s
kube-proxy-xps5v                 1/1     Running   0          91s
kube-scheduler-master            1/1     Running   0          107s

[root@master ~]# kubectl get pod -A
NAMESPACE     NAME                             READY   STATUS    RESTARTS   AGE
kube-system   coredns-55cb58b774-d2jgj         0/1     Pending   0          111s
kube-system   coredns-55cb58b774-nkffq         0/1     Pending   0          111s
kube-system   etcd-master                      1/1     Running   0          2m7s
kube-system   kube-apiserver-master            1/1     Running   0          2m7s
kube-system   kube-controller-manager-master   1/1     Running   0          2m7s
kube-system   kube-proxy-xps5v                 1/1     Running   0          111s
kube-system   kube-scheduler-master            1/1     Running   0          2m7s
```

- Enable Auto-Completion for Kubectl on master node:

```
yum install bash-completion -y
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
bash
```

### 2. Initializing Kubernetes Control Plane

### Step 9: Deploy the pod network to the cluster run on Master node.

```
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml
```

```
kubectl get pod -A
NAMESPACE     NAME                                       READY   STATUS              RESTARTS   AGE
kube-system   calico-kube-controllers-8558877b58-w6cw2   0/1     ContainerCreating   0          35s
kube-system   calico-node-fcc4d                          0/1     Init:2/3            0          35s
kube-system   coredns-55cb58b774-d2jgj                   0/1     ContainerCreating   0          13m
kube-system   coredns-55cb58b774-nkffq                   0/1     ContainerCreating   0          13m
kube-system   etcd-master                                1/1     Running             0          14m
kube-system   kube-apiserver-master                      1/1     Running             0          14m
kube-system   kube-controller-manager-master             1/1     Running             0          14m
kube-system   kube-proxy-xps5v                           1/1     Running             0          13m
kube-system   kube-scheduler-master                      1/1     Running             0          14m

kubectl get pod -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-8558877b58-w6cw2   1/1     Running   0          2m5s
kube-system   calico-node-fcc4d                          1/1     Running   0          2m5s
kube-system   coredns-55cb58b774-d2jgj                   1/1     Running   0          15m
kube-system   coredns-55cb58b774-nkffq                   1/1     Running   0          15m
kube-system   etcd-master                                1/1     Running   0          15m
kube-system   kube-apiserver-master                      1/1     Running   0          15m
kube-system   kube-controller-manager-master             1/1     Running   0          15m
kube-system   kube-proxy-xps5v                           1/1     Running   0          15m
kube-system   kube-scheduler-master                      1/1     Running   0          15m

kubectl get componentstatus
Warning: v1 ComponentStatus is deprecated in v1.19+
NAME                 STATUS    MESSAGE   ERROR
controller-manager   Healthy   ok
scheduler            Healthy   ok
etcd-0               Healthy   ok

kubectl get nodes -o wide
NAME     STATUS   ROLES           AGE   VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE          KERNEL-VERSION          CONTAINER-RUNTIME
master   Ready    control-plane   15m   v1.30.6   192.168.30.136   <none>        CentOS 7          5.14.0-522.el9.x86_64   containerd://1.7.22

kubectl get pods -n kube-system -o wide
NAME                                       READY   STATUS    RESTARTS   AGE     IP               NODE     NOMINATED NODE   READINESS GATES
calico-kube-controllers-8558877b58-w6cw2   1/1     Running   0          4m26s   10.244.219.67    master   <none>           <none>
calico-node-fcc4d                          1/1     Running   0          4m26s   192.168.30.136   master   <none>           <none>
coredns-55cb58b774-d2jgj                   1/1     Running   0          17m     10.244.219.66    master   <none>           <none>
coredns-55cb58b774-nkffq                   1/1     Running   0          17m     10.244.219.65    master   <none>           <none>
etcd-master                                1/1     Running   0          17m     192.168.30.136   master   <none>           <none>
kube-apiserver-master                      1/1     Running   0          17m     192.168.30.136   master   <none>           <none>
kube-controller-manager-master             1/1     Running   0          17m     192.168.30.136   master   <none>           <none>
kube-proxy-xps5v                           1/1     Running   0          17m     192.168.30.136   master   <none>           <none>
kube-scheduler-master                      1/1     Running   0          17m     192.168.30.136   master   <none>           <none>

```

### 3. Initializing Kubernetes worker node

### Step 10: Now we need to join worker machine node1/2 to k8 master. (Run on both worker01/02)

```
kubeadm join 192.168.99.101:6443 --token tp8n7k.t9ac8ffvyrz0zt82 \
        --discovery-token-ca-cert-hash sha256:33f0e8633a735d82ea3df16127a7374333d2511d3f3a739228081939c5f6fea8
```

- Run command line check on node master:

```
kubectl get nodes
NAME       STATUS   ROLES           AGE   VERSION
master     Ready    control-plane   30m   v1.30.6
worker01   Ready    <none>          25m   v1.30.6
worker02   Ready    <none>          25m   v1.30.6
```

- Note: If you forget to copy the command, or can’t find it anymore, you can regenerate it by using the following command:

```
Get Join Command on Master Node

kubeadm token create --print-join-command 
kubeadm join 192.168.99.101:6443 --token spbila.60jx8l4ioplnafnc --discovery-token-ca-cert-hash sha256:99dd6c409251c54f30ff0a16efce6ac683e5b10c3c138df5bbc4d09036752c53
```

### Step 11: NGINX Test Deployment (Run on master node)

To test your Kubernetes cluster, you can deploy a simple application such as a NGINX web server. Here’s a sample YAML manifest to deploy NGINX as a test deployment:

```
vim nginx-deployment.yaml
```
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```
```
kubectl apply -f nginx-deployment.yaml
```
```
kubectl get deployments
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           14m
```
```
k get pod
```
```
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-576c6b7b6-28x9d   1/1     Running   0          14m
nginx-deployment-576c6b7b6-6vtg9   1/1     Running   0          14m
nginx-deployment-576c6b7b6-s4v2r   1/1     Running   0          14m
```

Expose NGINX to the external network:

```
vim nginx-service.yaml
```
```
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer
```
```  
kubectl get service nginx-service
```
```
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nginx-service   LoadBalancer   10.97.191.219   <pending>     80:30568/TCP   6s
  
```

That’s it! Our 1-master-2-worker Kubernetes cluster is ready!
To add more nodes, simply repeat this step on other machines.