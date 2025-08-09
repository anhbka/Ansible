### Roles

*Roles là hữu ích khi chúng ta muốn cấu trúc chức năng nhiều phần, các Task liên quan và đóng gói các dữ liệu cần thiết để thực hiện những Task đấy. Ví dụ, cài đặt Nginx có thể liên quan đến việc thêm một Repository package, cài đặt package và thiết lập cấu hình. Chúng ta đã nhìn thấy cài đặt qua một Playbook, nhưng khi chúng ta bắt đầu cài đặt cấu hình của mình, Playbook có xu hướng bận hơn một chút.*

Hơn nữa trong cấu hình thực tế thường yêu cầu thêm dữ liệu như các biến, các File và các Template động…Những công cụ này có thể được sử dụng với Playbook nhưng chúng ta có thể làm tốt hơn ngay lập tức bằng cách tổ chức các Task và dữ liệu liên quan thành một cấu trúc mạch lạc như một Role.

Các Roles có một cấu trúc dữ liệu như sau:

```
roles
  rolename
   - files
   - handlers
   - meta
   - templates
   - tasks
   - vars
```

Với mỗi thư mục, Ansible sẽ tìm kiếm và đọc tất cả các file YAML được gọi là main.yml tự động.

Chúng ta sẽ chia nhỏ file nginx.yml và đặt mỗi thành phần vào trong thư mục phù hợp để tạo một công cụ cấu hình trước rõ ràng hơn và hoàn hảo hơn.   

### Creat role

Chúng ta có thể sử dụng câu lệnh ansible-galaxy để tạo một Role mới. Công cụ này có thể được sử dụng để lưu các Role vào đăng ký puplic của Ansible. Tuy nhiên mình thông thường chỉ sử dụng nó để khởi tạo một role cục bộ.


```
cd /etc/ansible/roles/
ansible-galaxy init nginx
- nginx was created successfully
defaults  files  handlers  meta  README.md  tasks  templates  tests  vars
```

### Files

Đầu tiên trong thư mục files, chúng ta có thể thêm các file mà chúng ta sẽ muốn copy vào trong Server.

### Handler

Bên trong thư mục handlers, chúng ta có thể đặt tất cả Handler của chúng ta đã từng nằm trong Playbook nginx.yml

Bên trong `hanlder/main.yml`:

```
---
- name: Start Nginx
  service:
    name: nginx
    state: started
 
- name: Reload Nginx
  service:
    name: nginx
    state: reloaded
```	
Khi chúng được đặt đúng vai trò, chúng ta có thể tham khảo chúng từ cấu hình yaml khác dễ dàng.

### Meta

file main.yml bên trong thư mục meta chứa dữ liệu meta của Role, bao gồm các phụ thuộc.

Nếu một Role dựa trên Role khác, chúng ta có thể định nghĩa nó ở đây. Ví dụ chúng ta có một Nginx Role dựa trên ssl Role dùng để cài đặt chứng thực của SSL.

```
---
dependencies:
  - { role: ssl }
```  

Nếu gọi nginx Role, nó sẽ thử chạy SSL role trước.

Ngoài ra chúng ta có thể bỏ qua file này, hoặc định nghĩa Role ko có phụ thuộc.

```
---
dependencies: []
```

### Template

Các Template file có thể chứa các biến template, dựa trên engine Jinja2 template của Python. Các file ở đây nên kết thúc bằng .j2, nhưng có thể có tên khác. Giống files, chúng ta sẽ không tìm thấy file main.yml bên trong thư mục templates.

Đây là một ví dụ cấu hình Nginx Server. Chú ý rằng nó sử dụng một số biến mà chúng ta sẽ định nghĩa ngay sau đây trong file vars/main.yml

File cấu hình Nginx này trong ví dụ của chúng ta được đặt tại `templates/serversforansible.com.conf.j2`

