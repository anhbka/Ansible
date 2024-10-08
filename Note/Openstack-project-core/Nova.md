<h3> 1. Vai trò của project Nova </h3>
<p>- Quản lí các máy ảo trong môi trường OpenStack, chịu trách nhiệm khởi tạo, lập lịch, ngừng hoạt động của các máy ảo theo yêu cầu. </p>
<p>- Nova bao gồm nhiều tiến trình trên server, mỗi tiến trình lại thực hiện một chức năng khác nhau.
- Nova cung cấp REST API để tương tác với ứng dụng client phía người dùng, trong khi các thành phần bên trong Nova tương tác với nhau thông qua RPC. </p>
<p>- Các API servers thực hiện các REST request, điển hình nhất là thao tác đọc, ghi vào cơ sở dữ liệu, với tùy chọn là gửi các bản tin RPC tới các dịch vụ khác của Nova. Các bản tin RPC dược thực hiện nhờ thư viện <strong> oslo.messaging </strong> - lớp trừu tượng ở phía trên của các message queue. Hầu hết các thành phần của nova có thể chạy trên nhiều server và có một trình quản lý lắng nghe các bản tin RPC. Ngoại trừ <strong> nova-compute </strong>, vì dịch vụ nova-compute được cài đặt trên các máy <strong>compute </strong>- các máy cài đặt hypervisor mà <strong>nova-compute</strong> quản lý. </p>
<p>- Nova cũng sử dụng một cơ sở dữ liệu trung tâm chia sẻ chung giữa các thành phần. Tuy nhiên, vì mục tiêu nâng cấp, các cơ sở dữ liệu được truy cập thông qua một lớp đối tượng dể đảm bảo các thành phần kiểm soát đã nâng cấp vẫn có thể giao tiếp với nova-compute ở phiên bản trước đó. Để thực hiện điều này, nova-compute ủy nhiệm các yêu cầu tới cơ sở dữ liệu thông qua RPC tới một trình quản lý trung tâm, chính là dịch vụ <strong> nova-conductor </strong>.</p>
<h3>2. Compute service </h3>
- Kiến trúc Compute service :
<img src="https://github.com/anhict/images/blob/master/9.png?raw=true">
<p><li> Các dịch vụ của nova được phân loại bao gồm: </li></p>
<p>-	<strong> API server </strong> : API server là trái tim của cloud framework, nơi thực hiện các lệnh và việc kiểm soát hypervisor, storage, networking có thể lập trình được. Các API endpoints về cơ bản là các HTTP web services thực hiện xác thực, ủy quyền và các lệnh căn bản, kiểm các các chức năng sử dụng giao diện API của Amazon, Rackspace, và các mô hình liên quan khác. Điều này cho phép các API tương thích với nhiều công cụ sẵn có, tương tác với các nhà cung cấp dịch vụ cloud khác. Điều này tạo ra để ngăn chặn vấn đề phụ thuộc vào nhà cung cấp dịch vụ.</p>
<p>-	<strong>Message queue</strong> : Message Broker cung cấp hàng đợi lưu bản tin tương tác giữa các dịch vụ, các thành phần như compute nodes, networking controllers(phần mềm kiểm soát hạ tầng mạng), API endpoints, scheduler(xác định máy vật lý nào được sử dụng để cấp phát tài nguyên ảo hóa), và các thành phần tương tự.</p>
<p>-	<strong>Compute woker</strong>: Compute worker quản lý các tài nguyên tính toán của các máy ảo trên các Compute host. API sẽ chuyển tiếp các lệnh tới compute worker để hoàn thành các nhiệm vụ sau:</p>
<ul><p>+ Chạy các máy ảo</p>
<p>+ Xóa các máy ảo</p>
<p>+ Khởi động lại máy ảo</p>
<p>+ Attach các volume</p>
<p>+ Detach các volume</p>
<p>+ Lấy console output</p> </ul>
<h3> 3. Các thành phần của Compute service </h3>
<p>OpenStack Compute bao gồm các thành phần sau: </p>
<p>- <strong> Nova-api </strong>Tiếp nhận và phản hồi các lời gọi API từ người dùng cuối. Dịch vụ này hỗ trợ OpenStack Compute API, Amazon EC2 API và một API quản trị đặc biệt cho những người dùng thực hiện các tác vụ quản trị. Nó thực hiện một số chính sách và khởi tạo hầu hết các hoạt động điều phối, chẳng hạn như tạo máy ảo.</p>
<p>	<strong> - Nova-compute</strong>  Một worker daemon thực hiện tác vụ quản lý vòng đời các máy ảo như: tạo và hủy các instance thông qua các hypervisor APIs. Ví dụ:</p>
<ul>
<p> + XenAPI đối với XenServer/XCP </p>
<p> + libvirt đối với KVM hoặc QEMU </p>
<p>	+ VMwareAPI đối với VMware </p>
</ul>
<p><li>Tiến trình xử lý của nova-compute khá phức tạp, về cơ bản thì daemon này sẽ tiếp nhận các hành động từ hàng đợi và thực hiện một chuỗi các lệnh hệ thống như vận hành máy ảo KVM và cập nhật trạng thái của máy ảo đó vào cơ sở dữ liệu.</li></p>

