### Ingress Controller Nginx

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

kubectl get ingress -A
```

- Create deployment `nginx-deployment.yaml`

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-service-1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-service-1
  template:
    metadata:
      labels:
        app: nginx-service-1
    spec:
      containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80

---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-service-2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-service-2
  template:
    metadata:
      labels:
        app: nginx-service-2
    spec:
      containers:
        - name: nginx
          image: nginx
          ports:
            - containerPort: 80
```
- Create service `nginx-service.yaml`

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-service-1
spec:
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 80
  selector:
    app: nginx-service-1
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service-2
spec:
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 80
  selector:
    app: nginx-service-2
```
- Apply all template

```
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service-1.yaml
kubectl apply -f nginx-service-2.yaml
```	

- Create file Ingress `nginx-ingress.yaml`

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
    - host: your-domain.com
      http:
        paths:
          - path: /service1
            pathType: Prefix
            backend:
              service:
                name: nginx-service-1
                port:
                  number: 80
          - path: /service2
            pathType: Prefix
            backend:
              service:
                name: nginx-service-2
                port:
                  number: 80
```



