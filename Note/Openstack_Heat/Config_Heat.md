# 1. Cài đặt Heat 

+ Tạo databases
``` sh
mysql -u root -pWelcome123
CREATE DATABASE heat;
GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'localhost' \
  IDENTIFIED BY 'Welcome123';

  GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'%' \
  IDENTIFIED BY 'Welcome123';
```
+ Khai báo biến môi trường:
  
root@controller:~# . admin-openrc

+ Tạo user và các service:
``` sh
root@controller:~# openstack user create --domain default --password-prompt heat
User Password:
Repeat User Password:
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | default                          |
| enabled             | True                             |
| id                  | ee7420e001b7476d903442ecf2ca6299 |
| name                | heat                             |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
```
``` sh
root@controller:~# openstack role add --project service --user heat admin
root@controller:~# openstack service create --name heat \
>   --description "Orchestration" orchestration
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | Orchestration                    |
| enabled     | True                             |
| id          | 5619263c92dd469781a282104de0aac6 |
| name        | heat                             |
| type        | orchestration                    |
+-------------+----------------------------------+
```
``` sh
root@controller:~# openstack service create --name heat-cfn \
>   --description "Orchestration"  cloudformation
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | Orchestration                    |
| enabled     | True                             |
| id          | 524b9a553f344381a5102009bf7038e7 |
| name        | heat-cfn                         |
| type        | cloudformation                   |
+-------------+----------------------------------+
```
``` sh
root@controller:~# openstack endpoint create --region RegionOne \
>   orchestration public http://controller:8004/v1/%\(tenant_id\)s
+--------------+-----------------------------------------+
| Field        | Value                                   |
+--------------+-----------------------------------------+
| enabled      | True                                    |
| id           | 9109783bd01d4598982729edc38e1fac        |
| interface    | public                                  |
| region       | RegionOne                               |
| region_id    | RegionOne                               |
| service_id   | 5619263c92dd469781a282104de0aac6        |
| service_name | heat                                    |
| service_type | orchestration                           |
| url          | http://controller:8004/v1/%(tenant_id)s |
+--------------+-----------------------------------------+
```
``` sh
root@controller:~# openstack endpoint create --region RegionOne \
>   orchestration internal http://controller:8004/v1/%\(tenant_id\)s
+--------------+-----------------------------------------+
| Field        | Value                                   |
+--------------+-----------------------------------------+
| enabled      | True                                    |
| id           | cdfe38071a0f4e0fa5516c57bb8fd911        |
| interface    | internal                                |
| region       | RegionOne                               |
| region_id    | RegionOne                               |
| service_id   | 5619263c92dd469781a282104de0aac6        |
| service_name | heat                                    |
| service_type | orchestration                           |
| url          | http://controller:8004/v1/%(tenant_id)s |
+--------------+-----------------------------------------+
```
``` sh
root@controller:~# openstack endpoint create --region RegionOne \
>   orchestration admin http://controller:8004/v1/%\(tenant_id\)s
+--------------+-----------------------------------------+
| Field        | Value                                   |
+--------------+-----------------------------------------+
| enabled      | True                                    |
| id           | a21a6e1634924792a08a497b0c84611a        |
| interface    | admin                                   |
| region       | RegionOne                               |
| region_id    | RegionOne                               |
| service_id   | 5619263c92dd469781a282104de0aac6        |
| service_name | heat                                    |
| service_type | orchestration                           |
| url          | http://controller:8004/v1/%(tenant_id)s |
+--------------+-----------------------------------------+
```
``` sh
root@controller:~# openstack endpoint create --region RegionOne \
>   cloudformation public http://controller:8000/v1
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 13e36678b2e14a07a7f92a96ef0af72f |
| interface    | public                           |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 524b9a553f344381a5102009bf7038e7 |
| service_name | heat-cfn                         |
| service_type | cloudformation                   |
| url          | http://controller:8000/v1        |
+--------------+----------------------------------+
```
``` sh
root@controller:~# openstack endpoint create --region RegionOne \
>   cloudformation internal http://controller:8000/v1
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 5d851af9fe0147969284d5f43f7d750d |
| interface    | internal                         |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 524b9a553f344381a5102009bf7038e7 |
| service_name | heat-cfn                         |
| service_type | cloudformation                   |
| url          | http://controller:8000/v1        |
+--------------+----------------------------------+
```
``` sh
root@controller:~# openstack endpoint create --region RegionOne \
>   cloudformation admin http://controller:8000/v1
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | 05347308f6b54dc49d39adc52063a6d2 |
| interface    | admin                            |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 524b9a553f344381a5102009bf7038e7 |
| service_name | heat-cfn                         |
| service_type | cloudformation                   |
| url          | http://controller:8000/v1        |
+--------------+----------------------------------+
```
``` sh
root@controller:~# openstack domain create --description "Stack projects and users" heat
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | Stack projects and users         |
| enabled     | True                             |
| id          | 85ef3ce775c64e56a95ca267a6547ea0 |
| name        | heat                             |
| tags        | []                               |
+-------------+----------------------------------+
```
``` sh
root@controller:~# openstack user create --domain heat --password-prompt heat_domain_admin
User Password:
Repeat User Password:
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | 85ef3ce775c64e56a95ca267a6547ea0 |
| enabled             | True                             |
| id                  | 4a31f36dbb474d9aa4e849b77e5d59cd |
| name                | heat_domain_admin                |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
```
``` sh
root@controller:~# openstack role add --domain heat --user-domain heat --user heat_domain_admin admin
root@controller:~# openstack role create heat_stack_user
+-----------+----------------------------------+
| Field     | Value                            |
+-----------+----------------------------------+
| domain_id | None                             |
| id        | e23118f3e6ef433590e690a19d5c65b1 |
| name      | heat_stack_user                  |
+-----------+----------------------------------+
```

