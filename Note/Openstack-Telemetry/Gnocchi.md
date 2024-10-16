## 1. Vai trò của Gnocchi

Gnocchi là một time-series db được dùng để lưu các metrics hệ thống. Đầu tiên nó được phát triển nhằm thay thế cho mongodb trong ceilometer. Sau này nó được tách riêng ra để trở thành một project độc lập, hỗ trợ không chỉ ceilometer.

## 2. Các thành phần của Gnocchi

Gnocchi có một số thành phần:

+ HTTP REST API

+ stats daemon

+ gnocchi-metricd

Dữ liệu được lấy từ HTTP REST API hoặc stats daemon, gnocchi-metricd sẽ thực hiện các tác vụ còn lại (tính toán, dọn dẹp...). Các thành phần này đều có thể scale theo chiều ngang vì thế nó phục vụ tốt hơn cho các bài toán yêu cầu cao về HA cũng như mở rộng hệ thống.

<img src="/images/6.png">

<ul>

Gnocchi hỗ trợ 1 số loại backend để lưu metrics:


+ File (mặc định)

+ Ceph (preferred)

+ OpenStack Swift

+ Amazon S3

+ Redis

</ul>

<ul>

Đối với việc lưu trữ các index cũng như một số thông tin khác thì gnocchi sử dụng sql db.

+ PostgreSQL (khuyên dùng)

+ MySQL (từ bản 5.6.4)

</ul>

+ Archive policy sẽ định nghĩa cách mà các metrics thu thập được tính toán và số lượng aggregate sẽ được giữ.

+ Gnocchi sử dung 3 backend để lưu dữ liệu: một cho các measures mới, một để lưu aggregates và một cho indexing data. Thường thì 2 cái đầu sẽ được lưu cùng nhau.

+ Trong OPS, gnocchi-api được chạy bằng Apache httpd mod_wsgi.

## 2. Hướng dẫn cấu hình

Trước khi cài đặt và cấu hình Telemetry service bạn phải cấu hình để gửi dữ liệu,khuyến nghị endpoint là Gnocchi.

Tạo biến môi trường:

`. admin-openrc`

Tạo user `ceilometer`

``` sh
$ openstack user create --domain default --password-prompt ceilometer
User Password:
Repeat User Password:
+-----------+----------------------------------+
| Field     | Value                            |
+-----------+----------------------------------+
| domain_id | e0353a670a9e496da891347c589539e9 |
| enabled   | True                             |
| id        | c859c96f57bd4989a8ea1a0b1d8ff7cd |
| name      | ceilometer                       |
+-----------+----------------------------------+
```

Thêm user `ceilometer` vào role admin :

`openstack role add --project service --user ceilometer admin`

Đăng kí Gnocchi service trong Keystone,tạo user gnocchi:

```
$ openstack user create --domain default --password-prompt gnocchi
User Password:
Repeat User Password:
+-----------+----------------------------------+
| Field     | Value                            |
+-----------+----------------------------------+
| domain_id | e0353a670a9e496da891347c589539e9 |
| enabled   | True                             |
| id        | 8bacd064f6434ef2b6bbfbedb79b0318 |
| name      | gnocchi                          |
+-----------+----------------------------------+
```

Tạo `gnocchi service entity`:

```
$ openstack service create --name gnocchi \
  --description "Metric Service" metric
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | Metric Service                   |
| enabled     | True                             |
| id          | 205978b411674e5a9990428f81d69384 |
| name        | gnocchi                          |
| type        | metric                           |
+-------------+----------------------------------+
```

`$ openstack role add --project service --user gnocchi admin`


Khởi tạo `Metric service API endpoints`:

``` sh
$ openstack endpoint create --region RegionOne \
  metric public http://controller:8041
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | b808b67b848d443e9eaaa5e5d796970c |
| interface    | public                           |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 205978b411674e5a9990428f81d69384 |
| service_name | gnocchi                          |
| service_type | metric                           |
| url          | http://controller:8041           |
+--------------+----------------------------------+

$ openstack endpoint create --region RegionOne \
  metric internal http://controller:8041
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | c7009b1c2ee54b71b771fa3d0ae4f948 |
| interface    | internal                         |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 205978b411674e5a9990428f81d69384 |
| service_name | gnocchi                          |
| service_type | metric                           |
| url          | http://controller:8041           |
+--------------+----------------------------------+

$ openstack endpoint create --region RegionOne \
  metric admin http://controller:8041
+--------------+----------------------------------+
| Field        | Value                            |
+--------------+----------------------------------+
| enabled      | True                             |
| id           | b2c00566d0604551b5fe1540c699db3d |
| interface    | admin                            |
| region       | RegionOne                        |
| region_id    | RegionOne                        |
| service_id   | 205978b411674e5a9990428f81d69384 |
| service_name | gnocchi                          |
| service_type | metric                           |
| url          | http://controller:8041           |
+--------------+----------------------------------+
```

** Cài đặt Gnocchi **

Cài đặt Gnocchi packages:	

`# apt-get install gnocchi-api gnocchi-metricd python-gnocchiclient`

Tạo databases Gnocchi’s indexer:

```
mysql -u root -pWelcome123

CREATE DATABASE gnocchi;
GRANT ALL PRIVILEGES ON gnocchi.* TO 'gnocchi'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON gnocchi.* TO 'gnocchi'@'%' \
  IDENTIFIED BY 'Welcome123';
```

