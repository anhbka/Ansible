<h3>1.	Vai trò của project Glance </h3>
<p>-Là Image services bao gồm việc tìm kiếm, đăng ký, thu thập các images của các máy ảo. Glance cung cấp RESTful API cho phép truy vấn metadata của image máy ảo cũng như thu thập image thực sự</p>
<p><p>-Images của máy ảo thông qua Glance có thể lưu trữ ở nhiều vị trí khác nhau từ hệ thống file thông thường cho tới hệ thống object-storage như OpenStack Swift.</p>
<p>-Trong Glance, các images được lưu trữ giống như các template. Các Template này sử dụng để vận hành máy ảo mới. Glance là giải pháp để quản lý các ảnh đĩa trên cloud. Nó cũng có thể lấy bản snapshots từ các máy ảo đang chạy để thực hiện dự phòng cho các VM và trạng thái các máy ảo đó.
</p>
<h3> 2.	Các thành phần trong project Glance </h3>
<p><strong>-Glance-api</strong>: tiếp nhận lời gọi API để tìm kiếm, thu thập và lưu trữ image</p>
<p><strong>-Glance-registry</strong>: thực hiện tác vụ lưu trữ, xử lý và thu thập metadata của images</p>
<p><strong>-Database</strong>: cơ sở dữ liệu lưu trữ metadata của image</p>
<p><strong>-Storage repository</strong>: được tích hợp với nhiều thành phần khác trong OpenStack như hệ thống file thông thường, Amazon và HTTP phục vụ cho chức năng lưu trữ images</p>

<img src="https://github.com/anhict/images/blob/master/16.png?raw=true">
<p>Glance tiếp nhận các API request yêu cầu images từ người dùng cuối hoặc các nova component và costheer lưu trữ các file images trong hệ thống object storage Swift hoặc các storage repos khác. Glance hỗ trợ các hệ thống backend lưu trữ sau:</p>
<ul>
<p>•	File system: Glance lưu trữ images của các máy ảo trong hệ thống tệp tin thông thường theo mặc định, hỗ trợ đọc ghi các image files dễ dàng vào hệ thống tệp tin </p>
<p>•	Object Storage: Là hệ thống lưu trữ do OpenStack Swift cung cấp - dịch vụ lưu trữ có tính sẵn sàng cao , lưu trữ các image dưới dạng các object.</p>
<p>•	BlockStorage: Hệ thống lưu trữ có tính sẵn sàng cao do OpenStack Cinder cung cấp, lưu trữ các image dưới dạng khối</p>
<p>•	VMWare</p>
<p>•	Amazon S3</p>
<p>•	HTTP: Glance có thể đọc các images của các máy ảo sẵn sàng trên Internet thông qua HTTP. Hệ thống lưu trữ này chỉ cho phép đọc.</p>
<p>•	RADOS Block Device(RBD): Lưu trữ các images trong cụm lưu trữ Ceph sử dụng giao diện RBD của Ceph
<p>•	Sheepdog: Hệ thống lưu trữ phân tán dành cho QEMU/KVM</p>
<p>•	GridFS: Lưu trữ các image sử dụng MongoDB</p>

