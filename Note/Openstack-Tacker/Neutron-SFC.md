### 1. Neutron SFC


Sfc (Service function chain) cung cấp một chuỗi dịch vụ động để cho phép lưu lượng người thuê khác nhau được chuyển đến các mô-đun chức năng dịch vụ khác nhau theo các thứ tự khác nhau. Khái niệm này tương tự như chính sách định tuyến , trong đó SFC cho phép lưu lượng mạng đi qua một đường dẫn cụ thể, thay vì nhìn vào đích cuối cùng của bảng định tuyến thông qua địa chỉ đích IP. 
Sfc được sử dụng trong công nghệ mạng SDN và thường được sử dụng kết hợp với Network Function Virtualization để thực hiện các chức năng cụ thể. Ví dụ: chúng ta có thể buộc lưu lượng truy cập từ A đến B đi qua tường lửa trung gian hoặc không thông qua tường lửa, bất kể bảng định tuyến hiện tại.

Trong tacker tích hợp với sfc bằng cách gọi giao diện sfc để đạt được lưu lượng đặc điểm bố trí NFV.

### 2. Cài đặt

### Trên Controller

https://docs.openstack.org/networking-sfc/latest/

Cài đặt packages:

`yum install -y python-networking-sfc`

Hoặc :

`pip install -c https://git.openstack.org/cgit/openstack/requirements/plain/upper-constraints.txt?h=stable/queens networking-sfc==6.0.0`

Chỉnh sửa file cấu hình : `/etc/neutron/neutron.conf`

``` sh
service_plugins = ...,flow_classifier,sfc
```
Tạo mới thêm các option :

``` sh
[sfc]
drivers = ovs

[flowclassifier]
drivers = ovs
```

Khởi động lại neutron-server:

`systemctl restart neutron-server`


### Trên Compute

Chỉnh sửa file : `/etc/neutron/plugins/ml2/ml2_conf.ini`

``` sh
[agent]
extensions = sfc
```

Khởi động lại service :

`systemctl restart neutron-openvswitch-agent`

### Trên Controller

Đồng bộ dữ liệu:

`neutron-db-manage --subproject networking-sfc upgrade head`

### Mô hình

``` sh

         +------+     +------+        +------+
         | SF1  |     | SF2  |        | SF3  |
         +------+     +------+        +------+
         p1|   |p2    p3|   |p4       p5|   |p6
           |   |        |   |           |   |
VM 1-->----+   +--------+   +-----------+   +---->
```
``` sh
openstack network create sfc-net-1
openstack network create sfc-net-2
openstack network create sfc-net-3
openstack network create sfc-net-4
openstack sfc port pair create --ingress p1 --egress p2 port-pair-1
openstack sfc port pair create --ingress p3 --egress p4 port-pair-2
openstack sfc port pair create --ingress p5 --egress p6 port-pair-3
openstack sfc port pair group create --port-pair port-pair-1 port-pair-group-1
openstack sfc port pair group create --port-pair port-pair-2 port-pair-group-2
openstack sfc port pair group create --port-pair port-pair-3 port-pair-group-3
```

