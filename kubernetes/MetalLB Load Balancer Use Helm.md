### Helm Install MetalLB Load Balancer

### Helm Add Repository and Update

- We will add the helm repository and then make sure that all of our repositories are up to date.

```
helm repo add metallb https://metallb.github.io/metallb
helm repo update
```

### Values.yaml and IP Address Space Configuration

After everything has been updated we will need to configure the IP address range we are going to use. If we are using a specific range, instead of a subnet, the formatting is IP-IP, otherwise you would use IP/24 (or whatever your subnet mask is.)

Create a values.yaml file and paste the information below. Make sure you update the addresses range to the correct network. The network will need to be routable from your location to access it once it has been configured.

### Basic Configuration

```
$ cat values.yaml 
configInline:
  address-pools:
   - name: default
     protocol: layer2
     addresses:
     - 192.168.99.240-192.168.99.250
```	 

### Advanced Example with Multiple Address Pools

```
configInline:
  address-pools:
  - name: production
    protocol: layer2
    addresses:
    - 192.168.144.0/20
  - name: staging
    protocol: layer2
    addresses:
    - 192.168.145.0/20
    auto-assign: false
```	

### Install MetalLB with Configured Values

After saving the values.yaml file we can finally install MetalLB using Helm.

`helm install metallb metallb/metallb -f values.yaml`

After installation we can verify the configuration.

```
$ kubectl get configmap metallb -o yaml
apiVersion: v1
data:
  config: |
    address-pools:
    - addresses:
      - 192.168.99.240-192.168.99.250
      name: default
      protocol: layer2
kind: ConfigMap
metadata:
  annotations:
    meta.helm.sh/release-name: metallb
    meta.helm.sh/release-namespace: default
  creationTimestamp: "2024-11-14T13:16:26Z"
  labels:
    app.kubernetes.io/instance: metallb
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: metallb
    app.kubernetes.io/version: v0.11.0
    helm.sh/chart: metallb-0.11.0
  name: metallb
  namespace: default
  resourceVersion: "373"
  uid: 7c13345b-2772-4eb8-8df2-77494e789044
```

Our configuration is using a single address range with auto-assign, which means when we create a LoadBalancer service it will automatically pick the next available address. Let’s create a service to see this in action. Save the following in `lb-deployment.yaml`.

```
apiVersion: v1
kind: Service
metadata:
  name: nginx
  annotations:
spec:
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: nginx
  type: LoadBalancer
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```		

Now create the service and deployment.

`kubectl create -f lb-deployment.yaml`

The service and deployment have been created which means we can see what IP address was associated from our MetalLB LoadBalancer pool. In this case we end up with 192.168.99.250 in the External-IP section.

```
$ kubectl get service nginx
NAME    TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
nginx   LoadBalancer   10.104.166.72  192.168.99.250  80:31254/TCP   4m40s
```

Let’s curl the endpoint and see if everything is working.

```
[root@master ~]# curl 192.168.99.250
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

Success! We were able to add MetalLB to a Kubernetes Cluster that didn’t have LoadBalancer support, and then we were able to provision a Service using the LoadBalancer type.