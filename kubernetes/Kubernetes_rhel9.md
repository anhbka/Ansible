### How to Deploy Kubernetes Cluster on RHEL 9 with Kubeadm

Mount the RHEL Binary DVD ISO to a directory such as /mnt, e.g.:

```
mkdir -p  /mnt
mount -o loop rhel-baseos-9.0-x86_64-dvd.iso /mnt
mount /dev/sr0  /mnt
```

* Note: The Warning mount: /mnt/disc: WARNING: source write-protected, mounted read-only. is expected.

```
cat <<\EOF > /etc/yum.repos.d/rhel9dvd.repo 
[BaseOS]
name=BaseOS Packages Red Hat Enterprise Linux 9
metadata_expire=-1
gpgcheck=1
enabled=1
baseurl=file:///mnt/BaseOS/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[AppStream]
name=AppStream Packages Red Hat Enterprise Linux 9
metadata_expire=-1
gpgcheck=1
enabled=1
baseurl=file:///mnt/AppStream/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
EOF
```
- Clear the cache and check whether you are able to get the packages from this DVD repository:

```
yum clean all && yum repolist
yum groupinstall "Development Tools" -y
yum install yum-utils vim -y
```

### 1) Define Host Name and Update hosts file

```
hostnamectl set-hostname "master01"   // Master Node
hostnamectl set-hostname "worker01"   // Worker Node 1
hostnamectl set-hostname "worker02"   // Worker Node 2
```

Next, add the following lines to /etc/hosts file on each instance.

```
cat << EOF >> /etc/hosts
192.168.99.101  master01
192.168.99.102  worker01
192.168.99.103  worker02
EOF
```

Stop the firewall on all node:

```
systemctl stop firewalld
systemctl disable firewalld
```

### 2) Disable Swap and SELinux

Disable swap on each instance so that Kubernetes cluster works smoothly. Run beneath command on each instance to disable swap space.

```
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
```

Disable SELinux on each system using following set of commands

```
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config
```

### 3) Add Kernel Modules and Parameters

Add the following kernel modules using modprobe command.

```
modprobe overlay
modprobe br_netfilter
```
For the permanent loading, create a file (k8s.conf) with following content.

```
sudo tee /etc/modules-load.d/k8s.conf <<EOF
overlay
br_netfilter
EOF
```

Now, add the kernel parameters like IP forwarding. Create a file and load the parameters using sysctl command

```
tee /etc/sysctl.d/k8s.conf <<EOT
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOT

sysctl --system
```

### 4) Install Containerd

```
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install containerd.io -y
```

Post installation start & enable containerd service.

```
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

sudo systemctl start containerd
sudo systemctl enable containerd
```

### 5) Add Kubernetes Yum Repository

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

### 6) Install Kubeadm, kubelet & kubectl

```
sudo dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
```

### 7) Enable kubelet

Enable the Kubelet service on all machines.

`systemctl enable kubelet --now`

`crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock` #Fix warning crictl

*Don’t worry about any kubelet errors at this point. Once the worker nodes are successfully joined to the Kubernetes cluster using the provided join command, the kubelet service on each worker node will automatically activate and start communicating with the control plane. The kubelet is responsible for managing the containers on the node and ensuring that they run according to the specifications provided by the Kubernetes control plane.*

*NOTE: Up until this point of the installation process, we’ve installed and configured Kubernetes components on all nodes. From this point onward, we will focus on the master node.*

### 8): Deploy the Cluster on node Master

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

kubectl get pods -n kube-system
NAME                             READY   STATUS    RESTARTS   AGE
coredns-55cb58b774-d2jgj         0/1     Pending   0          91s
coredns-55cb58b774-nkffq         0/1     Pending   0          91s
etcd-master                      1/1     Running   0          107s
kube-apiserver-master            1/1     Running   0          107s
kube-controller-manager-master   1/1     Running   0          107s
kube-proxy-xps5v                 1/1     Running   0          91s
kube-scheduler-master            1/1     Running   0          107s

kubectl get pod -A
NAMESPACE     NAME                             READY   STATUS    RESTARTS   AGE
kube-system   coredns-55cb58b774-d2jgj         0/1     Pending   0          111s
kube-system   coredns-55cb58b774-nkffq         0/1     Pending   0          111s
kube-system   etcd-master                      1/1     Running   0          2m7s
kube-system   kube-apiserver-master            1/1     Running   0          2m7s
kube-system   kube-controller-manager-master   1/1     Running   0          2m7s
kube-system   kube-proxy-xps5v                 1/1     Running   0          111s
kube-system   kube-scheduler-master            1/1     Running   0          2m7s
```
### Initializing Kubernetes Control Plane

### 9): Deploy the pod network to the cluster.

```
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml

