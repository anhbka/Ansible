### 1. Ansible

*Ansible là một platform opensource, nghĩa là bạn có thể viết thêm hay chỉnh sửa tuỳ ý. Ansible khá đơn giản để sử dụng. Nôm na bạn có thể hình dung là chỉ việc khai báo địa chỉ server và những điều muốn làm với server đó vào ansible, rồi sau đó chỉ cần chạy script bạn vừa viết trên và ngồi uống trà chờ hoàn thành.*

### 2. Đặc điểm

* Ansible miễn phí và là 1 opensource

* Ansible sử dụng phương thức ssh

* Việc cài đặt không tốn nhiều tài nguyên

* Được phát triển bởi ngôn ngữ python. Nên nếu bạn muốn tạo thêm module thì cũng sử dụng bằng python

* Khá nhẹ và dễ setup

* Các sciprt thường được dùng định dạng YAML

* Ansible có một cộng đồng tương tác lớn

### 3. Thành phần

* Playbooks - Là nơi bạn sẽ khai báo kịch bản chạy cho server

* Tasks - Là những công việc nhỏ trong cuốn sổ Playbooks trên

* Inventory - Khai báo địa chỉ server cần được setup

* Modules - Những chức năng hỗ trợ cho việc thực thi tasks dễ và đang dạng

```
ansible -i ./hosts --connection=local local -m ping

-i ./hosts – đặt file Inventory (môi trường kết nối), có tên là hosts.

remote, local, all – Sử dụng các Server mà được định nghĩa với tên nhãn trong file hosts  hay file Inventory. “all” là từ khoá đặc biệt để chạy tất cả các Server được định nghĩa trong file

-m ping – Sử dụng ping module, mà đơn giản là chạy câu lệnh ping và trả về kết quả

-c local | --connection=local – chạy câu lệnh local, không phải qua SSH

ansible -i ./hosts local --connection=local -b --become-user=root \
    -m shell -a 'apt-get install nginx'
	
-b –  viết tắt “become”, nói với Ansible rằng sẽ trở thành một user khác khi chạy câu lệnh. Đây là cách giúp bạn có thể chạy bằng nhiều user khác nhau, hay nâng quyền lên root user

--become-user=root – Chạy các câu lện bằng user root. Chúng ta có thể định nghĩa bất kỳ user nào mà đang tồn tại ở đây.

 -a – được sử dụng để truyền bất kỳ tham số nào cho Module được định nghĩa sử dụng -m	
```

```
Exp:
- hosts: remote
  become: yes
  become_user: root
  tasks:
   - name: Install Nginx
     apt:
       name: nginx
       state: installed
       update_cache: true
ansible-playbook -i ./hosts nginx.yml	   
```	   

Note:
```
ssh-keygen
ssh-copy-id root@192.168.100.99
```


https://docs.ansible.com/ansible/latest/user_guide/vault.html