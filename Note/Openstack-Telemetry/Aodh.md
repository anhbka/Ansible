## 1. Vai trò của Aodh

Aodh là project nhỏ dùng để cảnh báo trong project Telemetry, trước đây nó thuộc về Ceilometer, tuy nhiên do một số hạn chế nên tới bản Liberty thì nó được tách riêng ra. Nó cung cấp các daemons để tính toán cũng như đưa ra các cảnh báo dựa vào các rules được định nghĩa từ trước.

Hiện tại aodh chỉ hỗ trợ 3 loại action đối với alarm output:

+ HTTP callback: Cung cấp 1 url để aodh đẩy một đoạn post request tới.

+ Phần nội dung của đoạn request này chứa tất cả nội dung vì sao cảnh báo được đưa ra.

+ log: Sử dụng chủ yếu để debug, lưu trữ dữ liệu trong 1 log file

+ zaqar: Gửi thông báo tới messaging service thông qua zaqar api.

## 2. Kiến trúc tổng quan

Aodh bao gồm một số thành phần chính:

+ API server (aodh-api): cung cấp api để lấy thông tin về cảnh báo

+ alarm evaluator (aodh-evaluator): Có nhiệm vụ xác định xem khi nào thì cảnh báo được bật.

+ notification listener (aodh-listener): đánh giá khả năng cảnh báo. Nó lắng nghe từ queue và ước lượng việc cảnh báo nếu sự kiện cho cảnh báo được nhận.

+ alarm notifier (aodh-notifier): gửi các thông tin cảnh báo với các trangj thái của từng cảnh báo (ok, alarm, insufficient data). Service này cần kết nối tới AMQP.


## 3. Hướng dẫn cấu hình

Trước khi bạn cài đặt và cấu hình Telemetry service,bạn phải tạo database, service credentials và API endpoints.

`mysql -u root -pWelcome123`

``` sh
CREATE DATABASE aodh;
GRANT ALL PRIVILEGES ON aodh.* TO 'aodh'@'localhost' \
  IDENTIFIED BY 'Welcome123';
GRANT ALL PRIVILEGES ON aodh.* TO 'aodh'@'%' \
  IDENTIFIED BY 'Welcome123';
```

Tạo biến môi trường :

`. admin-openrc`

Khởi tạo service credentials:

``` sh
openstack user create --domain default \
  --password-prompt aodh
User Password:
Repeat User Password:
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| domain_id           | default                          |
| enabled             | True                             |
| id                  | b7657c9ea07a4556aef5d34cf70713a3 |
| name                | aodh                             |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
```

Tạo admin và role:

`openstack role add --project service --user aodh admin`

Tạo aodh service entity:

``` sh
openstack service create --name aodh \
  --description "Telemetry" alarming
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | Telemetry                        |
| enabled     | True                             |
| id          | 3405453b14da441ebb258edfeba96d83 |
| name        | aodh                             |
| type        | alarming                         |
+-------------+----------------------------------+
```

Khởi tạo Alarming service API endpoints:

``` sh
$ openstack endpoint create --region RegionOne \
  alarming public http://controller:8042
  +--------------+----------------------------------+
  | Field        | Value                            |
  +--------------+----------------------------------+
  | enabled      | True                             |
  | id           | 340be3625e9b4239a6415d034e98aace |
  | interface    | public                           |
  | region       | RegionOne                        |
  | region_id    | RegionOne                        |
  | service_id   | 8c2c7f1b9b5049ea9e63757b5533e6d2 |
  | service_name | aodh                             |
  | service_type | alarming                         |
  | url          | http://controller:8042           |
  +--------------+----------------------------------+

$ openstack endpoint create --region RegionOne \
  alarming internal http://controller:8042
  +--------------+----------------------------------+
  | Field        | Value                            |
  +--------------+----------------------------------+
  | enabled      | True                             |
  | id           | 340be3625e9b4239a6415d034e98aace |
  | interface    | internal                         |
  | region       | RegionOne                        |
  | region_id    | RegionOne                        |
  | service_id   | 8c2c7f1b9b5049ea9e63757b5533e6d2 |
  | service_name | aodh                             |
  | service_type | alarming                         |
  | url          | http://controller:8042           |
  +--------------+----------------------------------+

$ openstack endpoint create --region RegionOne \
  alarming admin http://controller:8042
  +--------------+----------------------------------+
  | Field        | Value                            |
  +--------------+----------------------------------+
  | enabled      | True                             |
  | id           | 340be3625e9b4239a6415d034e98aace |
  | interface    | admin                            |
  | region       | RegionOne                        |
  | region_id    | RegionOne                        |
  | service_id   | 8c2c7f1b9b5049ea9e63757b5533e6d2 |
  | service_name | aodh                             |
  | service_type | alarming                         |
  | url          | http://controller:8042           |
  +--------------+----------------------------------+
```


Cài đặt packages:
``` 
apt-get install aodh-api aodh-evaluator aodh-notifier \
  aodh-listener aodh-expirer python-aodhclient -y
```

Chỉnh sửa file `vi  /etc/aodh/aodh.conf`

Cấu hình kết nối databases

```
[database]
connection = mysql+pymysql://aodh:Welcome123@controller/aodh
```

Cấu hình RabbitMQ và Identity

``` sh
[DEFAULT]
transport_url = rabbit://openstack:Welcome123@controller
auth_strategy = keystone

[keystone_authtoken]
www_authenticate_uri = http://controller:5000
auth_url = http://controller:5000
memcached_servers = controller:11211
auth_type = password
project_domain_id = default
user_domain_id = default
project_name = service
username = aodh
password = Welcome123
```

Cấu hình service credentials:

```
[service_credentials]
...
auth_type = password
auth_url = http://controller:5000/v3
project_domain_id = default
user_domain_id = default
project_name = service
username = aodh
password = Welcome123
interface = internalURL
region_name = RegionOne
```

Phân quyền và tạo wsgi để chạy aodh api:


``` sh
chmod 640 /etc/aodh/aodh.conf
chgrp aodh /etc/aodh/aodh.conf
mkdir /var/www/cgi-bin/aodh
cp /usr/lib/python2.7/site-packages/aodh/api/app.wsgi /var/www/cgi-bin/aodh/app
chown -R aodh. /var/www/cgi-bin/aodh
```




Để khởi tạo database chạy lệnh `su -s /bin/bash aodh -c "aodh-dbsync"`


Khởi động lại các service:
``` 
service aodh-api restart
service aodh-evaluator restart
service aodh-notifier restart
service aodh-listener restart
```
































































































































































































Tài liệu tham khảo :
https://docs.openstack.org/aodh/latest/install/install-ubuntu.html
