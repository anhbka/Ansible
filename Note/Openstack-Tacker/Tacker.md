### 1. Tacker

Tacker là một dịch vụ về Network Function Virtualization (NFV), quản lý Virtual Network Functions (VNF) chạy trên nền tảng OpenStack. Ưu điểm là nhỏ gọn, dễ sử dụng, có thể cài đặt trên cùng 1 máy (All in one) đầy đủ với hệ thống OpenStack bằng DevStack. Nhược điểm là chưa đầy đủ chức năng và toàn vẹn nếu so sánh với ONAP, OpenBaton, OPNFV.


### 2. Kiến trúc của Tacker
Tacker bao gồm bốn thành phần chính: thư mục VNFD, thiết lập VNF, quản lý cấu hình VNF, và theo dõi VNF và sửa chữa tự động.

<img src="/img/1.png">

<img src="/img/3.jpg">

NFV MANO module chức năng chính:

•	NFV Orchestrator (NFV orchestration): được sử dụng để triển khai các dịch vụ mạng mới,chẳng hạn như: Firewall.

•	VNF Manager: Quản lý vòng đời của các trường hợp VNF.

•	Quản lý cơ sở hạ tầng ảo (VIM) Quản lý cơ sở hạ tầng ảo: Kiểm soát và quản lý cơ sở hạ tầng NFV như tính toán, lưu trữ và tài nguyên mạng.

•	VNFD Directory: Các nỗ lực tiêu chuẩn hóa về cách trình bày VNF (Bộ mô tả VNF) hiện đang tập trung vào TOSCA. TOSCA (Đặc điểm Topology và Orchestration for Cloud Applications) là một ủy ban kỹ thuật thuộc Hiệp hội OASIS, thúc đẩy sự phát triển, tích hợp và áp dụng các tiêu chuẩn mở cho xã hội thông tin toàn cầu. Dự thảo hồ sơ NFV của TOSCA đã được hoàn thành. Đặc tả này mô tả các thuộc tính của VNF (VNFD) và việc duy trì VNFD directory của Tacker.

Khi VNF được chỉ định sử dụng TOSCA NFV template, chúng có thể nhập vào Tacker VNF directory. Khi đã nhập, Tacker có thể khởi tạo VNF bằng cách biên dịch TOSCA template và dịch một phần của OpenStack Heat thông qua chuyển đổi. Tacker cũng tập trung vào cấu hình VNF và giám sát liên tục, và nếu cần thiết, sửa chữa tự động có thể được sử dụng trong suốt vòng đời được mô tả bởi ETSI MANO.

•	Thiết lập VNF: Với Heat template được mô tả ở trên, Tacker có thể thiết lập cơ sở hạ tầng máy tính bằng cách sử dụng OpenStack Nova. Nhiều tính năng của OpenStack Nova có thể được sử dụng trong quá trình thiết lập tính toán. Tài nguyên máy tính có thể được tối ưu hóa cho VNF bằng cách tận dụng một số tính năng được tạo ra bởi các thuộc tính cụ thể như SR-IOV Passthrough, NUMA, ghim CPU và phân bổ khu vực lớn.

•	VNF Configuration Management: Tacker sẽ chạy cấu hình đặc biệt cần thiết để điều khiển VNF thông qua trình điều khiển cấu hình. Quản lý cấu hình được thiết kế như một khung công tác có thể cắm được và các nhà cung cấp VNF khác nhau có thể viết các trình điều khiển cấu hình riêng cho các VNFs.
Một phương pháp khác là sử dụng bộ điều khiển SDN. Đã có rất nhiều cuộc thảo luận về cách tích hợp SDN và NFV. Về Tacker sử dụng trình cắm thêm bộ điều khiển SDN, cách thúc đẩy cấu hình của VNF đặc biệt bằng cách sử dụng giao diện hướng nam của bộ điều khiển SDN là một ví dụ tốt.

• 	Theo dõi và sửa chữa tự động của VNF: Trách nhiệm chính của Tacker là theo dõi tình trạng của VNF. Thông qua một loạt các thông số kỹ thuật được thiết kế để hướng dẫn thiết kế các dự án OpenStack khác, Tacker có thể sử dụng các trình điều khiển giám sát có thể tải như icmp-ping và http-ping bất cứ lúc nào. 
Họ cũng được lên kế hoạch để tích hợp với Ceilometer, và bây giờ các nhà cung cấp VNF đã có thể viết trình điều khiển giám sát của riêng họ với các đặc tính giám sát đặc biệt.


### 3. Luồng làm việc của Tacker

Tacker workflow

<img src="/img/2.jpg">

Bước đầu tiên: Tacker chọn mục dịch vụ tương ứng từ thư mục dịch vụ theo các yêu cầu BSS/OSS, chẳng hạn như vRouter.

Bước 2: Tacker đẩy VNFD cụ thể sang OpenStack Heat để tạo ra một VDU (Virtual Deployment Unit, tương ứng với thiết bị triển khai VM với các yêu cầu VNF).

