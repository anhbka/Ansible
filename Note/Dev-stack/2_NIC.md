### Cài đặt Devstack với 2 NIC

#### Hướng dẫn cài đặt devstack.
- Trên một node

##### Bước 1:
- Chuẩn bị một máy Centos 7 Server 64 bit với cấu hình
```sh
Cấu hình:
 - RAM 8GB
 - HDD:100GB
 - NIC: 01: 172.16.91.0.0/24

Phiên bản hệ điều hành: Centos 7 Server 64 bit
 
```

- Đăng nhập bằng tài khoản root và thực hiện các lệnh sau để update bản mới nhất :

`yum -y update`

##### Bước 2:
- Đăng nhập vào OS với tài khoản root.
- Tạo và gán cấu hình sudo cho user `stack`
```sh
sudo useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d
sudo su - stack

```


``` sh
## VM su dung 2 NIC
### ens34: MGNT
### ens33: EXT
#######################################

[[local|localrc]]
DEST=/opt/stack

# Logging
LOGFILE=$DEST/logs/stack.sh.log
VERBOSE=True
SCREEN_LOGDIR=$DEST/logs/screen
OFFLINE=False

# HOST
HOST_IP=172.16.91.128

# Credentials
ADMIN_PASSWORD=openstack
MYSQL_PASSWORD=$ADMIN_PASSWORD
RABBIT_PASSWORD=$ADMIN_PASSWORD
SERVICE_PASSWORD=$ADMIN_PASSWORD
SERVICE_TOKEN=$ADMIN_PASSWORD


disable_service n-net
enable_service q-svc
enable_service q-agt
enable_service q-dhcp
enable_service q-meta
enable_service q-l3

#ml2
Q_PLUGIN=ml2
Q_AGENT=openvswitch

# vxlan
Q_ML2_TENANT_NETWORK_TYPE=vxlan

# Networking
FLOATING_RANGE=172.16.91.0/24
Q_FLOATING_ALLOCATION_POOL=start=172.16.91.150,end=172.16.91.179
PUBLIC_NETWORK_GATEWAY=172.16.91.1

FIXED_RANGE=10.0.0.0/24
NETWORK_GATEWAY=10.0.0.1

PUBLIC_INTERFACE=ens33

Q_USE_PROVIDERNET_FOR_PUBLIC=True
Q_L3_ENABLED=True
Q_USE_SECGROUP=True
OVS_PHYSICAL_BRIDGE=br-ex
PUBLIC_BRIDGE=br-ex
OVS_BRIDGE_MAPPINGS=public:br-ex


disable_service tempest

#vnc
enable_service n-novnc
enable_service n-cauth
```

Trong file khai báo trên đã thực hiện:

- Khai báo mật khẩu cho các dịch vụ

- Kích hoạt Neutron cho devstack (từ bản Kilo trở đi, mặc định devstack sử dụng neutron thay cho nova-network)

- Dải mạng External là: 172.16.91.0/24

- Dải mạng Internal là: 10.0.0.0/24

- Sau khi cài devstack với file local trên xong, devstack sẽ tạo ra dải mạng external và bắt đầu từ 172.16.91.150 tới 172.16.91.200

- FLOATING_RANGE=172.16.91.0/24 Trùng với dải IP HOST_IP=172.16.91.128

- FIXED_RANGE=10.0.0.0/24 Dải IP private

### Các lệnh sử dụng trong devstack:
``` sh
Restart services dùng systemctl:

sudo systemctl -a  | grep devstack        (Status for All services)
sudo systemctl status devstack@*        (All services status)
sudo systemctl restart devstack@*       (Restart all)
sudo journalctl -f –unit devstack@*|n-*|q-*|c-*|g-*  (Logs)
Nova:
sudo systemctl status devstack@n-*
devstack@n-cpu.service (nova-compute)
devstack@n-sch.service (nova-scheduler)
devstack@n-cauth.service (nova-consoleaut)
devstack@n-cond-cell1.service  (nova-conductor)
devstack@n-super-cond.service (nova-conductor)
devstack@n-api-meta.service  (uwsgi)
devstack@n-api.service  (uwsgi)
devstack@n-novnc.service  (nova-novncproxy)
Neutron:
sudo systemctl status devstack@q-*
devstack@q-svc.service (neutron-server)
devstack@q-l3.service  (neutron-l3-agen)
devstack@q-dhcp.service (neutron-dhcp-ag)
devstack@q-agt.service (neutron-openvsw)
devstack@q-meta.service (neutron-metadat)
Cinder:
sudo systemctl status devstack@c-*
devstack@c-vol.service  (cinder-volume)
devstack@c-api.service (uwsgi)
devstack@c-sch.service (cinder-schedule)
Glance:
sudo systemctl status devstack@c-*
devstack@g-reg.service  (glance-registry)
devstack@g-api.service  (uwsgi)
sudo systemctl status devstack@keystone.service  (Keystone service)
sudo systemctl status devstack@placement-api.service  (uwsgi)
sudo systemctl status devstack@dstat.service (dstat.sh)
devstack@etcd.service  (etcd)



Restart Services qua Screen:

su – stack                          (Connect to stack user)
screen -ls                           (Lists screens)
script /dev/null           (Resolution for Error: ‘Cannot open your terminal ‘/dev/pts/0’)
screen -r stack                  (Attach into the screen)
ctrl+a ”                               (List all services)
g-api                                   (e.g select Glance API service)
ctrl+c                                  (Stop the service)
Click UP-Arrow (key) and press Enter  (Recall and execute previous service Start cmd)
ctr+a d                                (Detach from the screen)
exit
```



