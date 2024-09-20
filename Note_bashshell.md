```
ps -ef | awk '{ print $8 }' | grep mysqld | wc -l
netstat -tulpn | awk '{ print $7 }' | grep mysqld | wc -l


ps -ef: nó sẽ xuất ra màn hình tất cả các process đang chạy cùng thông tin của process đó.
awk '{ print $8 }' : lấy ra cột thứ 8 trong kết quả lênh ps -ef
grep mysqld: lấy ra những dòng có chữ mysqld
wc -l: đếm số dòng có chữ mysqld

```
```
#!/bin/bash
service=mysqld

if (( $(ps -ef | awk '{ print $8 }' | grep mysqld | wc -l) > 0 ))
 then
 echo "$service OK"
 else
 /etc/init.d/$service start
 fi
```

*/5 * * * * sh /var/www/script/

```
 name: install the latest version of Apache
  yum:
    name: httpd
    state: latest

- name: remove the Apache package
  yum:
    name: httpd
    state: absent

- name: install the latest version of Apache from the testing repo
  yum:
    name: httpd
    enablerepo: testing
    state: present

- name: install one specific version of Apache
  yum:
    name: httpd-2.2.29-1.4.amzn1
    state: present

- name: upgrade all packages
  yum:
    name: '*'
    state: latest

- name: upgrade all packages, excluding kernel & foo related packages
  yum:
    name: '*'
    state: latest
    exclude: kernel*,foo*

- name: install the nginx rpm from a remote repo
  yum:
    name: http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
    state: present

- name: install nginx rpm from a local file
  yum:
    name: /usr/local/src/nginx-release-centos-6-0.el6.ngx.noarch.rpm
    state: present

- name: install the 'Development tools' package group
  yum:
    name: "@Development tools"
    state: present

- name: install the 'Gnome desktop' environment group
  yum:
    name: "@^gnome-desktop-environment"
    state: present

- name: List ansible packages and register result to print with debug later.
  yum:
    list: ansible
  register: result
```  

```
My filters Extension ublockorgin
##.videowall-endscreen
youtube.com##.html5-endscreen-content
youtube.com##.html5-endscreen
youtube.com##.ytp-ce-element
```