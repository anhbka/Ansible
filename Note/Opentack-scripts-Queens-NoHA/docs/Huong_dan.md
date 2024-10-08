### Hướng dẫn sử dụng scripts

### Mô hình 

<img src="/img/1.jpg">

### 1.Các bước thực hiện

**1.1. Đặt IP theo IP Planning cho từng node.**

* Trên Controller thực hiện

``` sh
curl -O https://raw.githubusercontent.com/anhbka/Opentack-scripts-Queens-NoHA/master/scripts/setup_ip.sh
bash setup_ip.sh controller 192.168.239.180 10.10.10.180 172.16.10.180 
```


* Trên Compute1 thực hiện

``` sh
curl -O https://raw.githubusercontent.com/anhbka/Opentack-scripts-Queens-NoHA/master/scripts/setup_ip.sh
bash setup_ip.sh compute1 192.168.239.181 10.10.10.181 172.16.10.181 
```
* Trên Compute2 thực hiện

``` sh
curl -O https://raw.githubusercontent.com/anhbka/Opentack-scripts-Queens-NoHA/master/scripts/setup_ip.sh
bash setup_ip.sh compute2 192.168.239.182 10.10.10.182 172.16.10.182 
```

* Thực hiện trên máy Cinder

``` sh
curl -O https://raw.githubusercontent.com/anhbka/Opentack-scripts-Queens-NoHA/master/scripts/setup_ip.sh
bash setup_ip.sh cinder1 192.168.239.183 10.10.10.183 172.16.10.183 
```

### Thực hiện script cài đặt OpenStack

### 2. Thực hiện cài đặt trên Controller

### 2.1. Tải script

Đứng trên node CTL1 và thực hiện các bước dưới.

Chuyển sang quyền root: 
`su -`

* Cài đặt git và script cài đặt.

``` sh
git clone https://github.com/anhbka/Opentack-scripts-Queens-NoHA.git
mv Opentack-scripts-Queens-NoHA/scripts/ /root
cd scripts
chmod +x *.sh
```
Nếu muốn sửa các IP thì sử dụng VI hoặc VIM để sửa, cần lưu ý tên NICs và địa chỉ IP cần phải tương ứng (trong này này tên NICs là ens33, ens34, ens35)

Nếu cần thiết thì cài ứng dụng `byobu` để khi các phiên `ssh` bị mất kết nối thì có thể sử dụng lại (để sử đụng lại thì cần ssh vào và gõ lại lệnh byobu)

``` sh
sudo yum -y install byobu
```
* Gõ lệnh byobu

`byobu`

### 2.2. Thực thi script noha_ctl_prepare.sh

* Thực thi script noha_ctl_prepare.sh

```
bash noha_ctl_prepare.sh
```

* Trong quá trình chạy script, cần nhập password cho tài khoản root của máy COM1 và COM2

### 2.3. Thực thi script noha_ctl_install_db_rabbitmq.sh để cài đặt DB và các gói bổ trợ.

`bash noha_ctl_install_db_rabbitmq.sh`

### 2.4. Thực thi script ctl_keystone.sh để cài đặt Keystone.

```bash noha_ctl_keystone.sh```

* Sau khi cài đặt xong keystone, script sẽ tạo ra 2 file source admin-openrc và demo-openrc nằm ở thư mục root. Các file này chứa biến môi trường để làm việc với OpenStack. Thực hiện lệnh dưới để có thể tương tác với OpenStack bằng CLI.

```. admin-openrc```

Kiểm tra lại xem đã thao tác được với OpenStack bằng CLI hay chưa bằng lệnh:

```openstack token issue```

``` sh
[root@controller ~]# openstack token issue
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                                                                   |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| expires    | 2018-10-09T09:25:26+0000                                                                                                                                                                |
| id         | gAAAAABbvGX2T50yWwgjSzSDsyMpa8F9hjo_a8migLgiL0yvdr22RzEVac8AE9i3omGozEwPe5MPbnV_1kQfQstKC7IEuxMJZkm3aKPGrM8Ke4V8NNVpwBaleRT1VlZz4aKrA7UmiHa-Yspj-i1LBbJeBtcDzHUyGYnLGKXfqZWx3oykKCo4Dzs |
| project_id | 9f4df62d251d43d0bf82bbe4a44b8737                                                                                                                                                        |
| user_id    | d7a04ef8a6d24c3595af28cdd39fbed4                                                                                                                                                        |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
[root@controller ~]#
```
### 2.5. Thực thi script noha_ctl_glance.sh để cài đặt Glance.

* Thực thi script dưới để cài đặt Glance.

``` sh
 bash noha_ctl_glance.sh
```
* Kiểm tra các cài đặt.

``` sh
[root@controller ~]# openstack image list
+--------------------------------------+--------+--------+
| ID                                   | Name   | Status |
+--------------------------------------+--------+--------+
| bb0b06ac-1726-40b6-87f3-85161787ec3e | cirros | active |
+--------------------------------------+--------+--------+
[root@controller ~]#
```

### 2.6. Thực thi script noha_ctl_nova.sh.sh để cài đặt Nova.

* Thực thi script dưới để cài đặt Nova.
``` sh
bash noha_ctl_nova.sh
```

Sau khi script thực thi xong, kiểm tra xem nova đã cài đặt thành công trên Controller bằng lệnh dưới.

