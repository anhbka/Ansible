### How to Deploy PostgreSQL on Kubernetes

* Install Helm

```
curl -O https://get.helm.sh/helm-v3.16.2-linux-amd64.tar.gz
tar xvf helm-v3.16.2-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
helm version
rm helm-v3.16.2-linux-amd64.tar.gz
```

* Create and Apply Persistent Storage Volume

- Note: Create `/mnt/data` on all node

```
vim postgres-pv.yaml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: postgresql-pv
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
kubectl apply -f postgres-pv.yaml	
	
```

* Create and Apply Persistent Volume Claim

```
vim postgres-pvc.yaml

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-psql-test-postgresql-0
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
	  
kubectl apply -f postgres-pvc.yaml	  
```


```
helm repo add bitnami https://charts.bitnami.com/bitnami

helm install psql-test bitnami/postgresql \
  --set persistence.existingClaim=postgresql-pv-claim \
  --set volumePermissions.enabled=true \
  --set postgresqlUsername=myuser \
  --set postgresqlPassword=mypassword \
  --set postgresqlDatabase=mydatabase

```