``` sh
root@controller:~# . admin-openrc
root@controller:~# openstack orchestration service list
+------------+-------------+--------------------------------------+------------+--------+----------------------------+--------+
| Hostname   | Binary      | Engine ID                            | Host       | Topic  | Updated At                 | Status |
+------------+-------------+--------------------------------------+------------+--------+----------------------------+--------+
| controller | heat-engine | 1f3c4b4d-ed74-4e99-88c6-9c9eaf754e85 | controller | engine | 2018-07-23T11:16:27.000000 | up     |
| controller | heat-engine | 5cd250ed-68ed-40fd-9014-a8bc0ad2ebc5 | controller | engine | 2018-07-23T11:16:27.000000 | up     |
| controller | heat-engine | 28566103-9ba8-423c-bf2b-4e7cb864de54 | controller | engine | 2018-07-23T11:16:27.000000 | up     |
| controller | heat-engine | 8d73f34e-3cde-4478-baa6-561ff11cb356 | controller | engine | 2018-07-23T11:16:27.000000 | up     |
+------------+-------------+--------------------------------------+------------+--------+----------------------------+--------+
```

### Cài đặt packages


`apt-get install heat-api heat-api-cfn heat-engine`


* Chỉnh sửa file `vi /etc/heat/heat.conf`

* Cấu hình truy cập cơ sở dữ liệu.
```
[database]
connection = mysql+pymysql://heat:Welcome123@controller/heat


[DEFAULT] 
heat_metadata_server_url = http://controller:8000
heat_waitcondition_server_url = http://controller:8000/v1/waitcondition
stack_domain_admin = heat_domain_admin
stack_domain_admin_password = Welcome123
stack_user_domain_name = heat
transport_url = rabbit://openstack:Welcome123@controller
```
Cấu hình RabbitMQ


Cấu hình stack và thông tin đăng nhập quản trị.

``` sh
[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = heat
password = Welcome123



[trustee]
auth_type = password
auth_url = http://controller:5000
username = heat
password = Welcome123
user_domain_name = default

[clients_keystone]
auth_uri = http://controller:5000
```

Cấu hình dịch vụ Identity.


Đồng bộ dữ liệu Orchestration


`su -s /bin/sh -c "heat-manage db_sync" heat`



Khởi động lại các dịch vụ :

```sh
# service heat-api restart
# service heat-api-cfn restart
# service heat-engine restart
```




Tài liệu tham khảo :
https://docs.openstack.org/heat/queens/install/install-ubuntu.html