Chỉnh sửa file `vi /etc/gnocchi/gnocchi.conf `

Cấu hình gnocchi sử dụng keystone:

```
[api]
auth_mode = keystone
```

Cấu hình xác thực bằng keystone:


```
[keystone_authtoken]
...
auth_type = password
auth_url = http://controller:5000/v3
project_domain_name = Default
user_domain_name = Default
project_name = service
username = gnocchi
password = Welcome123
interface = internalURL
region_name = RegionOne
```

Cấu hình kết nối databases:

```
[indexer]
url = mysql+pymysql://gnocchi:Welcome123@controller/gnocchi
```

Cấu hình vị trí lưu metric data,chúng ta sẽ lưu vào local file system:

```
[storage]
# coordination_url is not required but specifying one will improve
# performance with better workload division across workers.
coordination_url = redis://controller:6379
file_basepath = /var/lib/gnocchi
driver = file
```

```
gnocchi-upgrade
```

Khởi động lại Gnocchi service:


```
# service gnocchi-api restart
# service gnocchi-metricd restart
```

Cài đặt Ceilometer packages:

```
apt-get install ceilometer-agent-notification \
  ceilometer-agent-central -y
```

Chỉnh sửa file `vi  /etc/ceilometer/pipeline.yaml`

```
publishers:
    # set address of Gnocchi
    # + filter out Gnocchi-related activity meters (Swift driver)
    # + set default archive policy
    - gnocchi://?filter_project=service&archive_policy=low
```

Chỉnh sửa file `vi  /etc/ceilometer/ceilometer.conf`


Cấu hình RabbitMQ:

```
[DEFAULT]
transport_url = rabbit://openstack:Welcome123@controller	
```

Cấu hình thông tin đăng nhập :

```
[service_credentials]
...
auth_type = password
auth_url = http://controller:5000/v3
project_domain_id = default
user_domain_id = default
project_name = service
username = ceilometer
password = Welcome123
interface = internalURL
region_name = RegionOne
```

Tạo tài nguyên Ceilometer trong Gnocchi `ceilometer-upgrade`.

Khởi động lại Telemetry service:

``` sh
# service ceilometer-agent-central restart
# service ceilometer-agent-notification restart
```

Kiểm tra lại Telemetry service.

``` sh
. admin-openrc
$ gnocchi resource list  --type image
+--------------------------------------+-------+----------------------------------+---------+--------------------------------------+----------------------------------+----------+----------------------------------+--------------+
| id                                   | type  | project_id                       | user_id | original_resource_id                 | started_at                       | ended_at | revision_start                   | revision_end |
+--------------------------------------+-------+----------------------------------+---------+--------------------------------------+----------------------------------+----------+----------------------------------+--------------+
| a6b387e1-4276-43db-b17a-e10f649d85a3 | image | 6fd9631226e34531b53814a0f39830a9 | None    | a6b387e1-4276-43db-b17a-e10f649d85a3 | 2017-01-25T23:50:14.423584+00:00 | None     | 2017-01-25T23:50:14.423601+00:00 | None         |
+--------------------------------------+-------+----------------------------------+---------+--------------------------------------+----------------------------------+----------+----------------------------------+--------------+

$ gnocchi resource show a6b387e1-4276-43db-b17a-e10f649d85a3
+-----------------------+-------------------------------------------------------------------+
| Field                 | Value                                                             |
+-----------------------+-------------------------------------------------------------------+
| created_by_project_id | aca4db3db9904ecc9c1c9bb1763da6a8                                  |
| created_by_user_id    | 07b0945689a4407dbd1ea72c3c5b8d2f                                  |
| creator               | 07b0945689a4407dbd1ea72c3c5b8d2f:aca4db3db9904ecc9c1c9bb1763da6a8 |
| ended_at              | None                                                              |
| id                    | a6b387e1-4276-43db-b17a-e10f649d85a3                              |
| metrics               | image.download: 839afa02-1668-4922-a33e-6b6ea7780715              |
|                       | image.serve: 1132e4a0-9e35-4542-a6ad-d6dc5fb4b835                 |
|                       | image.size: 8ecf6c17-98fd-446c-8018-b741dc089a76                  |
| original_resource_id  | a6b387e1-4276-43db-b17a-e10f649d85a3                              |
| project_id            | 6fd9631226e34531b53814a0f39830a9                                  |
| revision_end          | None                                                              |
| revision_start        | 2017-01-25T23:50:14.423601+00:00                                  |
| started_at            | 2017-01-25T23:50:14.423584+00:00                                  |
| type                  | image                                                             |
| user_id               | None                                                              |
+-----------------------+-------------------------------------------------------------------+
```


Tải image CirrOS từ Image service:


``` sh
$ IMAGE_ID=$(glance image-list | grep 'cirros' | awk '{ print $2 }')
$ glance image-download $IMAGE_ID > /tmp/cirros.img
```

``` sh
$ gnocchi measures show 839afa02-1668-4922-a33e-6b6ea7780715
+---------------------------+-------------+-----------+
| timestamp                 | granularity |     value |
+---------------------------+-------------+-----------+
| 2017-01-26T15:35:00+00:00 |       300.0 | 3740163.0 |
+---------------------------+-------------+-----------+
```

Xóa bỏ image đã tải trước đó `/tmp/cirros.img`

`$ rm /tmp/cirros.img`




























































