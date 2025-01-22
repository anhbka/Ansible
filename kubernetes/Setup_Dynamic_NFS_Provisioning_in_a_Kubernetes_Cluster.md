### Setup Dynamic NFS Provisioning in a Kubernetes Cluster

### Step 1) Install and Configure NFS on the CentOS 8 / RHEL 8 server

Before we get started, we are going to use the setup below to simulate how the NFS protocol works in a client/server setup.


| Hostname | RAM | CPU | OS | IP Address |
|----------|-----|-----|----|------------|
|  Master  | 4GB |2    |RHEL 8|192.168.30.142|
|  Worker01  | 4GB |2    |RHEL 8|192.168.30.143|


```
dnf install nfs-utils -y

systemctl start nfs-server.service
systemctl enable nfs-server.service
```

You can verify the version of nfs protocol that you are running by executing the command:

```
rpcinfo -p | grep nfs
    100003    3   tcp   2049  nfs
    100003    4   tcp   2049  nfs
    100227    3   tcp   2049  nfs_acl
```

### Step 2) Creating and exporting NFS share	

```
mkdir -p /opt/dynamic-storage
chown -R nobody: /opt/dynamic-storage
chmod 777 /opt/dynamic-storage
```

Add the following entries in /etc/exports file

```
vi /etc/exports
```
```
/opt/dynamic-storage 192.168.30.0/24(rw,sync,no_all_squash,root_squash)
```

Save and close the file.

Note: Don’t forget to change network in exports file that suits to your deployment.

To make above changes into the effect, run


```
exportfs -arv

systemctl restart nfs-utils.service
```

```
cat /etc/exports
/opt/dynamic-storage 192.168.30.0/24(rw,sync,no_all_squash,root_squash)
```

* Let’s look at the meaning of the parameters used:

  * rw  – This stands for read/write. It grants read and write permissions to the NFS share.
  * sync – The parameter requires the writing of the changes on the disk first before any other operation can be carried out.
  * no_all_squash – This will map all the UIDs & GIDs from the client requests to identical UIDS and GIDs residing on the NFS server.
  * root_squash – The attribute maps requests from the root user on the client-side to an anonymous UID / GID.

### Step 3) Setting up the NFS Client system

```
dnf install nfs-utils nfs4-acl-tools -y
```

To display the mounted NFS shares on the server, use the showmount command:

```
showmount -e
Export list for master:
/opt/dynamic-storage 192.168.30.0/24
```

### Step 4) Mounting the remote NFS share located on the server

Next, we need to mount the remote NFS share directory sitting on the local client system. But first, let’s create a directory to mount the NFS share.


```
mkdir -p /data/client_share
```

To mount the NFS share, execute the command below. Recall that 192.168.2.102 is the IP address of the NFS server.

```
mount -t nfs 192.168.30.142:/opt/dynamic-storage /data/client_share
```

You can verify the remote NFS share has been mounted by executing:

```
mount | grep -i nfs
sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw,relatime)
nfsd on /proc/fs/nfsd type nfsd (rw,relatime)
192.168.30.142:/opt/dynamic-storage on /data/client_share type nfs4 (rw,relatime,vers=4.2,rsize=524288,wsize=524288,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=192.168.30.143,local_lock=none,addr=192.168.30.142)
```

To make the mount share persistent upon a reboot, you need to edit the /etc/fstab file and append the entry below.

```
echo "192.168.30.142:/opt/dynamic-storage  /data/client_share  nfs  defaults  0  0" >> /etc/fstab
```

### Step 5) Testing NFS Server & Client Setup

```
touch /opt/dynamic-storage/test.txt
```

- On Master:

```
[root@master ~]# ll /opt/dynamic-storage/test.txt
-rw-r--r-- 1 root root 0 Jan 22 22:52 /opt/dynamic-storage/test.txt
```

- On Worker01:

```
ll /data/client_share
total 0
-rw-r--r-- 1 root root 0 Jan 22 22:52 test.txt
```

### Step 6) Install and Configure NFS Client Provisioner

* Install Helm `https://github.com/anhbka/Ansible/blob/master/kubernetes/Install_helm.md`

Enable the helm repo by running following beneath command

```
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
```

Deploy provisioner using following helm command

```
helm install -n nfs-provisioning --create-namespace nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --set nfs.server=192.168.30.142 --set nfs.path=/opt/dynamic-storage
```

Step 7) Create Persistent Volume Claims (PVCs)

Above helm command will automatically create nfs-provisioning namespace and will install nfs provisioner pod/deployment, storage class with name (nfs-client) and will created the required rbac.

```
kubectl get all -n nfs-provisioning
kubectl get sc -n nfs-provisioning
```

Create Persistent Volume Claims (PVCs)

```
vi demo-pvc.yml
```

```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: demo-claim
  namespace: nfs-provisioning
spec:
  storageClassName: nfs-client
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 10Mi
```

```
kubectl create -f demo-pvc.yml
kubectl get pv,pvc -n nfs-provisioning
```

Step 8) Test and Verify Dynamic NFS Provisioning


```
vi test-pod.yml
```

```
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
  namespace: nfs-provisioning
spec:
  containers:
  - name: test-pod
    image: busybox:latest
    command:
      - "/bin/sh"
    args:
      - "-c"
      - "touch /mnt/SUCCESS && sleep 600"
    volumeMounts:
      - name: nfs-pvc
        mountPath: "/mnt"
  restartPolicy: "Never"
  volumes:
    - name: nfs-pvc
      persistentVolumeClaim:
        claimName: demo-claim
```

```
kubectl create -f test-pod.yml
kubectl get pods -n nfs-provisioning
```

Login to the pod and verify that nfs volume is mounted or not.

```
kubectl exec -it test-pod -n nfs-provisioning /bin/sh
df -Th
Filesystem           Type            Size      Used Available Use% Mounted on
overlay              overlay        45.1G      4.7G     40.3G  10% /
tmpfs                tmpfs          64.0M         0     64.0M   0% /dev
tmpfs                tmpfs           1.9G         0      1.9G   0% /sys/fs/cgroup
192.168.30.142:/opt/dynamic-storage/nfs-provisioning-demo-claim-pvc-67e52a41-acc1-4eca-ac00-0b34d54f4f8f

```

Great, above output from the pod confirms that dynamic NFS volume is mounted and accessible.

In the last, delete the pod and PVC and check whether pv is deleted automatically or not.

```
kubectl delete -f test-pod.yml
kubectl delete -f demo-pvc.yml
kubectl get pv,pvc -n  nfs-provisioning
```