```
server {
    # Bắt buộc sử dụng HTTPS
    listen 80 default_server;
    server_name {{ domain }};
    return 301 https://$server_name$request_uri;
}
 
server {
    listen 443 ssl default_server;
 
    root /var/www/{{ domain }}/public;
    index index.html index.htm index.php;
 
    access_log /var/log/nginx/{{ domain }}.log;
    error_log  /var/log/nginx/{{ domain }}-error.log error;
 
    server_name {{ domain }};
 
    charset utf-8;
 
    include h5bp/basic.conf;
 
    ssl_certificate           {{ ssl_crt }};
    ssl_certificate_key       {{ ssl_key }};
    include h5bp/directive-only/ssl.conf;
 
    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }
 
    location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt  { log_not_found off; access_log off; }
 
    location ~ \.php$ {
        include snippets/fastcgi.conf;
        fastcgi_pass unix:/var/run/php7.1-fpm.sock;
    }
}
```
Đây là cấu hình tương đối chuẩn của Nginx cho ứng dụng PHP. Có 3 biến được sử dụng ở đây:

* domain
* ssl_crt
* ssl_key

3 biến này sẽ được định nghĩa trong phần biến.

### Variables

Trước khi chúng ta tích hợp tất cả với nhau sử dụng các Task, hãy cùng xem tiếp phần variables. Thư mục var chứa một file main.yml chứa danh sách các biến mà chúng ta sẽ sử dụng. Nó là một nơi hữu ích cho chúng ta thay đổi cài đặt của toàn bộ cấu hình

Hãy cùng xem cấu hình file main.yml sau đây

```
---
domain: serversforansible.com
ssl_key: /etc/ssl/sfh/sfh.key
ssl_crt: /etc/ssl/sfh/sfh.crt
```

Có 3 biến chúng ta có thể dùng bất cứ chỗ nào trong Role này. Chúng ta đã được nhìn thấy những biến này được sử dụng ở trong template bên trên, nhưng chúng ta cũng sẽ được nhìn thấy các biến này trong các Task được định nghĩa.

### Task

Cuối cùng hãy cùng xem tất cả những cái này sẽ được tập hợp lại với nhau thành các Task

File chính sẽ được chạy khi chúng ta sử dụng một Role là file tasks/main.yml. Nào hãy cùng xem cấu hình bên dưới đây

```
---
- name: Add Nginx Repository
  apt_repository:
    repo: ppa:nginx/stable
    state: present
 
- name: Install Nginx
  apt:
    pkg: nginx
    state: installed
    update_cache: true
  notify:
    - Start Nginx
 
- name: Add H5BP Config
  copy:
    src: h5bp
    dest: /etc/nginx
    owner: root
    group: root
 
- name: Disable Default Site Configuration
  file:
    dest: /etc/nginx/sites-enabled/default
    state: absent
 
# `dest` in quotes as a variable is used!
- name: Add SFH Site Config
  register: sfhconfig
  template:
    src: serversforansible.com.j2
    dest: '/etc/nginx/sites-available/{{ domain }}.conf' 
    owner: root
    group: root
 
# `src`/`dest` in quotes as a variable is used!
- name: Enable SFH Site Config
  file:
    src: '/etc/nginx/sites-available/{{ domain }}.conf'
    dest: '/etc/nginx/sites-enabled/{{ domain }}.conf'
    state: link
 
# `dest` in quotes as a variable is used!
- name: Create Web root
  file:
    dest: '/var/www/{{ domain }}/public'
    mode: 775
    state: directory
    owner: www-data
    group: www-data
  notify:
    - Reload Nginx
 
# `dest` in quotes as a variable is used!
- name: Web Root Permissions
  file:
   dest: '/var/www/{{ domain }}'
   mode: 775
   state: directory
   owner: www-data
   group: www-data
   recurse: yes
  notify:
    - Reload Nginx
```

Đây là một chuỗi các Task dài hơn, giúp cho việc cài đặt Nginx hoàn chỉnh hơn. Các Task theo thứ tự xuất hiện, thực hiện như sau:

* Thêm nginx/stable repository

* Cài đặt và start Nginx

* Thêm các file cấu hình 

* Vô hiệu hoá Nginx mặc định bằng cách loại bỏ liên kết đến file default từ thư mục `sites-enabled`

* Copy virtual host template  `serversforansible.com.conf.j2` trong cấu hình Nginx, tạo ra các template như đã làm

