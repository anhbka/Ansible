### Install Harbor 

### Install docker

```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io

sudo systemctl start docker
sudo systemctl enable docker

sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker --version
docker-compose --version
```

### Create certificate SSL 

### 1. Generate a CA certificate private key

```
openssl genrsa -out ca.key 4096
```

### 2. Generate the CA certificate

```
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=myharbor.harborsdsv.com" \
 -key ca.key \
 -out ca.crt
```
### Generate a Server Certificate

The certificate usually contains a .crt file and a .key file, for example, yourdomain.com.crt and yourdomain.com.key.

### 1. Generate a private key

```
openssl genrsa -out myharbor.harborsdsv.com.key 4096	
```
### 2. Generate a certificate signing request (CSR)

Adapt the values in the -subj option to reflect your organization. If you use an FQDN to connect your Harbor host, you must specify it as the common name (CN) attribute and use it in the key and CSR filenames.

```
openssl req -sha512 -new \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=myharbor.harborsdsv.com" \
    -key myharbor.harborsdsv.com.key \
    -out myharbor.harborsdsv.com.csr
```

### 3. Generate an x509 v3 extension file

Regardless of whether you’re using either an FQDN or an IP address to connect to your Harbor host, you must create this file so that you can generate a certificate for your Harbor host that complies with the Subject Alternative Name (SAN) and x509 v3 extension requirements. Replace the DNS entries to reflect your domain.

```	
cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=harborsdsv.com
DNS.2=*.harborsdsv.com
DNS.3=*.myharbor.harborsdsv.com
EOF	
```	
### 4. Use the v3.ext file to generate a certificate for your Harbor host.
	
Replace the yourdomain.com in the CRS and CRT file names with the Harbor host name.

```	
openssl x509 -req -sha512 -days 3650 -extfile v3.ext -CA ca.crt -CAkey ca.key -CAcreateserial -in myharbor.harborsdsv.com.csr -out myharbor.harborsdsv.com.crt
```

Convert yourdomain.com.crt to yourdomain.com.cert, for use by Docker.

The Docker daemon interprets .crt files as CA certificates and .cert files as client certificates.

https://goharbor.io/docs/1.10/install-config/configure-https/

```	
openssl x509 -inform PEM -in myharbor.harborsdsv.com.crt -out myharbor.harborsdsv.com.cert
	
cp -rp ca.crt myharbor.harborsdsv.com.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust
cp -rp ca.crt myharbor.harborsdsv.com.cert myharbor.harborsdsv.com.key /etc/docker/certs.d/myharbor.harborsdsv.com/

mkdir -p /data/cert/
cp -rp ca.crt myharbor.harborsdsv.com.cert myharbor.harborsdsv.com.key /data/cert/	

systemctl restart docker
```

Add domain to file `/etc/hosts` `echo "192.168.30.101 myharbor.harborsdsv.com" >> /etc/hosts`

### Download and install Harbor

```
curl -L https://github.com/goharbor/harbor/releases/download/v2.6.1/harbor-offline-installer-v2.6.1.tgz -o harbor-offline-installer.tgz
tar xvf harbor-offline-installer.tgz
cd harbor
cp -rp harbor.yml.tmpl harbor.yml

# Change config

vi harbor.yml

hostname: myharbor.harborsdsv.com

# http related config
http:
  # port for http, default is 80. If https enabled, this port will redirect to https port
  port: 80

# https related config
https:
  # https port for harbor, default is 443
  port: 443
  # The path of cert and key files for nginx
  certificate: /etc/docker/certs.d/myharbor.harborsdsv.com/myharbor.harborsdsv.com.cert
  private_key: /etc/docker/certs.d/myharbor.harborsdsv.com/myharbor.harborsdsv.com.key

./prepare
./install.sh
```

Login `https://myharbor.harborsdsv.com/` with user `admin` password `Harbor12345`

### Create project

```
Projects --> Project Name --> Public/Private --> OK
```

### Login Harbor

```
docker login myharbor.harborsdsv.com
docker pull nginx
docker tag nginx:latest myharbor.harborsdsv.com/myproject/nginx:latest
docker push myharbor.harborsdsv.com/myproject/nginx:latest
docker images
```

<img src="/img/harbor.png">