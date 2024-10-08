<h1> Keystone </h1>
<h3> 1.	Vai trò của project Keystone </h3>
<p>
- Xác thực user và vấn đề token để truy cập vào các dịch vụ.
 </p>
 <p>
- Lưu trữ user và người thuê cho vai trò kiểm soát truy cập (role-based access control (RBAC).
  </p>
<p>
- Cung cấp catalog của dịch vụ trên cloud.
</p>
<p>
- Tạo các chính sách giữa user và dịch vụ.
  </p>
<h3> 2.	Chức năng chính của Keystone </h3>
<p>
-	Identity : Nhận diện user đang kết nối đến tài nguyên Cloud, identity thường được hiểu là User. mô hình OpenStack nhỏ, identity của user thường được lưu trữ trong database của keystone. Đối với những mô hình lớn cho doanh nghiệp thì 1 external Identity Provider thường được sử dụng. </p>
  <p>
- Authentication : Là quá trình xác thực những thông tin dùng để nhận định user, keystone có tính pluggable tức là nó có thể liên kết với những dịch vụ xác thực người dùng khác như LDAP hoặc Active Directory. OpenStack dựa rất nhiều vào tokens để xác thực và keystone chính là dịch vụ duy nhất có thể tạo ra tokens.Token có giới hạn thời gian sử dụng khi hết hạn sẽ được cấp token mới.
  </p>
  <p>
-	Access Management (Authorization): Access Management hay còn được gọi là Authorization là quá trình xác định những tài nguyên mà user được phép truy cập tới. Trong OpenStack, keystone kết nối users với những Projects hoặc Domains bằng cách gán role cho user vào những project hoặc domain ấy.
</p>
<h3> 3.	Các thành phần </h3>
Keystone architecture:
<img src="https://camo.githubusercontent.com/3a05d4ab46d59f24ee3813b7c1760a796d0f41b7/687474703a2f2f692e696d6775722e636f6d2f693063795a30362e706e67">
<p><li>Keystone được tổ chức như một nhóm các dịch vụ nội bộ tiếp xúc trên một hoặc nhiều thiết bị đầu cuối.</li></p>

<p>- Identity : các dịch vụ cung cấp xác thực xác nhận chứng chỉ và dữ liệu về người sử dụng, các tenant và role, cũng như bất kì matadata nào liên quan.</p>
- Token : Xác nhận dịch vụ và quản lý sử dụng cho các Token. Thẩm định yêu cầu một khi thông tin người dùng đã được xác minh.
<p>- Catalog : dịch vụ catalog cung cấp một enpoint registry sử dụng cho các enpoint discovery.</p>

<p>- Policy : Các dịch vụ Policy cung cấp một cơ cấu ủy quyền dựa trên các nguyên tắc.</p>
<p><li>Mỗi dịch vụ có thể được cấu hình để sử dụng một backend, cho phép Keystone phù hợp với một hay nhiều môi trường và nhu cầu. Các backend cho mỗi dịch vụ được quy định tại file keystone.conf.</li></p>
<p><li>KVS backend : một giao diện backend đơn giản có nghĩa là để được tiếp tục phụ trợ về bất cứ điều gì bạn có thể tra cứu khóa chính.
<p><li>SQL backend : một SQL dựa trên backend sử dụng SQLAlchemy để lưu trữ dữ liệu liên tục.</li></p>
<p><li>PAM backend : backend sử dụng PAM của hệ thống hiện tại của dịch vụ để xác thực, cung cấp một mối quan hệ một - một giữa người sử dụng và người thuê.</li></p>
<p><li>LDAP backend : Các LDAP backend lưu trữ user và tenants riêng biệt ở các subtrees</li></p>
<p><li>Templated backend : Một mẫu đơn giản dùng để cấu hình Keystone.</li></p>
<h4> Identity: </h4>
<p>- SQL: Sử dụng trong môi trường kiểm thử và phát triển với OpenStack. Dùng với các tài khoản đặc biệt (service user - nova, glance, etc.)</p>
<p>- LDAP : Sử dụng trong môi trường doanh nghiệp.</p>
<p>- Sử dụng chỉ LDAP nếu có khả năng tạo service account trong LDAP</p>
<h3> 3.1 UUID token </h3>
<p>-Kích thước nhỏ gọn, là chuỗi ngẫu nhiên 32 ký tự</p>
<p>-Tạo nên từ các chỉ số hệ thập lục phân</p>
<p>-Tokens URL thân thiện và an toàn khi gửi đi trong môi trường non-binary.</p>
<p>-Lưu trữ trong hệ thống backend (như database) bề vững để sẵn sàng cho mục đích xác thực</p>
<p>-UUID không bị xóa trong hệ thống lưu trữ nhưng sẽ bị đánh dấu là "revoked" (bị thu hồi) thông qua DELETE request với token ID tương ứng.
Do kích thước cực nhỏ nên dễ dàng sử dụng khi truy cập Keystone qua 1 cURL command</p>
<p><h4><li> Token workflow generation  </li></h4></p>
<img src="https://camo.githubusercontent.com/e57e54d30d8747f93ca6edb1bf9370dcb8cfc842/687474703a2f2f692e696d6775722e636f6d2f495a6a357931622e706e67">
<li>Workflow tạo UUID token diễn ra như sau:</li>
<p>- User request tới keystone tạo token với các thông tin: user name, password, project name</p>
<p>-Chứng thực user, lấy User ID từ backend LDAP (dịch vụ Identity)</p>
<p>-Chứng thực project, thu thập thông tin Project ID và Domain ID từ Backend SQL (dịch vụ Resources)</p>
<p>-Lấy ra <strong> Roles </strong> từ Backend trên Project hoặc Domain tương ứng trả về cho user, nếu user không có bất kỳ roles nào thì trả về <strong>Failure</strong> (dịch vụ Assignment)</p>
<p>-Thu thập các <strong> Services </strong>và các <strong> Endpoints </strong> của các service đó (dịch vụ Catalog)</p>
<p>-Tổng hợp các thông tin về Identity, Resources, Assignment, Catalog ở trên đưa vào Token payload, tạo ra token sử dụng hàm <strong> uuid.uuid4().hex </strong> </p>
<p>-Lưu thông tin của Token và SQL/KVS backend với các thông tin: TokenID, Expiration, Valid, UserID, Extra</p>

<h3> 3.2	PKI token </h3>
<p> - Kích thước tương đối lớn - 8KB </p>
<p> - Chứa nhiều thông tin: thời điểm khởi tạo, thời điểm hết hạn, user id, project, domain, role gán cho user, danh mục dịch vụ nằm trong payload. </p>
<p>- Muốn gửi token qua HTTP, JSON token payload phải được mã hóa base64 với 1 số chỉnh sửa nhỏ. Cụ thể, Format=CMS+[zlib] + base64. Ban đầu JSON payload phải được ký sử dụng một khóa bất đối xứng (private key), sau đó được đóng gói trong CMS (cryptographic message syntax - cú pháp thông điệp mật mã). Với PKIz format, sau khi đóng dấu, payload được nén lại sử dụng trình nén zlib. Tiếp đó PKI token được mã hóa base64 và tạo ra một URL an toàn để gửi token đi. </p>
<p>- Các OpenStack services cache lại token này để đưa ra quyết định ủy quyền mà không phải liên hệ lại keystone mỗi lần có yêu cầu ủy quyền dịch vụ cho user. </p>
<p>- Kích thước của 1 token cơ bản với single endpoint trong catalog lên tới 1700 bytes. Với các hệ thống triển khai lớn nhiều endpoint và dịch vụ, kích thước của PKI token có thể vượt quá kích thước giới hạn cho phép của HTTP header trên hầu hết các webserver(8KB). Thực tế khi sử dụng chuẩn token PKIz đã nén lại nhưng kích thước giảm không đáng kể (khoảng 10%).</p>
<p>- PKI và PKIz tokens tuy rằng có thể cached nhưng chúng có nhiều hạn chế</p>
<p>+	Khó cấu hình để sử dụng </p>
<p>+	Kích thước quá lớn làm giảm hiệu suất web </p>
<p>+	Khó khăn khi sử dụng trong cURL command. </p>
<p><h4><li> Token workflow generation  </li></h4></p>
<img src="https://camo.githubusercontent.com/6ed01f937ed0581126fcb0b49eba2954437d14cc/687474703a2f2f692e696d6775722e636f6d2f376677565942552e706e67">
<p><strong>Tiến trình tạo ra PKI token:</strong></p>
<p><li>	Người dùng gửi yêu cầu tạo token với các thông tin: User Name, Password, Project Name</li></p>
<p><li>	Keystone sẽ chứng thực các thông tin về Identity, Resource và Asssignment (định danh, tài nguyên, assignment)</li></p>
<p><li>	Tạo token payload định dạng JSON </li></p>
<p><li>	"Ký" lên JSON payload với Signing Key và Signing Certificate , sau đó được đóng gói lại dưới định dang CMS (cryptographic message syntax - cú pháp thông điệp mật mã)</li></p>
<p><li>	Bước tiếp theo, nếu muốn đóng gói token định dạng PKI thì convert payload sang UTF-8, convert token sang một URL định dạng an toàn. Nếu muốn token đóng gói dưới định dang PKIz, thì phải nén token sử dụng zlib, tiến hành mã hóa base64 token tạo ra URL an toàn, convert sang UTF-8 và chèn thêm tiếp đầu ngữ "PKIZ" </li></p>
<p><li>	Lưu thông tin token vào Backend (SQL/KVS) </li></p>


<h4>3.3	Fernet token.</h4>
<p>- Độ dài 255 ký tự (lớn hơn UUID nhưng nhỏ đáng kể so với PKI và PKIz)</p>
<p>- Chứa đủ thông tin cần thiết mà không phải lưu token trong database: user id, project id, thời gian -expire, etc. </p>
<p>- Dựa trên phương pháp xác thực mật mã học - Fernet </p>
<p>- Sử dụng mã hóa khóa đối xứng. </p>
<h4> Fernet key: </h4>

<p><li><strong>Fernet Keys lưu trữ trong /etc/keystone/fernet-keys:</strong></li></p>
	<p> -  Mã hóa với Primary Fernet Key </p>
	<p> - Giải mã với danh sách các Fernet Key </p> 

<p><li><strong> Có ba loại file key: </strong></p></li>
<p> -  Loại 1 - <strong> Primary Key </strong> sử dụng cho cả 2 mục đích mã hóa và giải mã fernet tokens. Các key được đặt tên theo số nguyên bắt đầu từ 0. Trong đó Primary Key có chỉ số cao nhất. </p>
<p> -  Loại 2 - <strong> Secondary Key</strong> chỉ dùng để giải mã. -> Lowest Index < Secondary Key Index < Highest Index </p>
<p> - <strong> Stagged Key </strong> - tương tự như secondary key trong trường hợp nó sử dụng để giải mã token. Tuy nhiên nó sẽ trở thành Primary Key trong lần luân chuyển khóa tiếp theo. Stagged Key có chỉ số 0. </p>

<p><li> <strong>Fernet Key format</strong>: fernet key là một chuẩn mã hóa base64 của Signing Key (16 bytes) và Encrypting Key (16 bytes): Signing-key ‖ Encryption-key </p></li>

<h4>3.4 Fernet Key rotation </h4>
<img src="https://camo.githubusercontent.com/b96ca24929306a849d647f872d6eb95f95fd9e92/687474703a2f2f692e696d6775722e636f6d2f4e68393445734f2e706e67">
<p>Giả sử triển khai hệ thống cloud với keystone ở hai bên us-west và us-east. Cả hai repo này đều được thiết lập với 3 fernet key như sau:</p>
<pre><code>
$ ls /etc/keystone/fernet-keys
0 1 2
</code></pre>
<p>Ở đây 2 sẽ trở thành Primary Key để mã hóa fernet token. Fernet tokens có thể được mã hóa sử dụng một trong 3 key theo thứ tự là 2, 1, 0. Giờ ta quay vòng fernet key bên us-west, repo bên này sẽ đươc thiết lập như sau:</p>
<pre><code>
$ ls /etc/keystone/fernet-keys
0 1 2 3
</code></pre>
<p>Với cấu hình như trên, bên us-west, 3 trở thành Primary Key để mã hóa fernet token. Khi keystone bên us-west nhận token từ us-east (mã hóa bằng key 2), us-west sẽ xác thực token này, giải mã bằng 4 key theo thứ tự 3, 2, 1, 0. Keystone bên us-east nhận fernet token từ us-west (mã hóa bằng key 3), us-east xác thực token này vì key 3 bên us-west lúc này trở thành staged key (0) bên us-east, keystone us-east giải mã token với 3 key theo thứ tự 2, 1, 0. 
Có thể cấu hình giá trị max_active_keys trong file /etc/keystone.conf để quy định tối đa số key tồn tại trong keystone. Nếu số key vượt giá trị này thì key cũ sẽ bị xóa.</p>

<p><h4><li> Token workflow generation  </li></h4></p>
<strong>Với key và message nhận được, quá trình tạo fernet token như sau:</strong>

<p><li>1. Ghi thời gian hiện tại vào trường timestamp </p></li>
<p><li>2. Lựa chọn một IV duy nhất </p></li>
<p><li>3. Xây dựng ciphertext:</p></li>
<p>- Padd message với bội số là 16 bytes (thao tác bổ sung một số bit cho văn bản trong mã hóa khối AES) </p>
<p>- Mã hóa padded message sử dụng thuật toán AES 128 trong chế độ CBC với IV đã chọn và encryption-key được cung cấp </p>
<p> 4. Tính toán trường HMAC theo mô tả trên sử dụng signing-key mà người dùng được cung cấp </p>
<p> 5. Kết nối các trường theo đúng format token ở trên </p>
<p> 6. Mã hóa base64 toàn bộ token </p>
<img src="https://camo.githubusercontent.com/1fb17b3cbcd3f83f27065190b159f57879da39d6/687474703a2f2f692e696d6775722e636f6d2f7234594677564e2e706e67">
<p><li> Xác thực và khôi phục token </p></li>
+ Với một key và token, để xác thực token hợp lệ hay không và khôi phục lại thông điệp ban đầu, thực hiện các bước sau:


<p> 1. base64url decode token </p>
<p>2. Đảm bảo byte đầu tiên của token là 0x80 </p>
<p>3. Nếu đặt time-to-live cho token thì phải đảm bảo timestamp hợp lệ. (không quá xa so với hiện tại) </p>
<p>4. Tính toán lại HMAC từ các trường khác và signing-key mà người dùng được cung cấp. </p>
<p>5. Đảm bảo HMAC tính toán lại phải giống với giá trị trường HMAC trong token </p>
<p>6. Giải mã ciphertext sử dụng AES 128 trong chế độ CBC với giá trị IV đã ghi lại cùng với encryption-key được cung cấp </p>
<p>7. Unpadd plaintext đã giải mã, thu lại thông điệp ban đầu </p>

<h3> 4.	Đặc điểm từng loại token.</h3>
<strong> Bảng so sánh 4 kiểu token với các thông số: </strong>
<img src="https://github.com/anhict/images/blob/master/8.png">

<h4> 4.1	UUID tokens:</h4>
<p> - Kích thước nhỏ: chuỗi 32 ký tự .</p>
<p>- Dễ dàng sử dụng(có thể sử dụng cURL).</p>
<p>- Chỉ mang đủ thông tin xác thực, không đủ thông tin ủy quyền. Do đó khi gửi request kèm token UUID tới các OpenStack Services, các dịch vụ này buộc phải hỏi về Keystone để xác thực. Điều đó làm cho Keystone trở thành nút thắt cổ chai.</p>

<h4> 4.2	PKI tokens: </h4>
<p> -  Chuẩn token chứa đủ thông tin để xác thực và ủy quyền cũng như các service catalog để người dùng truy cập các dịch vụ. </p>
<p>- Token được ký danh và dịch vụ có thể cache lại token, sử dụng cho tới khi token hết hạn hoặc bị thu hồi.</p>
<p>- Giảm traffic tới keystone nhưng kích thước lớn (8KB), khó khăn để gửi trong HTTP header vì nhiều webserver không xử lý được HTTP header 8KB trừ khi cấu hình lại </p>
<p>- Khó sử dụng bằng cURL command </p>
<h>4.3	Fernet tokens: phát hành từ phiên bản Kilo. Một số đặc điểm nổi bật </h4>
<p>- Kích thước nhỏ - 255 bytes </p>
<p>- Chứa đủ thông tin cho tiến trình authorization cục bộ tại các OpenStack services khi người dùng request tới. Keystone không phải lưu token trong database. Trong các chuẩn token cũ, Keystone phải lưu token trong database dẫn tới việc fill up, làm giảm hiệu năng của Keystone. </p>

