* Cho phép cấu hình Nginx bằng cách liên kết nó đến thư mục sites-enabled

* Tạo thư mục web root

* Thay đổi quyền cho thư mục gốc của dự án

Có một vài module mới, bao gồm module Copy, Template và File. Bằng việc cài đặt các tham số cho mỗi Module, chúng ta có thể làm một vài điều thú vị như là đảm bảo các file là absent (xoá nếu chúng tồn tại) thông qua state: absent, hoặc tạo một file như một liên kết thông qua `state: link`.  Bạn nên đọc qua tài liệu cho mỗi module để biết những điều hữu ích và thú vị mà bạn có thể thực hiện với chúng.	

Chạy Role

Để chạy một hoặc nhiều Role đối với một Server, chúng ta sẽ sử dụng lại Playbook khác. Các Playbook nên ở trong cùng một thư mục như thư mục roles, nơi chúng ta cần cd vào bên trong khi chạy câu lệnh ansible-playbook

File `~/ansible-example/server.yml`, được đặt trong thư mục giống như thư mục roles:

```
---
# Chạy trên local
- hosts: local
  connection: local
  roles:
    - nginx
```	

Nên thay vì định nghĩa tất cả các biến và các Task trong file Playbook này, chúng ta đơn giản chỉ cần định nghĩa các Role cần chạy. Các Role sẽ có nhiệm vụ chi tiết cho từng nhiệm vụ

Tiếp theo chúng ta có thể chạy các Role:

`ansible-playbook -i ./hosts server.yml`

### Facts

Chú ý rằng dòng đầu tiên khi chạy playbook luôn luôn là “gathering facts”.

Trước khi chạy bất kỳ Task nào, Ansible sẽ thu thập thông tin về hệ thống nó đang cung cấp. Cái này được gọi là Facts, và nó bao gồm một loạt các thông tin về hệ thống như là số lõi CPU, mạng ipv4 và ipv6 có thể dùng, lượng ổ cứng đang dùng, phân vùng Linux… Sau đó sử dụng các biến để gọi các thông tin từ Facts ra. Nếu chúng ta không cần thu thập thông tin của host thì có thể thiết lập set grathering_facts: no, nó giúp cho việc chạy Playbook nhanh hơn.

Facts thường rất hữu dụng trong cấu hình các Task và Template. Ví dụ Nginx thường được thiết lập để sử dụng với nhiều tiến trình vì CPU có đa lõi. Để thực hiện điều này bạn có thể thiết lập trong Template của Nginx ví dụ chúng ta có thể cấu hình file nginx.conf.j2 như sau:

```
user www-data;
worker_processes {{ ansible_processor_cores }};
pid /var/run/nginx.pid;
```

Hoặc nếu Server của bạn có nhiều CPU, bạn có thể sử dụng:

```
user www-data;
worker_processes {{ ansible_processor_cores * ansible_processor_count }};
pid /var/run/nginx.pid;
```

Tất cả các Fact của Ansible đều bắt đầu với ansible_ và sẵn sàng sử dụng ở bất kỳ chỗ nào mà biến cần sử dụng: các file Variable, Task, và Template

Hãy thử chạy theo cấu hình trên trên máy local, để xem Fact hoạt động trong thực tế như thế nào

`ansible -m setup --connection=local localhost`

`ansible -i ./hosts remote -m setup`

### Vault


Chúng ta thường lưu những thông tin nhạy cảm ở trong file Template, File hoặc Variable trong Ansible, đáng tiếc là chúng ta không thể tránh khỏi việc này. Ansible có một giải pháp cho vấn đề này là sử dụng Vault

Vault cho phép bạn mã hoá bất kỳ file YAML nào, mà chúng ta hay sử dụng dưới các file lưu thông tin biến. Vault không mã hoá các file File và Template, chỉ mã hoá các file YAML.

Khi tạo một file được mã hoá, bạn sẽ được yêu cầu nhập mật khẩu để giúp bạn có thể chỉnh sửa phải sau đấy và khi gọi Role hoặc Playbook

Lưu mật khẩu của bạn ở nơi nào đó an toàn

Ví dụ chúng ta có thể tạo một file Variable mới

