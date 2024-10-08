<h3>1.	Vai trò của project Cinder</h3>
<p>		Cinder là dịch vụ Block Storage trong Openstack. Nó được thiết kế để người dùng cuối có thể thực hiện việc lưu trữ bởi Nova, việc này được thực hiện bởi LVM hoặc các plugin driver cho các nền tảng lưu trữ khác. Cinder ảo hóa việc quản lý các thiết bị block storage và cung cấp cho người dùng cuối một API đáp ứng được nhu cầu tự phục vụ cũng như tiêu thụ các tài nguyên đó mà không cần biết quá nhiều kiến thức chuyên sâu.</p>
<h3> 2.	Kiến trúc và cơ chế hoạt động của Cinder </h3>
<img src="https://github.com/anhict/images/blob/master/11.png?raw=true">
<p>- Cinder-api : Xác thực và định tuyến các yêu cầu xuyên suốt dịch vụ Cinder. </p>
<p>- Cinder-scheduler : Lên lịch và định tuyến các yêu cầu tới dịch vụ volume thích hợp. Tùy thuộc vào cách cấu hình, có thể chỉ là dùng round-robin để định ra việc sẽ dùng volume service nào, hoặc có thể phức tạp hơn bằng cách dùng Filter Scheduler. Filter Scheduler là mặc định và bật các bộ lọc như Capacity, Avaibility Zone, Volume Type, và Capability. </p>
<p> Cinder-volume : Quản lý thiết bị block storage, đặc biệt là các thiết bị back-end </p>
<p>- Cinder-backup : Cung cấp phương thức để backup một Block Storage volume tới Openstack Object Storage (Swift) </p>
<p>- Driver : Chứa các mã back-end cụ thể để có thể liên lạc với các loại lưu trữ khác nhau. </p>
<p><p>- Storage : Các thiết bị lưu trữ từ các nhà cung cấp khác nhau. </p>
<p>- SQL DB : Cung cấp một phương tiện dùng để back up dữ liệu từ Swift/Celp, etc,.... </p>
<h3> 3. Điểm khác nhau giữa Ephemeral và Volume boot disk </h3>
<h4> 3.1 Ephemeral </h4>
<p>Ephemeral disk là disk ảo mà được tạo cho mục đích boot một máy ảo và nên được coi là nhất thời.</p>
<p>Ephemeral disk hữu dụng trong trường hợp bạn không lo lắng về nhu cầu nhân đôi một máy ảo hoặc hủy một máy ảo và dữ liệu trong đó sẽ mất hết. Bạn vẫn có thể mount một volume trên một máy ảo được boot từ một ephemeral disk và đẩy bất kỳ data nào cần thiết để lưu lại trong volume.</p>
<p> Một số đặc tính :</p>
<ul>
<p>•	Không sử dụng hết volume quota : Nếu bạn có nhiều instance quota, bạn có thể boot chúng từ ephemeral disk ngay cả khi không có nhiều volume quota. </p>
<p>•	Bị xóa khi vm bị xóa : Dữ liệu trong emphemeral disk sẽ bị mất khi xóa mấy ảo. </p>
</ul>
<h4> 3.2 Volume boot disk </h4>
<p>Voume là dạng lưu trữ bền vững hơn ephemeral disk và có thể dùng để boot như là một block device có thể mount được.</p>
<p>Volume boot disk hữu dụng khi bạn cần dupicate một vm hoặc backup chúng bằng cách snapshot, hoặc nếu bạn muốn dùng phương pháp lưu trữ đáng tin cậy hơn là ephemeral disk. Nếu dùng dạng này, cần có đủ quota cho các vm cần boot.</p>
<p>Một số đặc tính :</p>
<ul>
<p>•	Có thể snapshot</p>
<p>•	Không bị xóa khi xóa máy ảo : Bạn có thể xóa máy ảo nhưng dữ liệu vẫn còn trong volume•	Sử dụng hết volume quota : volume quota sẽ được sử dụng hết khi dùng tùy chọn này</p>
<p>•	Sử dụng hết volume quota : volume quota sẽ được sử dụng hết khi dùng tùy chọn này</p>
</ul>
<h3>4.	Các phương thức boot máy ảo (từ góc nhìn đối với Cinder)</h3>
<p>Trong Openstack, có các cách khác nhau để tạo máy ảo là :</p>
<ul>
<p>o	Image : Tạo một ephameral disk từ image đã chọn.</p>
<p>o	Volume: Boot máy ảo từ một bootable volume đã có sẵn.</p>
<p>o	Image ( tạo một volume mới) : Tạo một bootable mới từ image đã chọn và boot máy ảo từ đó.</p>
<p>o	Volume snapshot (tạo một volume mới) : Tạo một volume từ volume snapshot đã chọn và boot máy ảo từ đó.</p></ul>
<h3> 5.	Luồng làm việc của Cinder </h3>
<h4> 5.1 Workflow của Cinder khi tạo mới Volume </h4>
<img src="https://github.com/anhict/images/blob/master/12.png?raw=true">