``` sh
[root@controller ~]# openstack compute service list
+----+------------------+------------+----------+---------+-------+----------------------------+
| ID | Binary           | Host       | Zone     | Status  | State | Updated At                 |
+----+------------------+------------+----------+---------+-------+----------------------------+
|  1 | nova-consoleauth | controller | internal | enabled | up    | 2018-10-09T09:40:47.000000 |
|  2 | nova-scheduler   | controller | internal | enabled | up    | 2018-10-09T09:40:54.000000 |
|  3 | nova-conductor   | controller | internal | enabled | up    | 2018-10-09T09:40:54.000000 |
+----+------------------+------------+----------+---------+-------+----------------------------+
[root@controller ~]#
```

### 2.7. Thực thi script noha_ctl_neutron.sh để cài đặt Neutron.

* Thực thi script dưới để cài đặt Neutron.

` bash noha_ctl_neutron.sh`

### 2.8. Thực thi script noha_ctl_cinder.sh để cài đặt Cinder.

Nếu cài riêng node cinder thì sử dụng lệnh:

`bash noha_ctl_cinder.sh`

Cài Cinder trên node controller sử dụng lệnh:

`bash noha_ctl_cinder.sh aio`

### 2.9. Thực thi script noha_ctl_horizon.sh để cài đặt Dashboad.

`bash noha_ctl_horizon.sh`

3. Thực hiện cài đặt trên Compute1 và Compute2 (cài Nova và Neutron)

Cài đặt nova và neutron cho Compute1 và Compute2

``` bash noha_com_install.sh```

Kiểm tra :

``` sh
[root@controller ~]# openstack network agent list
+--------------------------------------+--------------------+------------+-------------------+-------+-------+---------------------------+
| ID                                   | Agent Type         | Host       | Availability Zone | Alive | State | Binary                    |
+--------------------------------------+--------------------+------------+-------------------+-------+-------+---------------------------+
| 250bce8a-ad42-445d-b99e-2f0c055b9b36 | Linux bridge agent | compute2   | None              | :-)   | UP    | neutron-linuxbridge-agent |
| 32b8cac2-4a93-4c03-87f4-d5e4b5bf6c04 | DHCP agent         | compute1   | nova              | :-)   | UP    | neutron-dhcp-agent        |
| 37bee57f-891f-450d-96c4-8dd49cb4e352 | Metadata agent     | compute2   | None              | :-)   | UP    | neutron-metadata-agent    |
| 478ded24-0f7e-48ae-8274-3352fff73bb5 | Metadata agent     | compute1   | None              | :-)   | UP    | neutron-metadata-agent    |
| 643925b1-09f3-4f58-9a32-b259a2e040e5 | L3 agent           | controller | nova              | :-)   | UP    | neutron-l3-agent          |
| 65fc5152-9d32-450e-bc85-ff6a0a92ae1f | Linux bridge agent | compute1   | None              | :-)   | UP    | neutron-linuxbridge-agent |
| bfc376e8-fe37-441a-85e0-2029da169059 | Linux bridge agent | controller | None              | :-)   | UP    | neutron-linuxbridge-agent |
| cfbaf3dd-8cc5-4ec7-8c24-dfb0b1003bcc | DHCP agent         | compute2   | nova              | :-)   | UP    | neutron-dhcp-agent        |
+--------------------------------------+--------------------+------------+-------------------+-------+-------+---------------------------+
[root@controller ~]#

```

``` sh
[root@controller ~]#  openstack compute service list
+----+------------------+------------+----------+---------+-------+----------------------------+
| ID | Binary           | Host       | Zone     | Status  | State | Updated At                 |
+----+------------------+------------+----------+---------+-------+----------------------------+
|  1 | nova-consoleauth | controller | internal | enabled | up    | 2018-10-09T10:07:40.000000 |
|  2 | nova-scheduler   | controller | internal | enabled | up    | 2018-10-09T10:07:37.000000 |
|  3 | nova-conductor   | controller | internal | enabled | up    | 2018-10-09T10:07:37.000000 |
|  6 | nova-compute     | compute2   | nova     | enabled | up    | 2018-10-09T10:07:45.000000 |
|  7 | nova-compute     | compute1   | nova     | enabled | up    | 2018-10-09T10:07:39.000000 |
+----+------------------+------------+----------+---------+-------+----------------------------+
[root@controller ~]#
```

### 4. Cài đặt trên node Cinder

* Cài đặt git và script cài đặt.

``` sh
yum -y install git
git clone https://github.com/anhbka/Opentack-scripts-Queens-NoHA.git
mv Opentack-scripts-Queens-NoHA/scripts/ /root
cd scripts
chmod +x *.sh
bash noha_cinder_install.sh
```

Dùng lệnh kiểm tra trên node controller:

``` sh
[root@controller ~]# openstack volume service list
+------------------+-------------+------+---------+-------+----------------------------+
| Binary           | Host        | Zone | Status  | State | Updated At                 |
+------------------+-------------+------+---------+-------+----------------------------+
| cinder-backup    | controller  | nova | enabled | up    | 2018-10-10T01:37:50.000000 |
| cinder-scheduler | controller  | nova | enabled | up    | 2018-10-10T03:44:47.000000 |
| cinder-volume    | cinder1@lvm | nova | enabled | up    | 2018-10-10T03:44:49.000000 |
+------------------+-------------+------+---------+-------+----------------------------+
```




