### - *Một số ghi chú và template ansible trong quá trình tìm hiểu*

```
- hosts: servertest 
  remote_user: root
  tasks:
  ########## Cài đặt gói tin httpd và start .
  - name: Install HTTP
    yum: name=httpd state=latest
  - name: Start HTTPD after install
    service: name=httpd state=started
########### Deploy config
#backup
  - name: Backup config HTTP (backup from client)
    command: cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.backup1
#Deploy
  - name: Deploy config httpd
    template:
     src: "/etc/ansible/config/httpd.conf"
     dest: "/etc/httpd/conf/httpd.conf"
     owner: root
     group: root
     mode: 0644
########### Đẩy source về client
  - name: Deploy web file
    template:
     src: "/etc/ansible/config/index.html"
     dest: "/var/www/html/index.html"

########### Khởi động lại apache để áp dụng config
  - name: Start HTTPD after install
    service: name=httpd state=restarted
```    
- Mysql 

```
---
- hosts: all
  sudo: yes

  tasks:
    - name: Install Apache.
      apt:
        name: "{{ item }}"
        state: present
      with_items:
        - apache2
        - mysql-server
        - php
        - php-mysql
    - name: Restart Apache and Mysql
      service:
        name: "{{item}}"
        state:  running
      with_items:
          - apache2
          - mysql
```          

### Handlers

```
---
- hosts: all
  sudo: yes



  tasks:
    - name: Install Apache.
      apt:
        name: "{{ item }}"
        state: present
      with_items:
        - apache2
        - mysql-server
        - php
        - php-mysql

    - name: deploy html file
      template:
        src: /tmp/index.html
        dest: /var/www/html/index.html
      notify: restart web

  handlers:
    - name: restart web
      service:
        name: "{{ item }}"
        state:  running
      with_items:
          - apache2
          - mysql
```          
### Fact and when

```
---
- hosts: all
  sudo: yes



  tasks:
    - name: Define Red Hat.
      set_fact:
         package_name: "httpd"
      when:
         ansible_os_family == "Red Hat"

    - name: Define Debian.
      set_fact:
         package_name: "apache2"
      when:
         ansible_os_family == "Debian"

    - name: Stop apache
      service:
        name: "{{ package_name }}"
        state: stopped
  ```      
  ### Variables
  
  ```
  ---
- hosts: all
  sudo: yes


  vars:
     - domain_name: "abc.com"
     - index_file: "index.html"
     - config_file: "abc.conf"


  tasks:
    - name: Install Apache.
      apt:
        name: "{{ item }}"
        state: present
      with_items:
        - apache2
        - mysql-server
        - php
        - php-mysql

    - name: deploy html file
      template:
        src: /tmp/{{ index_file }}
        dest: /var/www/html/index.html
      notify: restart web

  handlers:
    - name: restart web
      service:
        name: "{{ item }}"
        state:  running
      with_items:
          - apache2
          - mysql  
``` 
    
### Register

Ansible còn cung cấp một thuộc tính khá mạnh mẽ là register. Register giúp nhận kết quả trả về từ một câu lệnh. Sau đó ta có thể dùng kết quá trả về đó cho những câu lệnh chạy sau đó.

```
#Sample ansible playbook.yml
-
  name: Check status of service and email if its down
  hosts: localhost
  tasks:
    - command: service httpd status
      register: command_output

    - mail:
        to: Admins 
        subject: Service Alert
        body: "Service is down"
      when: command_output.stdout.find("down") != -1    
```    
Nhờ vào thuộc tính register, kết quả trả về sẽ được chứa vào biến `command_output`. Từ đó ta sử dụng tiếp các thuộc tính của biến command_output là stdout.find để tìm chữ "down" có xuất hiện trong nội dung trả về không. Nếu không tìm thấy thì kết quả sẽ là -1.    

### LOOPS

Bạn còn nhớ module yum không. Module yum trong ansible playbook giúp ta cài đặt hay xoá một gói service nào đó. Trong ví dụ ở phần playbook, chúng ta chỉ có cài một gói service. Nhưng nếu server yêu cầu cài thêm nhiều gói service khác như mysql, php thì sao nhĩ. Như bình thường chúng ta sẽ viết như sau:

```
# Simple Ansible Playbook1.yml
-
  name: Install packages
  hosts: localhost
  tasks:
    - name: Install httpd service
      yum:
        name: httpd
    - name: Install mysql service
      yum:
        name: mysql
    - name: Install php service
      yum:
        name: php    
```    
Ở đây mới ví dụ 3 service cần cài mà phải viết lập lại các thuộc tính name, module yum đến 3 lần. Nếu server cần cài lên đến 100 gói service thì việc ngồi copy/paste cũng trở nên vấn đề đấy. Thay vào đó, chúng ta sẽ sử dụng chức năng loops mà ansible đã cung cấp để để viết.

```
#Simple Ansible Playbook1.yml
-
  name: Install packages
  hosts: localhost
  tasks:
    - name: Install all service
      yum: name="{{ item }}" state=present
      with_items:
        - httpd
        - mysql
        - php
```

`with_items` là một lệnh lặp, thực thi cùng một tác vụ nhiều lần. Mỗi lần chạy, nó lưu giá trị của từng thành phần trong biến item.    
    
 ```
 - name: copy a directory
  copy:
    src: ./roles/chrony/files/chrony.conf
    dest: /etc
    mode: 0644
    backup: yes

- name: chrony
  service: name=chronyd enabled=yes state=restarted
  ignore_errors: True

- name: Check chronyc sources
  shell: chronyc sources
  register: return_from_shell
  changed_when: no

- name: show previous shell stdout
  debug:
    msg: "{{ return_from_shell.stdout_lines }}"
```  
    
### How to overwrite file in Ansible

```
- name: Copy file config
  copy:
    src: /etc/ansible/roles/chrony/files/chrony.conf
    dest: /etc/chrony.conf
    owner: root
    group: root
    mode: 0644
    backup: yes
    force: yes
```

### How to config line file in Ansible

```
# NOTE: Before 2.3, option 'dest', 'destfile' or 'name' was used instead of 'path'
- name: Ensure SELinux is set to enforcing mode
  lineinfile:
    path: /etc/selinux/config
    regexp: '^SELINUX='
    line: SELINUX=enforcing

- name: Make sure group wheel is not in the sudoers configuration
  lineinfile:
    path: /etc/sudoers
    state: absent
    regexp: '^%wheel'

- name: Replace a localhost entry with our own
  lineinfile:
    path: /etc/hosts
    regexp: '^127\.0\.0\.1'
    line: 127.0.0.1 localhost
    owner: root
    group: root
    mode: '0644'

- name: Ensure the default Apache port is 8080
  lineinfile:
    path: /etc/httpd/conf/httpd.conf
    regexp: '^Listen '
    insertafter: '^#Listen '
    line: Listen 8080

- name: Ensure we have our own comment added to /etc/services
  lineinfile:
    path: /etc/services
    regexp: '^# port for http'
    insertbefore: '^www.*80/tcp'
    line: '# port for http by default'

- name: Add a line to a file if the file does not exist, without passing regexp
  lineinfile:
    path: /tmp/testfile
    line: 192.168.1.99 foo.lab.net foo
    create: yes

# NOTE: Yaml requires escaping backslashes in double quotes but not in single quotes
- name: Ensure the JBoss memory settings are exactly as needed
  lineinfile:
    path: /opt/jboss-as/bin/standalone.conf
    regexp: '^(.*)Xms(\\d+)m(.*)$'
    line: '\1Xms${xms}m\3'
    backrefs: yes

# NOTE: Fully quoted because of the ': ' on the line. See the Gotchas in the YAML docs.
- name: Validate the sudoers file before saving
  lineinfile:
    path: /etc/sudoers
    state: present
    regexp: '^%ADMIN ALL='
    line: '%ADMIN ALL=(ALL) NOPASSWD: ALL'
    validate: /usr/sbin/visudo -cf %s
```    
    
    
    
