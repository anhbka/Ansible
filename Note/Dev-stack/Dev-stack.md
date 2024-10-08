### Các ghi chép và hướng dẫn về devstack
- Các ghi chép hướng dẫn chạy devstack

#### Devstack là gì ???
- Tạm gọi devstack là OpenStack theo kiểu "mì tôm"
- Được sử dụng để cài đặt OpenStack native, hay sử dụng bởi các deverloper.
- Devstack KHÔNG được khuyến cáo để triển khai trong các môi trường Production

#### Các đặc điểm & ưu điểm của devstack
- Devstack được viết hoàn toàn bằng shell.
- Devstack cài đặt từ source bằng các tải trực tiếp các package từ GIT
- Devstack triển khai nhanh gọn, thường chạy với mô hình AIO
- Devstack có thể được sử dụng để cài các phiên bản của OpenStack (Liberty, Kilo, Juno ...). Nếu sử dụng nhánh master của GIT thì là bản mới nhất của OpenStack.
- Devstack thường được sử dụng để deverlop hoặc test các tính năng trong các phiên bản của OpenStack

#### Hướng dẫn cài đặt devstack.
- Trên một node

##### Bước 1:
- Chuẩn bị một máy Centos 7 Server 64 bit với cấu hình
```sh
Cấu hình:
 - RAM 8GB
 - HDD:100GB
 - NIC: 01: 192.168.239.0/24

Phiên bản hệ điều hành: Centos 7 Server 64 bit
 
```

- Đăng nhập bằng tài khoản root và thực hiện các lệnh sau để update bản mới nhất :

`yum -y update`

##### Bước 2:
- Đăng nhập vào OS với tài khoản root.
- Tạo và gán cấu hình sudo cho user `stack`
```sh
sudo useradd -s /bin/bash -d /opt/stack -m stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
sudo su - stack

```


- Chuyển từ tài khoản `root` sang tài khoản `stack` :
```sh
sudo su - stack
```

##### Bước 3: Tải mã nguồn của OpenStack trong repos devstack
- Clone git của devstack về bằng lệnh git
- Mặc định (nhánh master) trong git của devstack là source mới nhất của OpenStack.
- Trong git của devstack chứa các phiên bản của OpenStack (Mitaka, Liberty, Kilo, Juno ...)
- Trong hướng dẫn này sẽ thực hiển tải bản OpenStack Queens
```sh
git clone -b stable/queens https://github.com/openstack-dev/devstack.git
```

#### Bước 4: Tạo file local.conf
- Các shell trong devstack sẽ tham chiếu tới file local.conf để lấy giá trị các `biến` khi thực thi các dòng lệnh trong shell đó.
- File local cần phải các các khao báo tối thiểu về password cho các dịch vụ trong OpenStack như: MySQL, RabbitMQ .... Các biến còn lại sẽ lấy giá trị mặc định.
- Tùy vào tính năng cần test mà người dùng có thể khai báo trong file local.conf
- Trong ví dụ này chúng tôi sử dụng dải mạng 192.168.239.0/24 cho dải EXTERNAL
- Di chuyển vào thư mục `devstack`
```sh
cd /devstack/
```

-Tạo file local.conf với nội dung mẫu như sau, lưu ý tùy vào tình huống mà có thể sửa file này cho phù hợp.