```
ansible-vault create vars/main.yml
Vault Password:
```

Sau khi nhập mật khẩu mã hoá, file sẽ được mở trên Editor mặc địch của bạn thường là Vim hoặc Nano

Bạn có thể gõ lệnh để xem hướng dẫn về Ansible vault như sau

`ansible-vault -h`

create – Tạo một file mới và mã hoá nó
decrypt – Tạo một file text từ một file mã hoá
edit – Chỉnh sửa file mã hoá
encrypt – Mã hoá một file text
rekey – Đổi mật khẩu cho file mã hoá


Nếu bạn muốn mã hoá một file đang tồn tại thì dùng câu lệnh ansible-vault encrypt /path/to/file.yml

Ví dụ: Users

Giả sử chúng ta có Role thứ 2 tên là “users”


```
cd ~/ansible-example/roles
ansible-galaxy init users
```

Chúng ta sẽ sử dụng Vault khi tạo một user mới và thiết lập mật khẩu cho chúng. Trong user Role, chúng ta sẽ tạo một file biến để lưu mật khẩu của user  và một public key để thêm vào file authorized_keys của user (giúp truy cập SSH).

Đây là ví dụ về file chứa biến mà chúng ta sẽ tạo và mã hoá bằng Vault, khi chỉnh sửa nó tất nhiên là nó chưa bị mã hoá

Đây là file ~/ansible-example/roles/users/variables/main.yml

```
admin_password: $6$lpQ1DqjZQ25gq9YW$mHZAmGhFpPVVv0JCYUFaDovu8u5EqvQi.Ih
deploy_password: $6$edOqVumZrYW9$d5zj1Ok/G80DrnckixhkQDpXl0fACDfNx2EHnC
common_public_key: ssh-rsa ALongSSHPublicKeyHere
```
Chú ý rằng mật khẩu của người dùng cũng được hash. Bạn có thể đọc trong tài liệu của Ansible để biết cách làm thể nào để sinh ra mật khẩu mã hoá. Bạn có thể chạy lệnh sau

```
sudo apt-get install -y whois
mkpasswd --method=SHA-512
```

Sau khi bạn đã cấu hình mật khẩu người dùng và public key trong file biến, chúng ta có thể mã hoá file và sau đó tạo Task sử dụng các biến được mã hoá.

```
ansible-vault encrypt roles/users/variables/main.yml
> INPUT PASSWORD
```

Sau đó chúng ta chỉnh sửa file Task được sử dụng để thêm user và sử dụng các biến mã hoá:

Đây là file chúng ta sẽ cập nhập ~/ansible-example/roles/users/tasks/main.yml


```
---
- name: Create Admin User
  user:
    name: admin
    password: '{{ admin_password }}'
    groups: sudo
    append: yes
    shell: /bin/bash
 
- name: Add Admin Authorized Key
  authorized_key:
    user: admin
    key: '{{ common_public_key }}'
    state: present
 
- name: Create Deploy User
  user:
    name: deploy
    password: '{{ deploy_password }}'
    groups: www-data
    append: yes
    shell: /bin/bash
 
- name: Add Deployer Authorized Key
  authorized_key:
    user: deploy
    key: '{{ common_public_key }}'
    state: present
```	

Những Task này sử dụng trong user module để tạo user mới và truyền mật khẩu user được lưu trong file biến mã hoá

Nó cũng sử dụng authorized_key module để thêm SSH public key để người dùng có thể truy cập đến Server bằng private key trên máy họ

Các biến mã hoá được sử dụng bình thường trong các file Task. Tuy nhiên mục đích để chạy Role này, chúng ta sẽ nói với Ansible để yêu cầu người dùng nhập mật khẩu Vault giúp nó có thể giải mã được các file này.

Nào hày chỉnh sửa file Playbook server.yml để gọi user Role

```
---
# Local connection here
- hosts: local
  connection: local
  sudo: yes
  roles:
    - nginx
    - user
```	

Để chạy Playbook này chúng ta sẽ yêu cầu Ansible hỏi Vault mật khẩu, khi chúng ta chạy đến Role chứa file mã hoá:

`ansible-playbook --ask-vault-pass -i ./hosts server.yml`

