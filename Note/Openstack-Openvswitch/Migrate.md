<h3>1. Giới thiệu về migrate trong Openstack </h3>
<img src="https://github.com/anhict/images/blob/master/migration-1.png">
<p>- Migration là quá trình di chuyển máy ảo từ host vật lí này sang host vật lí khác.Migration được sinh ra để làm nhiệm vụ bảo trì nâng cấp hệ thống.Ngày nay tính năng này được phát triển để thực hiện nhiều tác vụ hơn: </p>
<ul>
<li>Cân bằng tải : Di chuyển VMs tới các host khác khi phát hiện host đang chạy có dấu hiệu quá tải.</li>
<li>Bảo trì,nâng cấp hệ thống: Di chuyển các VMs ra khỏi trước khi tắt nó đi.</li>
<li>Khôi phục lại máy ảo khi host gặp lỗi: Restart máy ảo trên 1 host khác.</li>
</ul>
<p>- Trong Openstack,việc migrate được thực hiện giữa các node compute với nhau hoặc giữa các project trên cùng 1 node compute.</p>
<h3>2. Các kiểu migrate hiện có trong Openstack và workflow của chúng </h3>
<p>Openstack hỗ trợ 2 kiểu migration đó là :
<ul>
<li>Cold migration : Non-live migration</li>
<li>Live migration:</li>
<ul>
<li>True live migration (shared storage or volume-based)</li>
<li>Block live migration</li>
</ul>
</ul>
<h4>2.1 Cold Migrate ( Non-live migrate)</h4>
<p> Migrate khác live migrate ở chỗ nó thực hiện migration ở chỗ nó thực hiện migration khi tắt máy ảo (Libvirt domain không chạy)</p>
<p> Yêu cầu SSH ky pairs được triển khai cho user đang chạy nova-compute với mọi hypervisors.</p>
<p> Migrate workflow:</p>
<ul>
<li>Tắt máy ảo (tương tự  'vish destroy' ) và disconnect các volume.</li>
<li>Di chuyển thực mục hiện hành của máy ảo ra ngoài(instance_dir -> instance_dir_resize).Tiến hành resize instance sẽ tạo ra thư mục tạm thời</Li>
<li>Nếu sử dụng QCOW2,convert image sang định dạng RAW.</li>
<li>Với hệ thống share storage,di chuyển thư mục instance_dir mới vào.Nếu không, copy thông qua scp.</li>
</ul>
<h4> 2.2.Live Migration </h4>
<p>- Thực hiện bởi câu lệnh "nova live-migration [--block-migrate]"</p>
<p>- Có 2 loại live migration: normal migration và “block” migrations.</p>
<p>- Normal live migration yêu cầu cả hai source và target hypervisor phải truy cập đến data của instance ( trên hệ thống lưu trữ có chia sẻ, ví dụ: NAS, SAN)</p>
<p>- Block migration không yêu cầu đặc biệt gì đối với hệ thống storage. Instance disk được migrated như một phần của tiến trình.</p>
<p>Live migration không yêu cầu đặc biệt gì đối với hệ thống storage</p>
<p>Live migration workflow:</p>
<ul>
<li> Kiểm tra storage backend là thích hợp với loại migration hay không :</li>
<ul>
<li>Thực hiện kiếm tra hệ thông shared storage cho normal migrations</li>
<li>Thực hiện kiểm tra các yêu cầu cho block migrations</li>
<li>Kiểm tra trên cả source và destination, điều phối thông qua RPC calls từ scheduler</li></ul>
<ul>
<li>Trên destination</li>
<li>Tạo ra các kết nối volume cần thiết</li>
<li>Nếu là block migration,tạo thư mục instance,lưu lại các file bị mất từ Glance và tạo instance disk trống.</li></ul>
<li>Trên source,khởi tạo tiến trình migration.</li>
<li>Khi tiến trình hoàn tất,tái sinh file libvirt xml và define nó trên destination</li>
</ul>
<p>Dưới đây minh hoạt cho quá trình live migrate VM:</p>
<img src="https://github.com/anhict/images/blob/master/migration-2.png">
<img src="https://github.com/anhict/images/blob/master/migration-3.png">
<img src="https://github.com/anhict/images/blob/master/migration-4.png">
<img src="https://github.com/anhict/images/blob/master/migration-5.png">
<img src="https://github.com/anhict/images/blob/master/migration-6.png">
<h4>2.3. So sánh ưu nhược điểm giữa cold và live migrate</h4>
<p>- Cold migrate:</p>
<ul>
<li>Ưu điểm</li>
<ul>
<li>Đơn giản,dễ thực hiện</li>
<li>Thực hiện được với mọi loại máy ảo</li>
</ul> 
<li>Hạn chế:</li>
<ul>
<li>Thời gian downtime lớn</li>
<li>Không thể chọn được host muốn migrate tới</li>
<li>Quá trình migrate có thể mất một khoảng thời gian dài</li>  
</ul>  
</ul>
<p>- Live migrate: </p>
<ul>
<li>Ưu điểm:</li>
<ul>
<li>Có thể chọn host muốn migrate.</li>
<li>Tiết kiệm chi phí,tăng sự linh hoạt trong khâu quản lí và vận hành.</li>
<li>Giảm thời gian downtime và gia tăng thêm khả năng cứu hộ khi xảy ra sự cố.</li>
</ul>
</ul>
<ul>
  <li>Nhược điểm:</li>
  <ul><li>Dù chọn được host nhưng vẫn có những giới hạn nhất định</li>
    <li>Quá trình migrate có thể bị fails nếu host bạn chọn không đủ tài nguyên.</li>
    <li>Bạn không được can thiệp vào bất cứ tiến trình nào trong quá trình live migrate.</li>
    <li>Khó migrate với những máy ảo có dung lượng bộ nhớ lớn và trường hợp có 2 host khác CPU</li>
   </ul>