kubectl apply -f calico.yaml
```

```
[root@master ~]# kubectl apply -f calico.yaml
poddisruptionbudget.policy/calico-kube-controllers created
serviceaccount/calico-kube-controllers created
serviceaccount/calico-node created
serviceaccount/calico-cni-plugin created
configmap/calico-config created
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgpfilters.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/caliconodestatuses.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipreservations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
clusterrole.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrole.rbac.authorization.k8s.io/calico-node created
clusterrole.rbac.authorization.k8s.io/calico-cni-plugin created
clusterrolebinding.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrolebinding.rbac.authorization.k8s.io/calico-node created
clusterrolebinding.rbac.authorization.k8s.io/calico-cni-plugin created
daemonset.apps/calico-node created
deployment.apps/calico-kube-controllers created

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
master   Ready    control-plane   15m   v1.30.6   192.168.30.136   <none>        CentOS Stream 9   5.14.0-522.el9.x86_64   containerd://1.7.22

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

### Initializing Kubernetes worker node

### 10): Now we need to join worker machine node1/2 to k8 master. (Run on both worker01/02)

```
kubeadm join 192.168.99.101:6443 --token tp8n7k.t9ac8ffvyrz0zt82 \
        --discovery-token-ca-cert-hash sha256:33f0e8633a735d82ea3df16127a7374333d2511d3f3a739228081939c5f6fea8
```

```
kubeadm join 192.168.99.101:6443 --token tp8n7k.t9ac8ffvyrz0zt82 \
        --discovery-token-ca-cert-hash sha256:33f0e8633a735d82ea3df16127a7374333d2511d3f3a739228081939c5f6fea8
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-check] Waiting for a healthy kubelet at http://127.0.0.1:10248/healthz. This can take up to 4m0s
[kubelet-check] The kubelet is healthy after 1.003212527s
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```

- Run command line check on node master:

```
kubectl get nodes
NAME       STATUS   ROLES           AGE   VERSION
master     Ready    control-plane   20m   v1.30.6
worker01   Ready    <none>          53s   v1.30.6
```

- Note: If you forget to copy the command, or can’t find it anymore, you can regenerate it by using the following command:

```
Get Join Command on Master Node

kubeadm token create --print-join-command 
kubeadm join 192.168.99.101:6443 --token spbila.60jx8l4ioplnafnc --discovery-token-ca-cert-hash sha256:99dd6c409251c54f30ff0a16efce6ac683e5b10c3c138df5bbc4d09036752c53
```

- Enable Auto-Completion for Kubectl on master node:

```
dnf install bash-completion -y
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
bash
```

+ Run test:

```
[root@master ~]# k -
--as-group                  (Group to impersonate for the operation, this flag can be repeated to specify multiple groups.)
--as-uid                    (UID to impersonate for the operation.)
--as                        (Username to impersonate for the operation. User could be a regular user or a service account in a namespace.)
--cache-dir                 (Default cache directory)
--certificate-authority     (Path to a cert file for the certificate authority)
--client-certificate        (Path to a client certificate file for TLS)
--client-key                (Path to a client key file for TLS)
--cluster                   (The name of the kubeconfig cluster to use)
```

### 11): NGINX Test Deployment (Run on master node)

To test your Kubernetes cluster, you can deploy a simple application such as a NGINX web server. Here’s a sample YAML manifest to deploy NGINX as a test deployment:

```
vim nginx-deployment.yaml

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

kubectl get deployments
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           14m

k get pod
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-576c6b7b6-28x9d   1/1     Running   0          14m
nginx-deployment-576c6b7b6-6vtg9   1/1     Running   0          14m
nginx-deployment-576c6b7b6-s4v2r   1/1     Running   0          14m
```

Expose NGINX to the external network:

```
vim nginx-service.yaml

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
  
[root@master ~]# kubectl get service nginx-service
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nginx-service   LoadBalancer   10.97.191.219   <pending>     80:30568/TCP   6s
  
```

That’s it! Our 1-master-2-worker Kubernetes cluster is ready!
To add more nodes, simply repeat this step on other machines.