``` sh
################################################################################# 

[[local|localrc]]
DEST=/opt/stack

# Logging
LOGFILE=$DEST/logs/stack.sh.log
VERBOSE=True
SCREEN_LOGDIR=$DEST/logs/screen
OFFLINE=False

# Controller  NODE IP
HOST_IP=192.168.239.138

MULTI_HOST=True

# Credentials
ADMIN_PASSWORD=openstack
MYSQL_PASSWORD=$ADMIN_PASSWORD
RABBIT_PASSWORD=$ADMIN_PASSWORD
SERVICE_PASSWORD=$ADMIN_PASSWORD
SERVICE_TOKEN=$ADMIN_PASSWORD

MYSQL_HOST=$HOST_IP
RABBIT_HOST=$HOST_IP
CINDER_SERVICE_HOST=$HOST_IP
GLANCE_HOSTPORT=$HOST_IP:9292
DATABASE_TYPE=mysql

##########################
# Khai bao cac project
##########################

enable_service rabbit mysql key horizon

##  CINDER Service
enable_service c-api
enable_service c-sch
enable_service c-bak
enable_service c-vol

## Khia bao tuy chon cho CINDER
VOLUME_GROUP="stack-volumes"
VOLUME_NAME_PREFIX="volume-"

# vnc
enable_service n-novnc
enable_service n-cauth

## Vo hieu hoa cac dich vu sau
disable_service n-net
disable_service tempest

## NEUTRON Service
enable_service q-svc
enable_service q-agt
enable_service q-dhcp
enable_service q-meta
enable_service q-l3

## Khai bao cac tham so cho neutron
# ml2
Q_PLUGIN=ml2
Q_AGENT=openvswitch

# vxlan
Q_ML2_TENANT_NETWORK_TYPE=vxlan

# Networking
FLOATING_RANGE=192.168.239.0/24
Q_FLOATING_ALLOCATION_POOL=start=192.168.239.200,end=192.168.239.250
PUBLIC_NETWORK_GATEWAY=192.168.239.1

# Khai bao dai mang private
FIXED_RANGE=10.10.10.0/24
NETWORK_GATEWAY=10.10.10.1

PUBLIC_INTERFACE=ens33

Q_USE_PROVIDERNET_FOR_PUBLIC=True
Q_L3_ENABLED=True
Q_USE_SECGROUP=True
OVS_PHYSICAL_BRIDGE=br-ex
PUBLIC_BRIDGE=br-ex
OVS_BRIDGE_MAPPINGS=public:br-ex

Q_ML2_PLUGIN_PATH_MTU=1454

# Setup phien ban IP se su dung
IP_VERSION=4
```

- Trong file khai báo trên đã thực hiện
 - Khai báo mật khẩu cho các dịch vụ
 - Kích hoạt Neutron cho devstack (từ bản Kilo trở đi, mặc định devstack sử dụng neutron thay cho nova-network)
 - Dải mạng External là: 192.168.239.0/24
 - Dải mạng Internet là: 192.168.239.0/24
 - Sau khi cài devstack với file local trên xong, devstack sẽ tạo ra dải mạng external và bắt đầu từ 192.168.239.200 tới 192.168.239.250
 - Thời gian cài đặt devstack có thể nhanh hay chậm tùy thuộc vào tốc độ internet. 
 - Có thể sử dụng các kỹ thuật repos, apt-cache để tăng tốc độ download các package khi cài devstack.

##### Bước 5: thực thi script
- Đảm bảo lúc này bạn đang ở thư mục /home/stack/devstack/ nhé và thực thi shell sau.
```sh
./stack.sh
```

##### Các chú ý khi khởi động lại devstack
- Fix lỗi Cinder
```sh
- Gõ lệnh dưới trước khi chạy .rejoin-stack

sudo losetup /dev/loop0 /opt/stack/data/stack-volumes-default-backing-file
sudo losetup /dev/loop1 /opt/stack/data/stack-volumes-lvmdriver-1-backing-file

```
- Sau khi khơi động lại devstack cần thực hiện lệnh sau: `./home/stack/rejoin-stack.sh`


``` sh
=========================
DevStack Component Timing
 (times are in seconds)
=========================
run_process           50
test_with_retry        7
pip_install          821
osc                  259
wait_for_service      61
yum_install          1054
git_timed            565
dbsync                46
-------------------------
Unaccounted time     477
=========================
Total runtime        3340



This is your host IP address: 192.168.239.138
This is your host IPv6 address: ::1
Horizon is now available at http://192.168.239.138/dashboard
Keystone is serving at http://192.168.239.138/identity/
The default users are: admin and demo
The password: openstack

WARNING:
Using lib/neutron-legacy is deprecated, and it will be removed in the future


Services are running under systemd unit files.
For more information see:
https://docs.openstack.org/devstack/latest/systemd.html

DevStack Version: queens
Change: a24e707724fad7c597d77beaacbe30dc01979839 Merge "Register versioned endpoint for block-storage service" into stable/queens 2018-08-13 02:57:34 +0000
OS Version: CentOS 7.5.1804 Core
```








