</ul>
<p>- Trong live-migrate có 2 loại đó là True live migrate và Block live migration </p>
<img src="https://github.com/anhict/images/blob/master/migration-7.png">
<p>- Ngữ cảnh sử dụng: </p>
<ul>
  <li>Nếu bạn buộc phải chọn host và giảm tối đa thời gian downtime của server thì nên chọn live-migrate (tùy vào loại storage sử dụng mà chọn true hoặc block migration).</li>
  <li>Nếu bạn không muốn chọn host hoặc đã kích hoạt config drive (một dạng ổ lưu trữ metadata của máy ảo,thường được dùng để cung cấp  cấu hình netwwork khi không sử dụng DHCP) thì hãy lựa chọn cold migrate.</li>
</ul>
<h3>3. Hướng dẫn cấu hình cold migrate trong OpenStack</h3>
<li>Sử dụng với SSH tunneling để migrate máy ảo hoặc resize máy ảo ở node mới.</li>
<p>Các bước cấu hình SSH Tunneling giữa các Nodes compute</p>
<li>Cho phép user nova có thể login (thực hiện trên tất cả các node compute). Ví dụ ở đây ta muốn migrate vm từ node compute1 (192.168.239.191) tới node compute2 (192.168.239.192).</li>
<pre>usermod -s /bin/bash nova</pre>
<li>Thực hiện tạo key pair trên node compute nguồn cho user nova</li>
<pre>su nova
ssh-keygen
echo 'StrictHostKeyChecking no' >> /var/lib/nova/.ssh/config
exit</pre>
<li>Thực hiện với quyền root, scp key pair tới compute node. Nhập mật khẩu khi được yêu cầu.</li>
<pre>scp /var/lib/nova/.ssh/id_rsa.pub root@compute2:/root/</pre>
<li>Trên node đích, thay đổi quyền của key pair cho user nova và add key pair đó vào SSH</li>
<pre>mkdir -p /var/lib/nova/.ssh
cat /root/id_rsa.pub >> /var/lib/nova/.ssh/authorized_keys
echo 'StrictHostKeyChecking no' >> /var/lib/nova/.ssh/config
chown -R nova:nova /var/lib/nova/.ssh</pre>
<p>Từ node compute1 kiểm tra để chắc chắn rằng user nova có thể login được vào node compute2 còn lại mà không cần sử dụng password</p>
<pre>su nova
ssh 192.168.238.192
exit</pre>
<p>Thực hiện migrate máy ảo</p>
<li>Tắt máy ảo</li>
<pre>nova stop Name_VM</pre>
<p>Migrate vm, nova-scheduler sẽ dựa vào cấu hình blancing weitgh và filter để define ra node compute đích</p>
<pre>nova migrate Name_VM</pre>
<p>Chờ đến khi vm thay đổi trạng thái sang VERIFY_RESIZE (dùng nova show để xem), confirm việc migrate :</p>
<pre>nova resize-confirm <Name_VM></pre>
<h3>4. Hướng dẫn cấu hình live migrate (block migration) trong OpenStack</h3>
<p>OpenStack hỗ trợ 2 loại live migrate, mỗi loại lại có yêu cầu và được sử dụng với mục đích riêng:</p>
<ul>
<li>True live migration (shared storage or volume-based) : Trong trường hợp này, máy ảo sẽ được di chuyển sửa dụng storage mà cả hai máy computes đều có thể truy cập tới. Nó yêu cầu máy ảo sử dụng block storage hoặc shared storage.</li>
<li>Block live migration : Mất một khoảng thời gian lâu hơn để hoàn tất quá trình migrate bởi máy ảo được chuyển từ host này sang host khác. Tuy nhiên nó lại không yêu cầu máy ảo sử dụng hệ thống lưu trữ tập trung.</li>
</ul>
<p>Các yêu cầu chung:</p>
<ul>
<li>Cả hai node nguồn và đích đều phải được đặt trên cùng subnet và có cùng loại CPU.</li>
<li>Cả controller và compute đều phải phân giải được tên miền của nhau.</li>
<li>Compute node buộc phải sử dụng KVM với libvirt.</li>
</ul>
<p><strong>Cấu hình migration</strong></p>
<p> Sửa lại file libvirt.conf dùng  vi /etc/libvirt/libvirtd.conf</p>
<pre>listen_tls = 0
listen_tcp = 1
listen_addr = "0.0.0.0"
unix_sock_group = "libvirtd"
unix_sock_ro_perms = "0777"
unix_sock_rw_perms = "0770"
auth_unix_ro = "none"
auth_unix_rw = "none"
auth_tcp = "none"</pre> 
<p>Sửa lại file vi /etc/default/libvirt</p>
<pre>start_libvirtd="yes"
libvirtd_opts="-l"</pre>
<p>Khởi động lại libvirtd</p>
<pre>systemctl restart libvirtd.service</pre>
<li>Kiểm tra lại </li>
<pre>ps ax | grep [l]ibvirtd
netstat -pantu | grep libvirtd
virsh -c qemu+tcp://127.0.0.1/system</pre>
<img src="https://github.com/anhict/images/blob/master/Screenshot_26.png">
<p>Cấu hình iptables cho phép giao thông đi qua các cổng 16509 và 49152:</p>
<pre>iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 5900:5909 -j ACCEPT
iptables -A INPUT -p tcp --dport 16509 -j ACCEPT
iptables -A INPUT -p tcp --dport 49152 -j ACCEPT</pre>
<p>Nếu sử dụng block live migration cho các VMs boot từ local thì sửa file nova.conf bỏ comment rpc_backend = rabbit rồi restart lại dịch vụ nova-compute :</p>
<pre>systemctl restart libvirtd.service</pre>
<h4>Migrate máy ảo</h4>
<p>Máy VM01 ở compute1 </p>
<img src="https://github.com/anhict/images/blob/master/Screenshot_27.png">
<p>Thực hiện migrate máy ảo bằng câu lệnh nova live-migration vm01 compute3 với những máy dùng shared storage. Đối với những máy boot từ local, sử dụng câu lệnh sau:</p>
<pre>nova live-migration --block-migrate VM01 compute3</p>
<p>Quá trình Migrating </p>
<img src="https://github.com/anhict/images/blob/master/Screenshot_24.png">
<p>Máy ảo vm01 đã được chuyển đến node compute3 </p>
<img src="https://github.com/anhict/images/blob/master/Screenshot_25.png">



  