<p>-<strong>Nova-scheduler Daemon</strong> này lấy các yêu cầu tạo máy ảo từ hàng đợi và xác định xem server compute nào sẽ được chọn để vận hành máy ảo. </p>
<p>-<strong>	Nova-conductor</strong> Là module trung gian tương tác giữa nova-compute và cơ sở dữ liệu. Nó hủy tất cả các truy cập trự tiếp vào cơ sở dữ liệu tạo ra bởi nova-compute nhằm mục đích bảo mật, tránh trường hợp máy ảo bị xóa mà không có chủ ý của người dùng. </p>
<p>-<strong>	Nova-cert</strong> Là một worker daemon phục vụ dịch vụ Nova Cert cho chứng chỉ X509, được sử dụng để tạo các chứng chỉ cho euca-bundle-image. Dịch vụ này chỉ cần thiết khi sử dụng EC2 API.
<p>-<strong>Nova-network </strong> : quản lý ip forwording, bridges, và vlan.  </p>
<p>-<strong>	Nova-consoleauth </strong> Ủy quyền tokens cho người dùng mà console proxies cung cấp. Dịch vụ này phải chạy với console proxies để làm việc. </p>
<p>-<strong>	Nova-novncproxy </strong>  Cung cấp một proxy để truy cập máy ảo đang chạy thông qua kết nối VNC. Hỗ trợ các novnc client chạy trên trình duyệt. </p>
<p>-<strong>Nova-spicehtml5proxy</strong> Cung cấp một proxy truy cấp máy ảo đang chạy thông qua kết nối SPICE. Hỗ trợ các client chạy trên trình duyệt hỗ trợ HTML5. </p>
<p>-<strong>	Nova-xvpvncproxy  </strong>Cung cấp một proxy truy cập máy ảo đang chạy thông qua kết nối VNC.
<p>-<strong>	Nova client </strong> Cho phép người dùng thực hiện tác vụ quản trị hoặc các tác vụ thông thường của người dùng cuối.2 </p>
<p>-<strong>	The queue </strong> Là một trung tâm chuyển giao bản tin giữa các daemon. Thông thường queue này cung cấp bởi một phần mềm message queue hỗ trợ giao thức AMQP: RabbitMQ, Zero MQ. </p>
<p>-<strong>	SQL database </strong> Lưu trữ hầu hết trạng thái ở thời điểm biên dịch và thời điểm chạy cho hạ tầng cloud: </p>

<ul>
<p><li>	Các loại máy ảo đang có sẵn </li></p>
<p><li>Các máy tính đang đưa vào sử dụng  </li></p>
<p><li>Hệ thống mạng sẵn sàng  </li></p>
<p><li>Các projects.  </li></p>
</ul>
<h3> 4. Nova ,Libvirt và KVM </h3>

<p>- KVM- QEMU :</p>
 <p>+ KVM - module của hạt nhân linux đóng vai trò tăng tốc phần cứng khi sử dụng kết hợp với hypervisor QEMU, cung cấp giải pháp ảo hóa full virtualization.</p>
