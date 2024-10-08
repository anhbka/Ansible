### Openstack-OVS

### 1. Mô hình

<img src="/img/1.jpg">

### 2. Cài đặt

Set name controller: 

`hostnamectl set-hostname controller`

`hostnamectl set-hostname compute1`

`hostnamectl set-hostname compute2`

`/etc/hosts`

```sh 
192.168.239.190    controller
192.168.239.191    compute1
192.168.239.192	   compute2
192.168.30.40	controller
172.16.10.129	compute1
172.16.10.130	compute2
```

Tắt `firewall` và `selinux`:

``` sh
systemctl disable firewalld
systemctl stop firewalld
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```
Khởi động lại máy: ` init 6`


### Cài đặt Network Time Protocol (NTP)

`yum install chrony -y`

``` sh
sed -i "s/server 0.centos.pool.ntp.org iburst/server vn.pool.ntp.org iburst/g" /etc/chrony.conf

sed -i 's/server 1.centos.pool.ntp.org iburst/#server 1.centos.pool.ntp.org iburst/g' /etc/chrony.conf

sed -i 's/server 2.centos.pool.ntp.org iburst/#server 2.centos.pool.ntp.org iburst/g' /etc/chrony.conf

sed -i 's/server 3.centos.pool.ntp.org iburst/#server 3.centos.pool.ntp.org iburst/g' /etc/chrony.conf

sed -i 's/#allow 192.168.0.0\/16/allow 192.168.239.0\/24/g' /etc/chrony.conf
```
Chạy lệnh:

``` sh
systemctl enable chronyd.service
systemctl start chronyd.service
```

Kiểm tra:

`chronyc sources`

### Cài đặt repo

`yum install centos-release-openstack-queens -y`

`yum upgrade -y`

### Install the OpenStack client:

`yum install python-openstackclient -y`

### Install the openstack-selinux package:

`yum install openstack-selinux -y`

### SQL database

`yum install mariadb mariadb-server python2-PyMySQL -y`


`vi  /etc/my.cnf.d/openstack.cnf`

``` sh
[mysqld]
bind-address = 192.168.239.190

default-storage-engine = innodb
innodb_file_per_table = on
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
```
### Finalize installation

``` sh
systemctl enable mariadb.service
systemctl start mariadb.service
```
`mysql_secure_installation`


### Message queue

`yum install rabbitmq-server -y`

``` sh
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service
```

`rabbitmqctl add_user openstack Welcome123`

`rabbitmqctl set_permissions openstack ".*" ".*" ".*"`

### Memcached

`yum install memcached python-memcached -y`

`vi /etc/sysconfig/memcached`

` OPTIONS="-l 192.168.239.190,::1"`
```
systemctl enable memcached.service
systemctl start memcached.service
```
### Etcd

`yum install etcd -y`


`vi  /etc/etcd/etcd.conf`

``` sh
#[Member]
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="http://192.168.239.190:2380"
ETCD_LISTEN_CLIENT_URLS="http://192.168.239.190:2379"
ETCD_NAME="192.168.239.190"
#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.239.190:2380"
ETCD_ADVERTISE_CLIENT_URLS="http://192.168.239.190:2379"
ETCD_INITIAL_CLUSTER="192.168.239.190=http://192.168.239.190:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"
ETCD_INITIAL_CLUSTER_STATE="new"
```

``` sh
systemctl enable etcd
systemctl start etcd
```

### Keystone

```
mysql -u root -pWelcome123
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
IDENTIFIED BY 'Welcome123';
```
`yum install openstack-keystone httpd mod_wsgi -y`

`vi /etc/keystone/keystone.conf`
``` sh
[database]
connection = mysql+pymysql://keystone:Welcome123@192.168.239.190/keystone
[token]
provider = fernet 
```
`su -s /bin/sh -c "keystone-manage db_sync" keystone`

``` sh
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
```
```
keystone-manage bootstrap --bootstrap-password Welcome123 \
  --bootstrap-admin-url http://192.168.30.40:5000/v3/ \
  --bootstrap-internal-url http://192.168.30.40:5000/v3/ \
  --bootstrap-public-url http://192.168.30.40:5000/v3/ \
  --bootstrap-region-id RegionOne
```
`echo "ServerName controller" >> /etc/httpd/conf/httpd.conf`

`ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/`


``` sh
systemctl enable httpd.service
systemctl start httpd.service
```

``` sh
export OS_USERNAME=admin
export OS_PASSWORD=Welcome123
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://192.168.30.40:5000/v3
export OS_IDENTITY_API_VERSION=3
```

`openstack domain create --description "An Example Domain" example`

```
openstack project create --domain default \
  --description "Service Project" service
```

```
openstack project create --domain default \
  --description "Demo Project" demo
```

```
openstack user create --domain default \
  --password-prompt demo
```

`openstack role create user`


`openstack role add --project demo --user demo user`

`unset OS_AUTH_URL Welcome123`

```
openstack --os-auth-url http://192.168.30.40:5000/v3 \
  --os-project-domain-name Default --os-user-domain-name Default \
  --os-project-name admin --os-username admin token issue
  
openstack --os-auth-url http://192.168.30.40:5000/v3 \
  --os-project-domain-name Default --os-user-domain-name Default \
  --os-project-name demo --os-username demo token issue  

```

``` sh
vi  admin-openrc

export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=Welcome123
export OS_AUTH_URL=http://192.168.239.190:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2

vi  demo-openrc 

export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=Welcome123
export OS_AUTH_URL=http://192.168.239.190:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
```
` . admin-openrc`

`openstack token issue`

``` sh
[root@controller ~]# openstack token issue
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                                                                   |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| expires    | 2018-09-10T18:09:38+0000                                                                                                                                                                |
| id         | gAAAAABblqVSoYaGyLqTuDw8D3vXqenBcpILW0avq4tzcqgntTPA4OSRNr4S9Euwdt2qEPHxkcP3n2jlKW03ICR1d6FTumDw8smwsTpTQzcTcJJI_uGS22yzY7URQ2CCuglMtwE1ypnubWmLgt6XVj1JZ7_xaCYUhxOpJMltYoRtsEiFKpniNvw |
| project_id | 1e64b99c9c224b72bd0ed10153e3aa23                                                                                                                                                        |
| user_id    | 77b9b09b82e143ad89f99fd7a45fbbfa                                                                                                                                                        |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

### Glance

``` sh
mysql -u root -pWelcome123
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
  IDENTIFIED BY 'Welcome123';  
```

` . admin-openrc`

`openstack user create --domain default --password-prompt glance`

`openstack role add --project service --user glance admin`

``` sh
openstack service create --name glance \
  --description "OpenStack Image" image
  
openstack endpoint create --region RegionOne \
  image public http://192.168.30.40:9292  

openstack endpoint create --region RegionOne \
  image internal http://192.168.30.40:9292

openstack endpoint create --region RegionOne \
  image admin http://192.168.30.40:9292
```
`yum install openstack-glance -y`

`vi /etc/glance/glance-api.conf`

``` sh
[database]
connection = mysql+pymysql://glance:Welcome123@192.168.30.40/glance

[keystone_authtoken]
auth_uri = http://192.168.30.40:5000
auth_url = http://192.168.30.40:5000
memcached_servers = 192.168.30.40:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = Welcome123

[paste_deploy]
flavor = keystone

