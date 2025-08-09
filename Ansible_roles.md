### Role là gì?

Roles là hữu ích khi chúng ta muốn cấu trúc chức năng nhiều phần, các Task liên quan và đóng gói các dữ liệu cần thiết để thực hiện những Task đấy. Ví dụ, cài đặt Nginx có thể liên quan đến việc thêm một Repository package, cài đặt package và thiết lập cấu hình. Chúng ta đã nhìn thấy cài đặt qua một Playbook, nhưng khi chúng ta bắt đầu cài đặt cấu hình của mình, Playbook có xu hướng bận hơn một chút.

Hơn nữa trong cấu hình thực tế thường yêu cầu thêm dữ liệu như các biến, các File và các Template động…Những công cụ này có thể được sử dụng với Playbook nhưng chúng ta có thể làm tốt hơn ngay lập tức bằng cách tổ chức các Task và dữ liệu liên quan thành một cấu trúc mạch lạc như một Role.

Trong Ansible, Role là một cơ chế để tách 1 playbook ra thành nhiều file. Việc này nhằm đơn giản hoá việc viết các playbook phức tạp và có thể tái sử dụng lại nhiều lần 

Role không phải là playbook. Role là một bộ khung (framework) để chia nhỏ playbook thành nhiều files khác nhau. Mỗi role là một thành phần độc lập, bao gồm nhiều variables, tasks, files, templates, và modules bên dưới.

Việc tổ chức playbook theo role cũng giúp người dùng dễ chia sẻ và tái sử dụng lại playbook với người khác. Đặc biệt trong môi trường doanh nghiệp khi có từ vài trăm tới vài ngàn playbook thì Role chính là cách quản lý các playbook này.


* Ví dụ về Role

– Trong folder ./roles/prometheus  

<img src="/img/1.png">

Một role sẽ có 7 folder với các chức năng khác nhau gồm: vars, templates, handlers, files, meta, tasks và defaults. Mỗi một thư mục cần phải chứa 1 file main.yml. Trong đó thì tasks thường là folder quan trọng nhất, thường dùng để chứa những playbook

Trong đó:

<ul>
<li><b>tasks</b> – chứa danh sách các task chính được thực thi trong role này.</li>
<li><b>handlers</b> – chứa các handler, có thể được dùng trong role này hoặc các role khác.</li>
<li><b>defaults</b> – chứa các biến được dùng default cho role này</li>
<li><b>vars</b> – chứa thông tin các biến dùng trong role, biến trong vars sẽ override biến trong default</li>
<li><b>files</b> – chứa các file cần dùng để deploy trong role này, cụ thể như file binary, file cài đặt…</li>
<li><b>templates</b> – chứa các file template theo jinja format đuôi <strong>*.j2</strong> (có thể là file config, file systemd…).</li>
<li><b>meta</b> – định nghĩa 1 số metadata của role này, như là dependencies</li>
</ul>

Một role phải chứa ít nhất 1 trong 7 thư mục này để Ansible có thể hiểu được đó là 1 role. Nếu có những thư mục nào không cần dùng thì ta có thể bỏ ra. Thường thì mình hay dùng nhất là các thư mục tasks, vars, templates, files. Ngoài ra còn có thêm tests nếu bạn muốn viết unit test cho playbook nhưng không bắt buộc và không nằm trong phạm vi bài viết này.


```
alertmanager
├── README.md
├── defaults
│   └── main.yml
├── files
│   ├── alertmanager.service
│   └── notifications.tmpl
├── handlers
│   └── main.yml
├── tasks
│   └── main.yml
├── templates
│   └── alertmanager.yml.j2
└── vars
    └── main.yml
```

Cây thư mục của 1 role

Để dùng 1 role thì ta có thể liệt kê role cần dùng trong 1 play, cụ thể như sau:

```
---
- name: Setup Monitoring Services
  hosts: prometheus_group
  become: yes
  become_user: root
 
  roles:
      - prometheus
      - alertmanager
      - pushgateway
```

Trong ví dụ trên, ta sẽ setup 3 role lần lượt là prometheus, alertmanager và pushgateway cho host prometheus_group

Để dùng role thì ta cần liệt kê role đó trong 1 play. Các lệnh như copy, script, template trong 1 role có thể tham chiếu tới roles/x/{files,templates,tasks}/ trong role đó mà không cần phải ghi rõ đường dẫn tuyệt đối ra

Một role thường thì cần phải:


<ul>
<li>Chạy được trong check mode <strong>ansible-playbook –check targets.yml</strong></li>
<li>Không chạy lại lần 2 nếu playbook không thay đổi (Idempotent!!)</li>
<li>Nên dùng lệnh <strong>assert</strong> trong playbook để kiểm tra các điều kiện khi chạy playbook</li>
<li>Các file config trong folder template nên dùng lệnh <strong>validate</strong> trước khi copy file</li>
<li>Chỉ nên trigger các handler khi file config thay đổi</li>
<li>Nên có sẵn nhiều biến trong defaults nhất có thể</li>
<li>Dùng một tool <strong>version control</strong> (git, svm…) để theo dõi sự thay đổi của role</li>
</ul>

Hướng dẫn viết Role

Sau đây là các bước để viết 1 role trong ansible

