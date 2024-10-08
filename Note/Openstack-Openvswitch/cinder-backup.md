## 1.Cài đặt NFS server và client trên Centos 7

Hướng dẫn này giải thích cách cấu hình máy chủ NFS trên CentOS 7. Network File System (NFS)) là một filesystem protocol tệp phân tán phổ biến cho phép người dùng gắn kết các thư mục từ xa trên server của họ. NFS cho phép bạn tận dụng không gian lưu trữ ở một vị trí khác và cho phép bạn ghi vào cùng một không gian từ nhiều máy chủ hoặc máy khách một cách dễ dàng. Hoạt động khá tốt cho các thư mục mà người dùng cần truy cập thường xuyên.

### Mô hình 

<img src="/img/8.jpg">

| Name              | IP  |             
|-------------------|-----|
|Controller| 192.168.239.150|
|Compute1|192.168.239.151|
|Compute2|192.168.239.152|
|Cinder|192.168.239.153|
|NFS|192.168.239.154|


### Node Cinder

Cài đặt packages:

`yum install nfs-utils -y`

Tạo thư mục chia sẻ:

`mkdir /var/nfsshare`

Thay đổi quyền của thư mục:

``` sh
chmod -R 755 /var/nfsshare
chown nfsnobody:nfsnobody /var/nfsshare
```

Khởi động các dịch vụ:

``` sh
systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap
```

Cấu hình quyền truy cập:

`vi /etc/exports`

Thêm vào 2 dòng :

``` sh
/var/nfsshare    192.168.239.154(rw,sync,no_root_squash,no_all_squash)
/home            192.168.239.154(rw,sync,no_root_squash,no_all_squash)
```

Note: IP 192.168.239.154 là IP của NFS client nếu bạn muốn tất cả IP trong dải 192.168.239.0 đều truy cập được thì có thể thay đổi bằng dấu "*" thay vì điền IP vào.

Khởi động  NFS service:

`systemctl restart nfs-server`

Nếu chưa tắt firewalld thì sử dụng lệnh sau:

``` sh
firewall-cmd --permanent --zone=public --add-service=nfs
firewall-cmd --permanent --zone=public --add-service=mountd
firewall-cmd --permanent --zone=public --add-service=rpc-bind
firewall-cmd --reload
```

### NFS client

Cài đặt packages:

`yum install nfs-utils -y`

Tạo thư mục chia sẻ NFS:

``` sh
mkdir -p /mnt/nfs/home
mkdir -p /mnt/nfs/var/nfsshare
```

Chỉnh sửa :

`vi /etc/exports`

`/mnt/nfs/var/nfsshare 192.168.239.0/24(rw,no_root_squash)`

`mount -t nfs 192.168.239.153:/home /mnt/nfs/home/

`mount -t nfs 192.168.239.153:/var/nfsshare /mnt/nfs/var/nfsshare/`

Dùng lệnh `df -kh` để kiểm tra xem thư mục đã được mount chưa.

<img src="/img/9.jpg">

##  2.Hướng dẫn cấu hình cinder backup với backend là NFS

Có 2 loại backup là `full backup` và `incremental backup`

* **Full backup** : Là tạo ra 1 bản backup đầy đủ ban đầu cộng thêm thêm phần dữ liệu mới thay đổi, cứ như vậy sẽ gây ra hiện tượng kích thước bản backup sẽ ngày càng tăng, ưu điểm là bản backup update sau sẽ không bị phụ thuộc vào bản backup trước đó.

<img src="/img/14.png">

* **Incremental backup** : là bản sao lưu trong đó các bản sao liên tiếp của dữ liệu chỉ chứa phần đã thay đổi kể từ khi bản sao lưu trước đó được thực hiện. Khi cần full backup, quá trình khôi phục sẽ cần bản full backup cuối cùng cộng với tất cả các bản incremental backup cho đến thời điểm phục hồi, ưu điểm là giảm bớt kích thước của bản backup mỗi khi update, nhược điểm là phải phụ thuộc vào bản full backup.

<img src="/img/15.png">

### Cấu hình cinder backup

Chỉnh sửa file /etc/cinder/cinder.conf

`vi /etc/cinder/cinder.conf`

Thêm vào 2 dòng sau trong section [DEFAULT]

``` sh
backup_driver=cinder.backup.drivers.nfs
backup_share=HOST:EXPORT_PATH
```

Trong đó HOST:EXPORT_PATH là địa chỉ của đường dẫn đã được thêm vào file /etc/exports ở bên nfs server, lưu ý là tạo 1 lvm mới sau đó mount vào 1 mục mới bên nfs server sau đó thêm đường dẫn và phân quyền thư mục vào file /etc/export, bên cinder chỉ cần cấu hình backup_driver và backup_share sau đó restart lại dịch vụ cinder systemctl restart openstack-cinder-*

### Hướng dẫn thực hiện tạo backup cho cinder và restore lại backup

Xem danh sách volume

`cinder list`

<img src="/img/10.jpg">

Show trạng thái volume vltest:

<img src="/img/11.jpg">

Xem danh sách các backup:

`cinder backup-list`

Tạo backup cho volume `vltest`:

`cinder backup-create --display-name vltest_backup vltest`

<img src="/img/12.jpg">

Kiểm tra lại bằng lệnh `cinder backup-list`

Để restore lại volume về trạng thái lúc tạo backup, sử dụng lệnh sau:

`cinder backup-restore --volume-id <volume-id> <backup-id>`

Để xóa một backup

`cinder backup-delete <backup-id>`

Để tạo được backup, volume phải ở trạng thái available. Do vậy nếu volume đang được attach vào máy ảo, cần phải gỡ nó ra.

`openstack volume backup create [--incremental] [--force] VOLUME`

Attach volume

`openstack server add volume <tên VM> <tên volume> --device <tên thiết bị add cho vm>`

Ví dụ:

`openstack server add volume vm3 volume-empty2 --device /dev/sdb`

Detach volume

`openstack server remove volume <tên VM> <tên volume>`

Các lệnh khác :

`cinder backup-create <volumeid> --incr <full backup container>`

`cinder backup-create <volumeid> --snapshot`

`cinder backup-create <volumeid> --snapshot --incr <full backup container>`


Tài liệu tham khảo :

https://github.com/thaonguyenvan/meditech-thuctap/blob/master/ThaoNV/Tim%20hieu%20OpenStack/docs/cinder/cinder-backup.md






