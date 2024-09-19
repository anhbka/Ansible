### Install helm Prometheus and Grafana on Kubernetes cluster

* From Script

```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

```

`curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash`

OR

```
wget https://get.helm.sh/helm-v3.16.1-linux-amd64.tar.gz
tar -xvf helm-v3.16.1-linux-amd64.tar.gz
cd linux-amd64 && mv helm /usr/bin/
helm version
```

- To get this Helm chart, let's run this command:

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

- To install Prometheus Helm Chart on Kubernetes Cluster, let's run the following command:

`helm install my-kube-prometheus-stack prometheus-community/kube-prometheus-stack`

- Check pod on Kubernetes:

`kubectl get all`

* Listed services for Prometheus and Grafana are:

```
alertmanager-operated
kube-prometheus-stack-alertmanager
kube-prometheus-stack-grafana
kube-prometheus-stack-kube-state-metrics
kube-prometheus-stack-operator
kube-prometheus-stack-prometheus
kube-prometheus-stack-prometheus-node-exporter
prometheus-operated
```

- Exposing Prometheus and Grafana using NodePort services:

```
kubectl expose service my-kube-prometheus-stack-prometheus --type=NodePort --target-port=9090 --name=prometheus-node-port-service

kubectl expose service my-kube-prometheus-stack-grafana --type=NodePort --target-port=3000 --name=grafana-node-port-service

kubectl get nodes -o wide
```

Run this command, to get the password for the admin user of the Grafana dashboard:

`kubectl get secret --namespace default my-kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo`

- Install kubectl metric API: `kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml`

- Fix tls metric API:

```
kubectl edit deployment metrics-server -n kube-system

add line:

- --kubelet-insecure-tls

kubectl rollout restart deployment metrics-server -n kube-system
```

- Import dashboard: `Dashboard --> New --> Import --> Find and import dashboards for common applications at https://grafana.com/grafana/dashboards/ ( Input 6417 and click load)`

- Fix logs warning:
```
WARN[0000] image connect using default endpoints: [unix:///run/containerd/containerd.sock unix:///run/crio/crio.sock unix:///var/run/cri-dockerd.sock]. As the default settings are now deprecated, you should set the endpoint instead.

crictl config --set runtime-endpoint=unix:///run/containerd/containerd.sock

systemctl set-default multi-user.target ## enable CLI boot mode
```