</ul>
<h3>3.	Kiến trúc của Glance </h3>
<p>Kiến trúc Glance bao gồm các thành phần sau:</p>
<ul>
<p>•	Client: ứng dụng sử dụng Glance server</p>
<p>•	REST API: gửi yêu cầu tới Glance thông qua REST</p>
<p>•	Database Abstraction Layer (DAL): là một API thống nhất việc giao tiếp giữa Glance và databases</p>
<p>•	Glance Domain Controller: là middleware triển khai các chức năng chính của Glance: ủy quyền, thông báo, các chính sách, kết nối cơ sở dữ liệu</p>
<p>•	Glance Store: tổ chức việc tương tác giữa Glance và các hệ thống lưu trữ dữ liệu</p>
<p>•	Registry Layer: lớp tùy chọn tổ chức việc giao tiếp một cách bảo mật giữa domain và DAL nhờ việc sử dụng một dịch vụ riêng biệt</p>
</ul>
<img src="https://github.com/anhict/images/blob/master/17.png?raw=true">
<li>Các định dạng lưu trữ image của Glance</li>
<img src="https://github.com/anhict/images/blob/master/18.png?raw=true">
<p>Container Formats mô tả định dạng files và chứa các thông tin metadata về máy ảo thực sự. Các định dạng container hỗ trợ bởi Glance.</p>
<img src="https://github.com/anhict/images/blob/master/19.png?raw=true">
<p>•	Luồng trạng thái của Glance</p>
<ul>
<p>-	Queued: Định danh của image được bảo vệ trong Glance registry. Không có dữ liệu nào của image được tải lên Glance và kích thước của image không được thiết lập rõ ràng sẽ được thiết lập về zero khi khởi tạo.</p>
<p>-	Saving: Trạng thái này biểu thị rằng dữ liệu thô của image đang upload lên Glance. Khi image được đăng ký với lời gọi POST /images và có một header đại diện x-image-meta-location, image đó sẽ không bao giờ được đưa và trạng thái "saving" (bởi vì dữ liệu của image đã có sẵn ở một nơi nào đó)
<p>-	Active: Biểu thị rằng một image đã sẵn sàng trong Glance. Trạng thái này được thiết lập khi dữ liệu của image được tải lên hoàn toàn.</p>
-	Deactivated: Trạng thái biểu thị việc không được phép truy cập vào dữ liệu của image với tài khoản không phải admin. Khi image ở trạng thái này, ta không thể tải xuống cũng như export hay clone image.
<p>-	Killed: Trạng thái biểu thị rằng có vấn đề xảy ra trong quá trình tải dữ liệu của image lên và image đó không thể đọc được</p>
<p>-	Deleted: Trạng thái này biểu thị việc Glance vẫn giữ thông tin về image nhưng nó không còn sẵn sàng để sử dụng nữa. Image ở trạng thái này sẽ tự động bị gỡ bỏ vào ngày hôm sau.</p>
<p>-	Pending_delete: Tương tự như trạng thái deleted, tuy nhiên Glance chưa gỡ bỏ dữ liệu của image ngay. Một image khi đã rơi vào trạng thái này sẽ không có khả năng khôi phục.</p>

</ul>
<img src="https://github.com/anhict/images/blob/master/20.png?raw=true">
<h3>4.	Các file cấu hình Glance </h3>
<p>-Các tệp cấu hình của glance nằm trong thư mục /etc/glance. Có tất cả 7 tệp cấu hình như sau: </p>
<p>-glance-api.conf: File cấu hình cho API của image service.</p>
<p>-glance-registry.conf: File cấu hình cho glance image registry - nơi lưu trữ metadata về các images.</p>
<p>-glance-api-paste.ini: Cấu hình cho các API middleware pipeline của Image service</p>
<p>-glance-manage.conf: Là tệp cấu hình ghi chép tùy chỉnh. Các tùy chọn thiết lập trong tệp glance-manage.conf sẽ ghi đè lên các section cùng tên thiết lập trong các tệp glance-registry.conf và glance-api.conf. Tương tự như vậy, các tùy chọn thiết lập trong tệp glance-api.conf sẽ ghi đè lên các tùy chọn thiết lập trong tệp glance-registry.conf</p>
<p>-glance-registry-paste.ini: Tệp cấu hình middle pipeline cho các registry của Image service.</p>
<p>-glance-scrubber.conf: Tiện ích sử dụng để dọn sạch các images đã ở trạng thái "deleted". Nhiều glance-scrubber có thể chạy trong triển khai, tuy nhiên chỉ có một scrubber được thiết lập để "dọn dẹp" cấu hình trong file "scrubber.conf". Clean-up scrubber này kết hợp với các scrubber khác bằng cách duy trì một hàng đợi chính của các images cần được loại bỏ. Tệp glance-scrubber.conf cũng đặc tả cấu hình các giá trị quan trọng như khoảng thời gian giữa các lần chạy, thời gian chờ của các images trước khi bị xóa. Glance-scrubber có thể chạy theo định kỳ hoặc có thể chạy như một daemon trong khoảng thời gian dài.</p>
<p>-policy.json: File tùy chọn được thêm vào để điều khiển truy cập áp dụng với image service. Trong file này ta có thể định nghĩa các roles và policies. Nó là tính năng bảo mật trong OpenStack Glance.</p>