Bước 3: Sử dụng heat để bắt đầu tạo ra một instance cụ thể, chẳng hạn như VNF FWaaS, VNF vRouter, vv bên dưới.

Bước 4: (ở giữa hình) Sử dụng Trình điều khiển Mgmt (trình điều khiển quản lý) để cấu hình các máy ảo, thường thông qua nhà cung cấp EMS (như được thấy trong "Người quản lý Y nhà cung cấp"), hoặc một phương tiện đơn giản như SSH.

Bước 5: Thực hiện SFC (Chuỗi chức năng dịch vụ chuỗi chức năng dịch vụ). Ví dụ ở đây sử dụng bộ điều khiển ODL và hợp tác với NSH của IETF (Network Service Header) để thực hiện chuỗi dịch vụ. NSH mang thông tin dịch vụ mạng dọc theo đường dẫn dịch vụ bằng cách mô tả tiêu đề của mặt phẳng dữ liệu. Nó được thiết kế để thực hiện một máy bay dịch vụ độc lập với truyền dẫn. Nó có thể hợp tác với VXLAN, MPLS, UDP và các giao thức đóng gói vận chuyển khác. . Máy bay dữ liệu OVS (VXLAN) và các máy bay điều khiển ODL có thể được hỗ trợ trong việc thực thi mã nguồn mở hiện tại của NSH. Các chi tiết không có ở đây, bạn có thể chú ý đến tiêu chuẩn IETF NSH và nội dung liên quan đến ODL, OVS.

Bước 6: Theo dõi tình trạng/tình trạng sẵn có của VNF. Vấn đề là tự động hồi phục phản hồi (tái tạo VNF để đảm bảo tính liên tục của doanh nghiệp).


### Cài đặt

Tạo databases:

``` sh
mysql -uroot -pWelcome123
CREATE DATABASE tacker;
grant all privileges on tacker.* to 'tacker'@'%' identified by 'Welcome123';
grant all privileges on tacker.* to 'tacker'@'localhost' identified by 'Welcome123';
flush privileges;
```
Tạo user tacker, gán role admin và user tacker và tạo endpoint:


``` sh
openstack user create --domain default --password Welcome123 tacker
openstack role add --project service --user tacker admin

openstack service create --name tacker \
           --description "Tacker Project" nfv-orchestration
           
openstack endpoint create --region RegionOne nfv-orchestration \
           public http://192.168.239.190:9890/
openstack endpoint create --region RegionOne nfv-orchestration \
           internal http://192.168.239.190:9890/
openstack endpoint create --region RegionOne nfv-orchestration \
           admin http://192.168.239.190:9890/
yum install -y openstack-tacker openstack-tacker-common \
            puppet-tacker python-tacker python2-tackerclient
```
Tải project Tacker:

`git clone https://github.com/openstack/tacker`

Cài đặt các packages yêu cầu:

``` sh
cd tacker
pip install -r requirements.txt
```

```
cd tacker
pip install tosca-parser
```
Cài đặt Tacker: `python setup.py install`

Tạo đường dẫn file log: `mkdir /var/log/tacker`


Chỉnh sửa file tacker.conf : `vi /etc/tacker/tacker.conf`

``` sh			

[DEFAULT]
auth_strategy = keystone
policy_file = /etc/tacker/policy.json
debug = True
use_syslog = False
bind_host = 192.168.239.190
bind_port = 9890
service_plugins = nfvo,vnfm
state_path = /var/lib/tacker

[nfvo]
vim_drivers = openstack

[keystone_authtoken]
memcached_servers = 192.168.239.190:11211
region_name = RegionOne
auth_type = password
project_domain_name = Default
user_domain_name = Default
username = tacker
project_name = service
password = Welcome123
auth_url = http://192.168.239.190:5000
www_authenticate_uri = http://192.168.239.190:5000

[agent]
root_helper = sudo /usr/bin/tacker-rootwrap /etc/tacker/rootwrap.conf

[database]
connection = mysql://tacker:Welcome123@192.168.239.190:3306/tacker


[tacker]
monitor_driver = ping,http_ping
```
Đồng bộ dữ liệu:

`tacker-db-manage --config-file /etc/tacker/tacker.conf upgrade head`

Cài đặt Tacker client:

`git clone https://github.com/openstack/python-tackerclient`

``` sh
cd python-tackerclient
sudo python setup.py install
```





Cấu hình dashboard:

`git clone https://github.com/openstack/tacker-horizon`

```
cd tacker-horizon
sudo python setup.py install
```

`cp tacker_horizon/enabled/*     /usr/share/openstack-dashboard/openstack_dashboard/enabled/`

Khởi động lại dịch vụ:

```
systemctl restart httpd
systemctl restart openstack-tacker-server.service
systemctl enable  openstack-tacker-server.service
```


Giao diện dashboard:

<img src="/img/5.png">

<img src="/img/6.png">
















Tham khảo :
https://wiki.openstack.org/wiki/Tacker
https://docs.openstack.org/tacker/queens/install/manual_installation.html






















