``` sh
[root@controller ~(keystone_admin)]# neutron port-create --name p1 provider
neutron CLI is deprecated and will be removed in the future. Use openstack CLI instead.
Created a new port:
+-----------------------+----------------------------------------------------------------------------------------+
| Field                 | Value                                                                                  |
+-----------------------+----------------------------------------------------------------------------------------+
| admin_state_up        | True                                                                                   |
| allowed_address_pairs |                                                                                        |
| binding:host_id       |                                                                                        |
| binding:profile       | {}                                                                                     |
| binding:vif_details   | {}                                                                                     |
| binding:vif_type      | unbound                                                                                |
| binding:vnic_type     | normal                                                                                 |
| created_at            | 2018-08-08T10:56:03Z                                                                   |
| description           |                                                                                        |
| device_id             |                                                                                        |
| device_owner          |                                                                                        |
| extra_dhcp_opts       |                                                                                        |
| fixed_ips             | {"subnet_id": "4a69e16b-befd-46e6-9a14-be6cf8f94b02", "ip_address": "192.168.239.221"} |
| id                    | fc28878f-e651-4c39-970c-6b16b746535f                                                   |
| mac_address           | fa:16:3e:60:0f:08                                                                      |
| name                  | p1                                                                                     |
| network_id            | 20b50db9-93eb-490d-9241-57d03500b1e0                                                   |
| port_security_enabled | True                                                                                   |
| project_id            | 206a373d117e4f9da3f2862d57425da7                                                       |
| revision_number       | 6                                                                                      |
| security_groups       | df31d4a6-3a37-4919-ac9d-a162c05fc1a3                                                   |
| status                | DOWN                                                                                   |
| tags                  |                                                                                        |
| tenant_id             | 206a373d117e4f9da3f2862d57425da7                                                       |
| updated_at            | 2018-08-08T10:56:04Z                                                                   |
+-----------------------+----------------------------------------------------------------------------------------+
[root@controller ~(keystone_admin)]# neutron port-create --name p2 provider
neutron CLI is deprecated and will be removed in the future. Use openstack CLI instead.
Created a new port:
+-----------------------+----------------------------------------------------------------------------------------+
| Field                 | Value                                                                                  |
+-----------------------+----------------------------------------------------------------------------------------+
| admin_state_up        | True                                                                                   |
| allowed_address_pairs |                                                                                        |
| binding:host_id       |                                                                                        |
| binding:profile       | {}                                                                                     |
| binding:vif_details   | {}                                                                                     |
| binding:vif_type      | unbound                                                                                |
| binding:vnic_type     | normal                                                                                 |
| created_at            | 2018-08-08T10:56:31Z                                                                   |
| description           |                                                                                        |
| device_id             |                                                                                        |
| device_owner          |                                                                                        |
| extra_dhcp_opts       |                                                                                        |
| fixed_ips             | {"subnet_id": "4a69e16b-befd-46e6-9a14-be6cf8f94b02", "ip_address": "192.168.239.214"} |
| id                    | 7fa254bd-b6d9-4125-a019-789e6583bfaf                                                   |
| mac_address           | fa:16:3e:fa:d9:5c                                                                      |
| name                  | p2                                                                                     |
| network_id            | 20b50db9-93eb-490d-9241-57d03500b1e0                                                   |
| port_security_enabled | True                                                                                   |
| project_id            | 206a373d117e4f9da3f2862d57425da7                                                       |
| revision_number       | 6                                                                                      |
| security_groups       | df31d4a6-3a37-4919-ac9d-a162c05fc1a3                                                   |
| status                | DOWN                                                                                   |
| tags                  |                                                                                        |
| tenant_id             | 206a373d117e4f9da3f2862d57425da7                                                       |
| updated_at            | 2018-08-08T10:56:32Z                                                                   |
+-----------------------+----------------------------------------------------------------------------------------+
[root@controller ~(keystone_admin)]# neutron port-create --name p3 provider
neutron CLI is deprecated and will be removed in the future. Use openstack CLI instead.
Created a new port:
+-----------------------+----------------------------------------------------------------------------------------+
| Field                 | Value                                                                                  |
+-----------------------+----------------------------------------------------------------------------------------+
| admin_state_up        | True                                                                                   |
| allowed_address_pairs |                                                                                        |
| binding:host_id       |                                                                                        |
| binding:profile       | {}                                                                                     |
| binding:vif_details   | {}                                                                                     |
| binding:vif_type      | unbound                                                                                |
| binding:vnic_type     | normal                                                                                 |
| created_at            | 2018-08-08T10:56:56Z                                                                   |
| description           |                                                                                        |
| device_id             |                                                                                        |
| device_owner          |                                                                                        |
| extra_dhcp_opts       |                                                                                        |
| fixed_ips             | {"subnet_id": "4a69e16b-befd-46e6-9a14-be6cf8f94b02", "ip_address": "192.168.239.216"} |
| id                    | 1cd1d522-d15e-4c2a-a62b-c967ac5bc8de                                                   |
| mac_address           | fa:16:3e:c1:17:03                                                                      |
| name                  | p3                                                                                     |
| network_id            | 20b50db9-93eb-490d-9241-57d03500b1e0                                                   |
| port_security_enabled | True                                                                                   |
| project_id            | 206a373d117e4f9da3f2862d57425da7                                                       |
| revision_number       | 6                                                                                      |
| security_groups       | df31d4a6-3a37-4919-ac9d-a162c05fc1a3                                                   |
| status                | DOWN                                                                                   |
| tags                  |                                                                                        |
| tenant_id             | 206a373d117e4f9da3f2862d57425da7                                                       |
| updated_at            | 2018-08-08T10:56:57Z                                                                   |
+-----------------------+----------------------------------------------------------------------------------------+
^[[A[root@controller ~(keystone_admin)]# neutron port-create --name p4 provider
neutron CLI is deprecated and will be removed in the future. Use openstack CLI instead.
Created a new port:
+-----------------------+----------------------------------------------------------------------------------------+
| Field                 | Value                                                                                  |
+-----------------------+----------------------------------------------------------------------------------------+
| admin_state_up        | True                                                                                   |
| allowed_address_pairs |                                                                                        |
| binding:host_id       |                                                                                        |
| binding:profile       | {}                                                                                     |
| binding:vif_details   | {}                                                                                     |
| binding:vif_type      | unbound                                                                                |
| binding:vnic_type     | normal                                                                                 |
| created_at            | 2018-08-08T10:57:34Z                                                                   |
| description           |                                                                                        |
| device_id             |                                                                                        |
| device_owner          |                                                                                        |
| extra_dhcp_opts       |                                                                                        |
| fixed_ips             | {"subnet_id": "4a69e16b-befd-46e6-9a14-be6cf8f94b02", "ip_address": "192.168.239.220"} |
| id                    | dcd0a2ec-c1fc-4a4b-ae5b-d76eaaa37764                                                   |
| mac_address           | fa:16:3e:ab:bf:95                                                                      |
| name                  | p4                                                                                     |
| network_id            | 20b50db9-93eb-490d-9241-57d03500b1e0                                                   |
| port_security_enabled | True                                                                                   |
| project_id            | 206a373d117e4f9da3f2862d57425da7                                                       |
| revision_number       | 6                                                                                      |
| security_groups       | df31d4a6-3a37-4919-ac9d-a162c05fc1a3                                                   |
| status                | DOWN                                                                                   |
| tags                  |                                                                                        |
| tenant_id             | 206a373d117e4f9da3f2862d57425da7                                                       |
| updated_at            | 2018-08-08T10:57:34Z                                                                   |
+-----------------------+----------------------------------------------------------------------------------------+
[root@controller ~(keystone_admin)]#
```


















