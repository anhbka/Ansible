Bước 1:

Chuẩn bị một máy Ubuntu 16.04 Server 64 bit với cấu hình

Cấu hình tối thiểu
```
 - RAM 4GB
 - HDD:60GB
 - NIC: 01: 192.168.30.0/24
```

Phiên bản hệ điều hành: Ubuntu Server 14.04 64 bit
 
Đăng nhập bằng tài khoản root và thực hiện các lệnh sau để update bản mới nhất

`apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y && init 6`

Bước 2:

Đăng nhập vào OS với tài khoản root.

Tạo và gán cấu hình sudo cho user stack

```
adduser stack
apt-get -y install sudo 
apt-get -y install git
echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
```

Chuyển từ tài khoản root sang tài khoản stack :

`su - stack`

Bước 3: Tải mã nguồn của OpenStack trong repos devstack

Clone git của devstack về bằng lệnh git

Mặc định (nhánh master) trong git của devstack là source mới nhất của OpenStack.



`git clone  https://github.com/openstack-dev/devstack.git -b stable/queens`

Bước 4: Tạo file local.conf


``` sh
[[local|localrc]]
############################################################
# Customize the following HOST_IP based on your installation
############################################################
HOST_IP=192.168.30.40

ADMIN_PASSWORD=devstack
MYSQL_PASSWORD=devstack
RABBIT_PASSWORD=devstack
SERVICE_PASSWORD=$ADMIN_PASSWORD
SERVICE_TOKEN=devstack

############################################################
# Customize the following section based on your installation
############################################################

# Pip
PIP_USE_MIRRORS=False
USE_GET_PIP=1

#OFFLINE=False
#RECLONE=True

# Logging
LOGFILE=$DEST/logs/stack.sh.log
VERBOSE=True
ENABLE_DEBUG_LOG_LEVEL=True
ENABLE_VERBOSE_LOG_LEVEL=True

# Neutron ML2 with OpenVSwitch

Q_PLUGIN=ml2
Q_AGENT=openvswitch

#Disable security groups
Q_USE_SECGROUP=False
LIBVIRT_FIREWALL_DRIVER=nova.virt.firewall.NoopFirewallDriver

#NET K8S NETWORK CONFIGURATION
#FIXED_RANGE_K8S=${FIXED_RANGE_K8S:-192.168.72.0/22}
#NETWORK_GATEWAY_K8S=${NETWORK_GATEWAY_K8S:-192.168.72.1}
#NETWORK_GATEWAY_K8S_IP=${NETWORK_GATEWAY_K8S_IP:-192.168.72.1/24}

# Required for l3-agent to connect to external-network-bridge
PUBLIC_BRIDGE=br-ext

# Enable heat, networking-sfc, barbican and mistral
enable_plugin heat https://git.openstack.org/openstack/heat master
enable_plugin networking-sfc git://git.openstack.org/openstack/networking-sfc master
enable_plugin barbican https://git.openstack.org/openstack/barbican master
enable_plugin mistral https://git.openstack.org/openstack/mistral master

#Ceilometer
#CEILOMETER_PIPELINE_INTERVAL=300
enable_plugin ceilometer https://git.openstack.org/openstack/ceilometer master
enable_plugin aodh https://git.openstack.org/openstack/aodh master

#Tacker
enable_plugin tacker https://git.openstack.org/openstack/tacker master

enable_service n-novnc
enable_service n-cauth

disable_service tempest

#TACKER CONFIGURATION
USE_BARBICAN=True

# Enable Kubernetes and kuryr-kubernetes
#KUBERNETES_VIM=True
#NEUTRON_CREATE_INITIAL_NETWORKS=False
#enable_plugin kuryr-kubernetes https://git.openstack.org/openstack/kuryr-kubernetes master
#enable_plugin neutron-lbaas git://git.openstack.org/openstack/neutron-lbaas master
#enable_plugin devstack-plugin-container https://git.openstack.org/openstack/devstack-plugin-container master

[[post-config|/etc/neutron/dhcp_agent.ini]]
[DEFAULT]
enable_isolated_metadata = True
```