<p>Hình bên trên mô tả quy trình tạo Volume , tiếp theo chúng ta cùng đến với quy trình tạo ra volume mới của Cinder :</p>
<img src="https://github.com/anhict/images/blob/master/14.png?raw=true">
<p>1.	Client yêu cầu tạo ra Volume thông qua việc gọi REST API (Client cũng có thể sử dụng tiện ích CLI của python-client)</p>
<p>2.	Cinder-api : Quá trình xác nhận hợp lệ yêu cầu thông tin người dùng , một khi được xác nhận một message được gửi lên hàng chờ AMQP để xử lý.</p>
<p>3.	Cinder-volume thực hiện quá trình đưa message ra khỏi hàng đợi , gửi thông báo tới cinder-scheduler để báo cáo xác định backend cung cấp volume.</p>
<p>4.	Cinder-scheduler thực hiện quá trình báo cáo sẽ đưa thông báo ra khỏi hàng đợi , tạo danh sách các ứng viên dựa trên trạng thái hiện tại và yêu cầu tạo volume theo tiêu chí (kích thước, vùng sẵn có, loại volume (bao gồm cả thông số kỹ thuật bổ sung)).</p>
<p>5.	Cinder-volume thực hiện quá trình đọc message phản hồi từ cinder-scheduler từ hàng đợi. Lặp lại qua các danh sách ứng viên bằng các gọi backend driver cho đến khi thành công.</p>
<p>6.	NetApp Cinder tạo ra volume được yêu cầu thông qua tương tác với hệ thống lưu trữ con (phụ thuộc vào cấu hình và giao thức).</p>
<p>7.	Cinder-volume thực hiện quá trình thu thập dữ liệu và metadata volume và thông tin kết nối để trả lại thông báo đến AMQP.</p>
<p>8.	Cinder-api thực hiện quá trình đọc message phản hồi từ hàng đợi và đáp ứng tới client.</p>
<p>9.	Client nhận được thông tin bao gồm trạng thái của yêu cầu tạo, Volume UUID, ....</p>
<h4>5.2 Workflow của Cinder khi attact Volume </h4>
<img src="https://github.com/anhict/images/blob/master/15.png?raw=true">
<p>1.	Client yêu cầu attach volume thông qua Nova REST API (Client có thể sử dụng tiện ích CLI của python-novaclient)</p>
<p>2.	Nova-api thực hiện quá trình xác nhận yêu cầu và thông tin người dùng. Một khi đã được xác thực, gọi API Cinder để có được thông tin kết nối cho volume được xác định.</p>
<p>3.	Cinder-api thực hiện quá trình xác nhận yêu cầu hợp lệ và thông tin người dùng hợp lệ . Một khi được xác nhận , một message sẽ được gửi đến người quản lý volume thông qua AMQP.</p>
<p><p>4.	Cinder-volume tiến hành đọc message từ hàng đợi , gọi Cinder driver tương ứng với volume được gắn vào.</p>
<p>5.	NetApp Cinder driver chuẩn bị Cinder Volume chuẩn bị cho việc attach (các bước cụ thể phụ thuộc vào giao thức lưu trữ được sử dụng).</p>
<p>6.	Cinder-volume thưc hiện gửi thông tin phản hồi đến cinder-api thông qua hàng đợi AMQP.</p>
<p>7.	Cinder-api thực hiện quá trình đọc message phản hồi từ cinder-volume từ hàng đợi; Truyền thông tin kết nối đến RESTful phản hồi gọi tới NOVA.</p>
<p>8.	Nova tạo ra kết nối với bộ lưu trữ thông tin được trả về Cinder.</p>
<p>9.	Nova truyền volume device/file tới hypervisor , sau đó gắn volume device/file vào máy ảo client như một block device thực thế hoặc ảo hóa (phụ thuộc vào giao thức lưu trữ).</p>

<p><strong> •	Có 2 loại volume: </strong></p>
<ul>
<li> -	Bootable </li>
<li> -	Non-bootable </li>
</ul>