[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
```
`vi /etc/glance/glance-registry.conf`

``` sh
[database]
connection = mysql+pymysql://glance:Welcome123@192.168.30.40/glance
[keystone_authtoken]
auth_uri = http://192.168.30.40:5000
auth_url = http://192.168.30.40:5000
memcached_servers = 192.168.30.40:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = Welcome123

[paste_deploy]
flavor = keystone
```

`su -s /bin/sh -c "glance-manage db_sync" glance`


``` sh
systemctl enable openstack-glance-api.service \
  openstack-glance-registry.service
systemctl start openstack-glance-api.service \
  openstack-glance-registry.service
```  
` admin-openrc`

`wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img`

``` 
openstack image create "cirros" \
  --file cirros-0.4.0-x86_64-disk.img \
  --disk-format qcow2 --container-format bare \
  --public
```

`openstack image list`

### Nova

### Controller

``` sh
mysql -u root -pWelcome123
CREATE DATABASE nova_api;
CREATE DATABASE nova;
CREATE DATABASE nova_cell0;

GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';
  
GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';

GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';

GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';

GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' \
  IDENTIFIED BY 'Welcome123';

GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' \
  IDENTIFIED BY 'Welcome123';
```
`. admin-openrc`

`openstack user create --domain default --password-prompt nova`

`openstack role add --project service --user nova admin`

``` sh
openstack service create --name nova \
  --description "OpenStack Compute" compute

openstack endpoint create --region RegionOne \
  compute public http://192.168.30.40:8774/v2.1  

openstack endpoint create --region RegionOne \
  compute internal http://192.168.30.40:8774/v2.1

openstack endpoint create --region RegionOne \
  compute admin http://192.168.30.40:8774/v2.1
```

`openstack user create --domain default --password-prompt placement`

`openstack role add --project service --user placement admin`

`openstack service create --name placement --description "Placement API" placement`

``` sh
openstack endpoint create --region RegionOne placement public http://192.168.30.40:8778
openstack endpoint create --region RegionOne placement internal http://192.168.30.40:8778
openstack endpoint create --region RegionOne placement admin http://192.168.30.40:8778
```

```
yum install openstack-nova-api openstack-nova-conductor \
  openstack-nova-console openstack-nova-novncproxy \
  openstack-nova-scheduler openstack-nova-placement-api -y
```

`vi /etc/nova/nova.conf`

``` sh
[DEFAULT]
enabled_apis = osapi_compute,metadata
transport_url = rabbit://openstack:Welcome123@192.168.30.40
my_ip = 192.168.30.40
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver

[api_database]
connection = mysql+pymysql://nova:Welcome123@192.168.239.190/nova_api

[database]
connection = mysql+pymysql://nova:Welcome123@192.168.239.190/nova

[api]
auth_strategy = keystone

[keystone_authtoken]
auth_url = http://192.168.30.40:5000/v3
memcached_servers = 192.168.30.40:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = Welcome123

[vnc]
enabled = true
server_listen = $my_ip
server_proxyclient_address = $my_ip

[glance]
api_servers = http://192.168.30.40:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp

[placement]
os_region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://192.168.30.40:5000/v3
username = placement
password = Welcome123

```

`vi /etc/httpd/conf.d/00-nova-placement-api.conf` 

```
<Directory /usr/bin>
   <IfVersion >= 2.4>
      Require all granted
   </IfVersion>
   <IfVersion < 2.4>
      Order allow,deny
      Allow from all
   </IfVersion>
</Directory>
```

``` sh
systemctl restart httpd
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova
su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova
su -s /bin/sh -c "nova-manage db sync" nova
nova-manage cell_v2 list_cells


systemctl enable openstack-nova-api.service \
  openstack-nova-consoleauth.service openstack-nova-scheduler.service \
  openstack-nova-conductor.service openstack-nova-novncproxy.service
systemctl start openstack-nova-api.service \
  openstack-nova-consoleauth.service openstack-nova-scheduler.service \
  openstack-nova-conductor.service openstack-nova-novncproxy.service
```

### Compute

`yum install openstack-nova-compute -y`

`vi /etc/nova/nova.conf`

``` sh
[DEFAULT]
enabled_apis = osapi_compute,metadata
transport_url = rabbit://openstack:Welcome123@192.168.30.40
my_ip = 172.16.10.129
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver

[api]
auth_strategy = keystone

[keystone_authtoken]
auth_url = http://192.168.30.40:5000/v3
memcached_servers = 192.168.30.40:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = Welcome123

[vnc]
enabled = True
server_listen = 0.0.0.0
server_proxyclient_address = $my_ip
novncproxy_base_url = http://192.168.239.190:6080/vnc_auto.html

[glance]
api_servers = http://192.168.30.40:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp

[placement]
os_region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://192.168.30.40:5000/v3
username = placement
password = Welcome123

[libvirt]
virt_type = qemu

```
```
systemctl enable libvirtd.service openstack-nova-compute.service
systemctl start libvirtd.service openstack-nova-compute.service
```
Làm tương tự trên node compute2

`. admin-openrc`

`openstack compute service list`

`su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova`

`openstack catalog list`

`openstack image list`

`nova-status upgrade check`

### Cài đặt trên node controller
Cài các gói: `yum install openstack-neutron openstack-neutron-ml2 openstack-neutron-openvswitch ebtables -y`



Tạo database:
```
mysql -u root -pWelcome123
CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'Welcome123';
exit
```


Khởi tạo biến môi trường admin, thực hiện CLI:

`. admin-openrc`

Tạo chứng thực service:

Tạo neutron user:

`openstack user create --domain default --password Welcome123 neutron`

Tạo admin role tới neutron user:

`openstack role add --project service --user neutron admin`

Tạo đối tượng neutron service:

`openstack service create --name neutron --description "OpenStack Networking" network`

Tạo Networking service API endpoints:

`openstack endpoint create --region RegionOne network public http://192.168.30.40:9696`

`openstack endpoint create --region RegionOne network internal http://192.168.30.40:9696`

`openstack endpoint create --region RegionOne network admin http://192.168.30.40:9696`

Cấu hình Provider network
Cấu hình Chỉnh sửa file `/etc/neutron/neutron.conf:`

```
vi /etc/neutron/neutron.conf

[DEFAULT]
core_plugin = ml2
service_plugins = router
allow_overlapping_ips = true
transport_url = rabbit://openstack:Welcome123@192.168.30.40
auth_strategy = keystone
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true

[database]
connection = mysql+pymysql://neutron:Welcome123@192.168.30.40/neutron

[keystone_authtoken]
auth_uri = http://192.168.30.40:5000
auth_url = http://192.168.30.40:5000
memcached_servers = 192.168.30.40:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = Welcome123

[nova]
auth_url = http://192.168.30.40:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = Welcome123

[oslo_concurrency]
lock_path = /var/lib/neutron/tmp
```


Cấu hình file /etc/neutron/plugins/ml2/ml2_conf.ini:
```
vi /etc/neutron/plugins/ml2/ml2_conf.ini

[ml2]
type_drivers = flat,vlan,vxlan
tenant_network_types = vxlan
mechanism_drivers = openvswitch,l2population
extension_drivers = port_security


[ml2_type_flat]
flat_networks = provider

[ml2_type_vxlan]
vni_ranges = 1:1000

[securitygroup]
enable_ipset = true
```
Chỉnh sửa /etc/neutron/plugins/ml2/openvswitch_agent.ini

```
vi /etc/neutron/plugins/ml2/openvswitch_agent.ini


[ovs]
bridge_mappings = provider:br-provider
local_ip = 10.10.10.40

[agent]
tunnel_types = vxlan
l2_population = True


[securitygroup]
enable_security_group = true
firewall_driver = iptables_hybrid
```
Chỉnh sửa /etc/neutron/dhcp_agent.ini
```
vi /etc/neutron/dhcp_agent.ini

[DEFAULT]
interface_driver = openvswitch
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true
force_metadata = true
```
```
vi /etc/neutron/l3_agent.ini
[DEFAULT]
interface_driver = openvswitch
```
Chỉnh sửa /etc/neutron/metadata_agent.ini
```
vi /etc/neutron/metadata_agent.ini

[DEFAULT]
nova_metadata_host = 192.168.30.40
metadata_proxy_shared_secret = Welcome123
```
Chỉnh sửa `/etc/nova/nova.conf`

```
vi /etc/nova/nova.conf

[neutron]
url = http://192.168.30.40:9696
auth_url = http://192.168.30.40:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = Welcome123
service_metadata_proxy = true
metadata_proxy_shared_secret = Welcome123
```

Khởi động openvswitch:

```
systemctl start openvswitch.service
systemctl enable openvswitch.service
```


Setup lại card mạng `eth2`

``` sh
vi /etc/sysconfig/network-scripts/ifcfg-eth2

DEVICE=eth2
NAME=eth2
TYPE=OVSPort
DEVICETYPE=ovs
OVS_BRIDGE=br-provider
ONBOOT=yes
```
Setup card mạng br-provider
```
vi /etc/sysconfig/network-scripts/ifcfg-br-provider

DEVICE=br-provider
NAME=br-provider
DEVICETYPE=ovs
TYPE=OVSBridge
BOOTPROTO=static
IPADDR=192.168.50.240
ONBOOT=yes

```

Tạo OVS provider:

`ovs-vsctl add-br br-provider`

Flush ip cho card eth2

`ip addr flush dev eth2`

Gán interface vào port của br-provider

`ovs-vsctl add-port br-provider eth2`

Cho phép link kết nối tới br-provider hoạt động
`ip link set dev br-provider up && service network restart`


Kiểm tra
`ovs-vsctl show`



`ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini`

Đồng bộ database:

`su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron`


`systemctl restart openstack-nova-api.service`

```
systemctl enable neutron-server.service neutron-openvswitch-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service
systemctl start neutron-server.service neutron-openvswitch-agent.service neutron-dhcp-agent.service neutron-metadata-agent.service
```
Khởi động L3 agent
```
systemctl enable neutron-l3-agent.service
systemctl start neutron-l3-agent.service
```
### Cài đặt trên node compute


Cài đặt các thành phần

`yum install openstack-neutron-openvswitch ebtables ipset -y`

Cấu hình các thành phần bao gồm authentication mechanism, message queue, plug-in:

Cấu hình `/etc/neutron/neutron.conf`

```
vi /etc/neutron/neutron.conf

[DEFAULT]
transport_url = rabbit://openstack:Welcome123@192.168.30.40
auth_strategy = keystone
core_plugin = ml2

[keystone_authtoken]
auth_uri = http://192.168.30.40:5000
auth_url = http://192.168.30.40:5000
memcached_servers = 192.168.30.40:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = Welcome123

[oslo_concurrency]
lock_path = /var/lib/neutron/tmp
```

Chỉnh sửa `/etc/neutron/plugins/ml2/openvswitch_agent.ini`

```
vi /etc/neutron/plugins/ml2/openvswitch_agent.ini


[ovs]
bridge_mappings = provider:br-provider
local_ip = 10.10.10.41

[securitygroup]
enable_security_group = true
firewall_driver = iptables_hybrid

[agent]
tunnel_types = vxlan
l2_population = True


[securitygroup]
enable_security_group = true
firewall_driver = iptables_hybrid
```


Cấu hình Compute service sử dụng Networking service

Cấu hình file `/etc/nova/nova.conf`:
```
vi /etc/nova/nova.conf

[neutron]
url = http://192.168.30.40:9696
auth_url = http://192.168.30.40:5000
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = Welcome123
```

Khởi động lại Compute service:

`systemctl restart openstack-nova-compute.service`

Chạy Openvswitch agent:
```
systemctl enable neutron-openvswitch-agent.service
systemctl start neutron-openvswitch-agent.service
```

Khởi động openvswitch:

```
systemctl start openvswitch.service
systemctl enable openvswitch.service
```

Setup lại card mạng `eth2`

```
vi /etc/sysconfig/network-scripts/ifcfg-eth2

DEVICE=eth2
NAME=eth2
TYPE=OVSPort
DEVICETYPE=ovs
OVS_BRIDGE=br-provider
ONBOOT=yes
```
Setup card mạng `br-provider`
```
vi /etc/sysconfig/network-scripts/ifcfg-br-provider

DEVICE=br-provider
NAME=br-provider
DEVICETYPE=ovs
TYPE=OVSBridge
BOOTPROTO=static
IPADDR=192.168.50.241
ONBOOT=yes

```
Tạo OVS provider:

`ovs-vsctl add-br br-provider`

Flush ip cho card eth2

`ip addr flush dev eth2`

Gán interface vào port của br-provider

`ovs-vsctl add-port br-provider eth2`

Cho phép link kết nối tới br-provider hoạt động
`ip link set dev br-provider up && service network restart`


Kiểm tra

`ovs-vsctl show`