<ol>
<li>Tạo folder role trước, nếu chưa có. Folder này phải có tên là <strong>roles</strong></li>
<li>Tạo 1 folder trước một role cụ thể, ví dụ như prometheus</li>
<li>Tạo folder tasks để chứa playbook setup prometheus</li>
<li>Tạo folder vars để chứa các biến cần dùng trong khi setup prometheus</li>
<li>Tạo folder files để chứa các file cho role (file .rpm, .deb hoặc file binary…)</li>
<li>Tạo folder handlers để chứa các handler cần thiết</li>
<li>Và cuối cùng nhưng không kém phần quan trọng đó là….viết Readme để dễ dàng chia sẻ role này với mọi người :3</li>
</ol>

Sau đây là hướng dẫn các bước viết từng folder cụ thể

### Tasks

<img src="/img/2.png">

Tasks là nơi ta viết các bước setup cụ thể cho role của chúng ta. Viết như 1 playbook bình thường.



### Defaults/Vars

Defaults/Vars là nơi để chứa các biến cần thiết cho role. Lưu ý là các biến trong vars sẽ override các biến trong defaults. Khá dễ hiểu đúng không nào
<img src="/img/3.png">

### Templates
Templates là nơi bạn chứa các file config cần điểu chỉnh biến, Ansible sẽ lấy các biến có trong defaults/vars để điền vào file template của các bạn. Dùng folder template bằng module template

<img src="/img/4.png">

Ví dụ ta có file ./vars/main.yml chứa các biến cần thiết để bỏ vào template


```
---
PROMETHEUS_VERSION: "2.12.0"
RETENTION_TIME: "90d"
CONSUL_SERVER: "10.0.0.18"
ALERTMANAGER_SERVER: "10.0.0.180"
THANOS_TEAM: "cloudcraft-devops"
THANOS_ENV: "live"
THANOS_REPLICA_TAG: "C"
```

Và đây là file ./templates/prometheus.yml.j2 (chú ý đuôi .j2 để Ansible nhận diện được Jinja template)

```
global:
  external_labels:
    thanos_team: '{{ THANOS_TEAM }}'
    thanos_env: '{{ THANOS_ENV }}'
    replica: '{{ THANOS_REPLICA_TAG }}'
 
  scrape_interval:     15s
  evaluation_interval: 15s
 
scrape_configs:
  - job_name: prometheus
    file_sd_configs:
      - files:
        - targets/*.json
        - targets/*.yml
        refresh_interval: 5m
 
  - job_name: pushgateway
    honor_labels: true
    file_sd_configs:
      - files:
        - pushgw_targets/*.json
        refresh_interval: 5m
 
  - job_name: test-sd
    consul_sd_configs:
      - server: '{{ CONSUL_SERVER }}:8500'
```	  

### Files

Ta dùng module copy trong playbook để copy các file cần thiết trong folder files mà không cần phải liệt kê đường dẫn tuyệt đối ra (Ansible tự nhận diện đường dẫn).

<img src="/img/5.png">

### Handlers

Handlers dùng để trigger một số thao tác như reload/restart/start stop service khi thực hiện một task nào đó trong playbook bằng lệnh notify

<img src="/img/6.png">

```
- hosts: local
  connection: local
  become: yes
  become_user: root
  tasks:
   - name: Install Nginx
     apt:
       name: nginx
       state: installed
       update_cache: true
     notify:
      - Start Nginx
 
  handlers:
   - name: Start Nginx
     service:
       name: nginx
       state: started
```	   
```
- hosts: local
  connection: local
  become: yes
  become_user: root
  vars:
   - docroot: /var/www/serversforhackers.com/public
  tasks:
   - name: Add Nginx Repository
     apt_repository:
       repo: ppa:nginx/stable
       state: present
     register: ppastable
 
   - name: Install Nginx
     apt:
       pkg: nginx
       state: installed
       update_cache: true
     when: ppastable|success
     notify:
      - Start Nginx
 
   - name: Create Web Root
     file:
      path: '{{ docroot }}'
      mode: 775
      state: directory
      owner: www-data
      group: www-data
     notify:
      - Reload Nginx
 
  handlers:
   - name: Start Nginx
     service:
       name: nginx
       state: started
 
    - name: Reload Nginx
      service:
        name: nginx
        state: reloaded
```
Bây giờ thì chúng ta có 3 Task:

Add Nginx Repository – Thêm Nginx stable PPA để dùng Version ổn định mới nhất của Nginx sử dụng apt_repository module.

Install Nginx – cài đặt Nginx sử dụng apt module

Create Web Root – Cuối cùng tạo thư mục web root.		

Cũng có những cái mới ở đây là chỉ thị register và when. Những cái này cho Ansible biết để chạy một Task khi có cái gì đó khác xảy ra.

Add Nginx Repository Task đăng ký ppastable. Sau đó chúng ta sử dụng nó để thông báo Install Nginx Task chỉ chạy khi Task ppastable được đăng ký thành công.  Điều này cho phép chúng ta có điều kiện để ngăn chặn Ansible chạy một Task.



### Meta

Chứa các thông tin về metadata của role, thường chỉ dùng khi bạn publish role của mình lên Ansible Galaxy. Đây là một nơi mọi người upload và chia sẻ các role mình viết được. Coi thêm tại: https://galaxy.ansible.com/


### Readme

Nơi chứa các thông tin cần thiết để người khác có thể hiểu và sử dụng lại role của bạn/

<img src="/img/7.png">


Mặc định thì ansible sẽ kiếm role mà các bạn đã viết trong folder /etc/ansible/roles. Hoặc nếu bạn chạy playbook tại /home/cloudcraft/run_task.yml và trong file playbook này có gọi 1 số roles, Ansible sẽ dò các role cần dùng trong /home/cloudcraft/roles. Nếu không có thì Ansible mới dò trong /etc/ansible/roles