<p>+ Sử dụng libvirt làm giao diện trung gian tương tác giữa QEMU và KVM</p>
<p>-Libvirt : </p>
<p>-Thực thi tất cả các thao tác quản trị và tương tác với QEMU bằng việc cung cấp các API.</p>
<p>-Các máy ảo được định nghĩa trong Libvirt thông qua một file XML, tham chiếu tới khái niệm "domain".</p>
<p>-Libvirt chuyển XML thành các tùy chọn của các dòng lệnh nhằm mục đích gọi QEMU</p>
<p>-Tương thích khi sử dụng với virsh (một công cụ quản quản lý tài nguyên ảo hóa giao diện dòng lệnh).</p>

<h3> 5. Tích hợp Nova với Libvirt và KVM quản lý máy ảo. </h3>
<p>- Hệ thống Openstack thường sử dụng KVM và Xen-based hypervisor ,Nova support các hypervisor : </p>


<ul>
<p>•	Docker </p>
<p>•	Hyper-V </p>
<p>•	Kernel-based Vitual Machine (KVM)</p>
<p>•	Linux Containers (LXC)</p>
<p>•	Quick Emulator (QEMU)</p>
<p>•	User Mode Linux (UML)</p>
<p>•	VMware vSphere</p>
<p>•	Xen</p>
</ul>
<strong> Workflow Nova Compute: </strong>
<p>Compute Manager:</p>
<ul><p><li>Cấu hình trong hai file: nova/compute/api.py và nova/compute/manager.py </li></p>
<p><li>Các compute API tiếp nhận yêu cầu từ người dùng từ đó gọi tới compute manager. Compute manager lại gọi tới Nova libvirt driver. Driver này sẽ gọi tới API của libvirt thực hiện các thao tác quản trị.</li></p>
</ul>
<strong> Nova Libvirt Driver: </strong>
<p>Được cấu hình trong các file 	nova/virt/libvirt/driver.py và nova/virt/libvirt/*.py có vai trò tương tác với libvirt.</p>


<p><li><strong>Một số component tham gia vào quá trình khởi tạo và dự phòng cho máy ảo:</strong></li></p>
<ul>
-	CLI: Command Line Interpreter - là giao diện dòng lệnh để thực hiện các command gửi tới OpenStack Compute
-	Dashboard (Horizon): cung cấp giao diện web cho việc quản trị các dịch vụ trong OpenStack
-	Compute(Nova): quản lý vòng đời máy ảo, từ lúc khởi tạo cho tới lúc ngừng hoạt động, tiếp nhận yêu cầu tạo máy ảo từ người dùng.
-	Network - Quantum (hiện tại là Neutron): cung cấp kết nối mạng cho Compute, cho phép người dùng tạo ra mạng riêng của họ và kết nối các máy ảo vào mạng riêng đó.
-	Block Storage (Cinder): Cung cấp khối lưu trữ bền vững cho các máy ảo
-	Image(Glance): lưu trữ đĩa ảo trên Image Store
-	Identity(Keystone): cung cấp dịch vụ xác thưc và ủy quyền cho toàn bộ các thành phần trong OpenStack.
-	Message Queue(RabbitMQ): thực hiện việc giao tiếp giữa các component trong OpenStack như Nova, Neutron, Cinder.
</ul>


<p><li><strong> Request flow trong quá trình tạo máy ảo . </strong></li></p>
<img src="https://github.com/anhict/images/blob/master/10.png?raw=true">


<p><strong>-Bước 1 </strong>: Từ Dashboard hoặc CLI, nhập thông tin chứng thực (ví dụ: user name và password) và thực hiện lời gọi REST tới Keystone để xác thực</p>
<p><strong>-Bước 2</strong>: Keystone xác thực thông tin người dùng và tạo ra một token xác thực gửi trở lại cho người dùng, mục đích là để xác thực trong các bản tin request tới các dịch vụ khác thông qua REST</p>
<p><strong>-Bước 3</strong>: Dashboard hoặc CLI sẽ chuyển yêu cầu tạo máy ảo mới thông qua thao tác "launch instance" trên openstack dashboard hoặc "nova-boot" trên CLI, các thao tác này thực hiện REST API request và gửi yêu cầu tới nova-api</p>
<p><strong>-Bước 4</strong>: nova-api nhận yêu cầu và hỏi lại keystone xem auth-token mang theo yêu cầu tạo máy ảo của người dùng có hợp lệ không và nếu có thì hỏi quyền hạn truy cập của người dùng đó.</p>
<p><strong>-Bước 5</strong>: Keystone xác nhận token và update lại trong header xác thực với roles và quyền hạn truy cập dịch vụ lại cho nova-api</p>
<p><strong>-Bước 6</strong>: nova-api tương tác với nova-database</p>
<p><strong>-Bước 7</strong>: Dababase tạo ra entry lưu thông tin máy ảo mới</p>
<p><strong>-Bước 8</strong>: nova-api gửi rpc.call request tới nova-scheduler để cập cập entry của máy ảo mới với giá trị host ID (ID của máy compute mà máy ảo sẽ được triển khai trên đó). C(Chú ý: yêu cầu này lưu trong hàng đợi của Message Broker - RabbitMQ)</p>
<p><strong>-Bước 9</strong>: nova-scheduler lấy yêu cầu từ hàng đợi</p>
<p><strong>-Bước 10</strong>: nova-scheduler tương tác với nova-database để tìm host compute phù hợp thông qua việc sàng lọc theo cấu hình và yêu cầu cấu hình của máy ảo</p>
<p><strong>-Bước 11</strong>: nova-database cập nhật lại entry của máy ảo mới với host ID phù hợp sau khi lọc.</p>
<p><strong>-Bước 12</strong>: nova-scheduler gửi rpc.cast request tới nova-compute, mang theo yêu cầu tạo máy ảo mới với host phù hợp.</p>
<p><strong>-Bước 13</strong>: nova-compute lấy yêu cầu từ hàng đợi.</p>
<p><strong>-Bước 14</strong>: nova-compute gửi rpc.call request tới nova-conductor để lấy thông tin như host ID và flavor(thông tin về RAM, CPU, disk) (chú ý, nova-compute lấy các thông tin này từ database thông qua nova-conductor vì lý do bảo mật, tránh trường hợp nova-compute mang theo yêu cầu bất hợp lệ tới instance entry trong database)</p>
<p><strong>-Bước 15</strong>: nova-conductor lấy yêu cầu từ hàng đợi</p>
<p><strong>-Bước 16</strong>: nova-conductor tương tác với nova-database</p>
<p><strong>-Bước 17</strong>: nova-database trả lại thông tin của máy ảo mới cho nova-conductor, nova condutor gửi thông tin máy ảo vào hàng đợi.</p>
<p><strong>-Bước 18</strong>: nova-compute lấy thông tin máy ảo từ hàng đợi</p>
<p><strong>-Bước 19</strong>: nova-compute thực hiện lời gọi REST bằng việc gửi token xác thực tới glance-api để lấy Image URI với Image ID và upload image từ image storage.</p>
<p><strong>-Bước 20</strong>: glance-api xác thực auth-token với keystone</p>
<p><strong>-Bước 21</strong>: nova-compute lấy metadata của image(image type, size, etc.)</p>
<p><strong>-Bước 22</strong>: nova-compute thực hiện REST-call mang theo auth-token tới Network API để xin cấp phát IP và cấu hình mạng cho máy ảo</p>
<p><strong>-Bước 23</strong>: quantum-server (neutron server) xác thực auth-token với keystone</p>
<p><strong>-Bước 24</strong>: nova-compute lấy thông tin về network</p>
<p><strong>-Bước 25</strong>: nova-compute thực hiện Rest call mang theo auth-token tới Volume API để yêu cầu volumes gắn vào máy ảo</p>
<p><strong>-Bước 26</strong>: cinder-api xác thực auth-token với keystone</p>
<p><strong>-Bước 27</strong>: nova-compute lấy thông tin block storage cấp cho máy ảo</p>
<p>-<strong>Bước 28</strong>: nova-compute tạo ra dữ liệu cho hypervisor driver và thực thi yêu cầu tạo máy ảo trên Hypervisor (thông qua libvirt hoặc api - các thư viện tương tác với hypervisor) </p>


