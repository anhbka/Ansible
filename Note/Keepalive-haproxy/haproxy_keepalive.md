### Hướng dẫn cài đặt và cấu hình HAProxy + keepalived trên CentOS 7

<img src="/img/1.jpg">

HĐH: CentOS 7.3 - 17.08

Lưu ý: Nếu bạn sử dụng hđh CentOS 7.3-1611 thì sẽ phải update trước khi cài keepalived

### 1.Cấu hình keepalived

* Cài đặt packages:

`yum install keepalived -y`

Để cho phép HAProxy ràng buộc vào các địa chỉ IP được chia sẻ, chúng ta thêm dòng sau vào `/etc/sysctl.conf` :

`echo "net.ipv4.ip_nonlocal_bind=1" >> /etc/sysctl.conf`

Kiểm tra:

`sysctl -p`

* Cấu hình keepalived

### Trên server haproxy1

``` sh

vi /etc/keepalived/keepalived.conf
! Configuration File for keepalived
vrrp_script chk_haproxy {           
        script "killall -0 haproxy"     
        interval 2                      
        weight 2                        
}

vrrp_instance VI_1 {
        interface eth0
        state MASTER
        virtual_router_id 51
        priority 101                    
        virtual_ipaddress {
            192.168.30.50       
        }
        track_script {
            chk_haproxy
        }
}
```

### Trên server haproxy2

``` sh
! Configuration File for keepalived
vrrp_script chk_haproxy {       
        script "killall -0 haproxy"     
        interval 2                      
        weight 2                        
}

vrrp_instance VI_1 {
        interface eth0
        state BACKUP
        virtual_router_id 51
        priority 100                    
        virtual_ipaddress {
            192.168.30.50             
        }
        track_script {
            chk_haproxy
        }
}
```

``` sh
vrrp_script chk_haproxy {
script "killall -0 haproxy"           #check pid của dịch vụ haproxy có tồn tại hay không
interval 2                                     #thời gian lặp lại đoạn script đơn vị là second
weight 2                                      #trọng số khấu trừ priority 2
}
track_script {
  chk_haproxy                             #khai báo tên đoạn script 
  }
```

Note: Thử chạy `killall -0 haproxy` nếu server báo `command not found`, bạn cần cài gói `psmisc`.

`yum install psmisc -y`

* Sau khi cấu hình xong, start dịch vụ và cho phép khởi động cùng hệ thống

``` sh
systemctl start keepalived
systemctl enable keepalived
```

### Cài đặt webserver

`yum install httpd -y`

Trên webserver1

``` sh
vi /var/www/html/index.html
<p1> HAProxy1 </p1>
```
Làm tương tự trên webserver2

Khởi động lại httpd:

`systemctl restart httpd`


### 2.Cấu hình haproxy

Trên server haproxy1

* Tải và cài đặt package

`yum install haproxy -y`

* Cấu hình haproxy

`vi /etc/haproxy/haproxy.cfg`

``` sh
global
        daemon
        maxconn 256

defaults
        mode http
        timeout connect 5000ms
        timeout client 50000ms
        timeout server 50000ms
        stats enable
        stats uri /monitor
        stats auth root:123456

listen httpd
    bind 192.168.30.50:80
    balance  roundrobin
    mode  http
    server web1 192.168.30.40:80 check
    server web2 192.168.30.41:80 check
```

IP: 192.168.30.50 là IP VIP, 192.168.30.40/192.168.30.41 là IP của 2 webserver

Khởi động lại haproxy:

``` sh
systemctl start haproxy
systemctl enable haproxy
```

Cấu hình port cho httpd
`vi /etc/httpd/conf/httpd.conf`

<img src="/img/6.jpg">

Lưu ý làm trên tất cả các webserver.

Khởi động lại httpd:

`systemctl restart httpd`

Mở port 80 để người dùng có thể truy cập

``` sh
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
```
Kiểm tra xem node MASTER đã nhận được IP VIP chưa:

<img src="/img/4.jpg">



Truy cập vào web thông qua VIP IP:

<img src="/img/3.jpg">

<img src="/img/2.jpg">


Thử stop haproxy kiểm tra xem IP VIP có tự động chuyển sang node BACKUP không.

<img src="/img/5.jpg">






























