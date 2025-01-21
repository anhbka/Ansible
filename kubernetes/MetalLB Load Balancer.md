### Installing MetalLB Load Balancer for Kubernetes Bare Metal VMs Cluster

MetalLB is a Kubernetes service implementation for LoadBalancer-type services. When a LoadBalancer service is requested, MetalLB dynamically allocates an IP address from the configured range and informs the network that the IP “lives” within the cluster.

### Steps 1: Enable strict ARP mode

If you’re using kube-proxy in IPVS mode, since Kubernetes v1.14.2 you have to enable strict ARP mode. You can achieve this by editing kube-proxy config in current cluster and Set ARP mode true. Find out this KubeProxyConfiguratuon block and change only `strictARP: true`

`kubectl edit configmap -n kube-system kube-proxy`

```
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "ipvs"
ipvs:
  strictARP: true
```

### Steps 2: Install MetalLB CRD & Controller using the official manifests by MetalLB

`kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml`

### Steps 3: Layer 2 Configuration for to advertise the IP Pool

```
If see Error:
Error from server (InternalError): error when creating "metallb-ipadd-pool.yaml": Internal error occurred: failed calling webhook "ipaddresspoolvalidationwebhook.metallb.io": failed to call webhook: Post "https://webhook-service.metallb-system.svc:443/validate-metallb-io-v1beta1-ipaddresspool?timeout=10s": dial tcp 10.103.157.82:443: connect: connection refused

kubectl get validatingwebhookconfiguration
kubectl delete validatingwebhookconfigurations.admissionregistration.k8s.io metallb-webhook-configuration
```

```
vim metallb-ipadd-pool.yaml
```
```
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.99.240-192.168.99.250
```



`kubectl apply -f metallb-ipadd-pool.yaml`

### Steps 4: Advertise the IP Address Pool

```
vim metallb-pool-advertise.yaml
```
```
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: example
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
```

`kubectl apply -f metallb-pool-advertise.yaml`

```
kubectl get pod -n metallb-system

NAME                          READY   STATUS    RESTARTS   AGE
controller-547c7bdf5c-rb9t8   1/1     Running   0          3m33s
speaker-92r6z                 1/1     Running   0          3m33s
speaker-h8tr2                 1/1     Running   0          3m33s
```

### Steps 5: Deploy Application and Expose service type LoadBalancer

```
kubectl create deployment nginx-web-server --image=nginx
kubectl expose deployment nginx-web-server --port=80 --target-port=80 --type=LoadBalancer
```
```
kubectl get svc
NAME               TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)        AGE
kubernetes         ClusterIP      10.96.0.1       <none>           443/TCP        24h
nginx-web-server   LoadBalancer   10.104.166.72   192.168.99.240   80:31254/TCP   8s
[root@master ~]# curl 192.168.99.240
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
It looks like you’ve successfully created and exposed the nginx-web-server deployment as a LoadBalancer service. `External IP: 192.168.99.240`