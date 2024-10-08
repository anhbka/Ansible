# 1. Overview Heat
<ul>Heat là dự án chính trong OpenStack Orchestration. Nó triển khai orchestration engine để khởi chạy nhiều ứng dụng cloud tổng hợp dựa trên các template ở dạng tệp text có thể được xử lý như code. Định dạng Heat template đang phát triển, nhưng Heat cũng nỗ lực để cung cấp khả năng tương thích với định dạng template CloudFormation AWS, do đó nhiều template CloudFormation hiện có có thể được khởi chạy trên OpenStack. Heat cung cấp cả OpenStack-native REST API và API truy vấn tương thích CloudFormation.</ul>
<ul>Heat là một dịch vụ phối hợp các ứng dụng cloud tổng hợp dựa trên các template. Nó hiện hỗ trợ định dạng template CloudFormation của Amazon và cũng hỗ trợ định dạng template của riêng Heat. Việc sử dụng các template đơn giản hóa việc định nghĩa và triển khai cơ sở hạ tầng, dịch vụ và ứng dụng phức tạp. Template hỗ trợ một loại tài nguyên phong phú, bao gồm không chỉ các cơ sở hạ tầng chung, bao gồm máy tính, mạng, lưu trữ, cũng bao gồm tài nguyên tiên tiến như Ceilometer's alerts, Sahara's clusters, và Trove's instances.
OpenStack Heat là một dự án đầy hứa hẹn sử dụng các template để tự động hóa việc quản lý tài nguyên trong trung tâm dữ liệu.Tức là, người dùng định nghĩa một template tài nguyên có thể đọc được (json hoặc yaml) và Heat có trách nhiệm triển khai các tài nguyên này trong openstack.</ul>


## 2. Các thành phần của Heat
<ul>Heat bao gồm các thành phần sau:
<li>Heat Client:Heat Client là một công cụ CLI được cung cấp bởi project Heat, tương tự như client của các project khác. </li>
<li>Heat-api: Tương tự như nova-api, cung cấp API tiếp nhận và phản hồi các request.Request của người dùng tới API được xử lý bởi heat-api và cuối cùng được chuyển đến Heat-engine thông qua RPC để xử lý tiếp.</li>
<li>The heat-api-cfn: Thành phần heat-api-cfn cung cấp API truy vấn Amazon, vì vậy nó có thể được hoàn toàn tương thích với CloudFormation của Amazon. Yêu cầu API tương tự như heat-api. Sau khi xử lý, nó được truyền cho RPC thông qua heat và được xử lý tiếp.</li>
<li>Heat-engine: heat-engine là module cốt lõi trong Heat, module xử lý kinh doanh hợp lý chính. Module này cuối cùng hoàn thành việc tạo và triển khai ứng dụng.</li>
<li>Heat-cfntools: Đây là một công cụ riêng biệt, mã không có trong dự án Heat, nó có thể được tải xuống một cách riêng biệt. Công cụ này chủ yếu được sử dụng để hoàn thành các tác vụ cấu hình hoạt động bên trong instance. Khi tạo một máy ảo, bạn cần phải cài đặt công cụ heat-cfntools.</li></ul>

<strong>* Heat template </strong>
<p>Templates là định nghĩa thời gian thiết kế của các tài nguyên sẽ tạo nên stack</p>


`HOT : Heat Orchestration Template`

Thuật ngữ cơ bản trong Heat

1. Stack. Ngăn xếp là đơn vị cơ bản trong CloudFormation quản lý một tập hợp các tài nguyên. Một stack thường tương ứng với một ứng dụng. Trong ví dụ được đưa ra bởi bản thân Heat, WordPress là một ứng dụng web có sử dụng tệp cấu hình của nó để tạo một thể hiện stack.

2. Resources.. Một stack có thể có nhiều tài nguyên và tài nguyên là trừu tượng hóa các dịch vụ cơ bản CPU, memory, disk, network... tất cả có thể được coi là tài nguyên. Sẽ có sự phụ thuộc giữa các resources và resources. Nhiệt tự động giải quyết các phụ thuộc khi tạo stack, tạo resources theo thứ tự. Bắt đầu từ Havana, Heat có thể tạo ra các resources không phụ thuộc song song.

<p>Heat hiện hỗ trợ các template theo hai định dạng, một là template CFN dựa trên định dạng JSON; khác là template HOT dựa trên định dạng YAML. Template CFN chủ yếu nhằm duy trì khả năng tương thích với AWS. Template HOT thuộc sở hữu của Heat và các loại tài nguyên phong phú hơn, có thể phản hồi tốt hơn các tính năng của Heat.</p>
<p>Một Template HOT điển hình bao gồm các yếu tố sau:<p>
<li>Template version:Trường bắt buộc, chỉ định template version tương ứng và Heat sẽ kiểm tra theo phiên bản.</li>
<li>Parameter list:  Đây là các giá trị thuộc tính phải được truyền khi chạy template Heat. Trong HOT.</li>
<li>Resource list: Đây là các chi tiết về ngăn xếp cụ thể của bạn. Đây là những đối tượng sẽ được tạo ra hoặc được sửa đổi khi template chạy. Tài nguyên có thể là Instances, Volumes, Security Groups, Floating IPs hoặc bất kỳ số lượng đối tượng nào trong OpenStack.</li>
<li>Output list: Tùy chọn, đề cập đến thông tin được hiển thị bởi Stack được tạo, có thể được sử dụng cho người dùng hoặc có thể được sử dụng làm đầu vào cho Stack khác.</li>
</ul>
<p>Sự khác biệt giữa template CFN và template HOT, bao gồm các loại tài nguyên được hỗ trợ, nằm ngoài phạm vi của bài viết này. Bài viết này chủ yếu sẽ sử dụng template HOT. Tên đầy đủ của template HOT là Heat Orchestration, là trọng tâm của sự phát triển của Nhiệt.</p>
<p>Heat cung cấp một điều phối tổng thể các template để mô tả một ứng dụng đám mây bằng cách thực hiện các API OpenStack call thích hợp để tạo ra các ứng dụng cloud đang chạy.</p>
<p>Heat template  mô tả cơ sở hạ tầng cho ứng dụng cloud trong các tệp text có thể đọc và ghi được bởi humans và có thể được quản lý bằng các công cụ kiểm soát phiên bản.Template chỉ định mối quan hệ giữa các tài nguyên (ví dụ: khối lượng này được kết nối với máy chủ này). Điều này cho phép Heat gọi ra các API OpenStack để tạo tất cả cơ sở hạ tầng của bạn theo đúng thứ tự để khởi chạy hoàn toàn ứng dụng của bạn.
Phần mềm này tích hợp các thành phần khác của OpenStack. Các template cho phép tạo ra hầu hết các loại tài nguyên OpenStack (instances, floating ips, volumes,security groups, users, v.v.), cũng như một số chức năng nâng cao hơn như khả năng sẵn sàng cao, tự động tính toán template và ngăn xếp lồng nhau.</p>
<p>Heat chủ yếu quản lý cơ sở hạ tầng, nhưng các template tích hợp tốt với các công cụ quản lý cấu hình phần mềm như Puppet và Ansible.</p>

<strong>* Heat orchestration of software cấu hình và triển khai </strong>
<p>Heat cung cấp nhiều loại tài nguyên khác nhau để hỗ trợ việc dàn dựng cấu hình và triển khai phần mềm, như được liệt kê dưới đây:</p>
<p>OS :: Heat :: CloudConfig: Cấu hình khi khởi động VM khởi động, được tham chiếu bởi OS :: Nova :: Server</p>
<p>OS :: Heat :: SoftwareConfig: mô tả cấu hình phần mềm</p>
<p>OS :: Heat :: SoftwareDeployment: Thực hiện triển khai phần mềm</p>
<p>OS :: Heat :: SoftwareDeploymentGroup: Thực hiện triển khai phần mềm trên một bộ máy ảo</p>
<p>OS :: Heat :: SoftwareComponent: cho các phần vòng đời khác nhau của phần mềm, cấu hình phần mềm mô tả tương ứng</p>
<p>OS :: Heat :: StructuredConfig: Tương tự như OS :: Heat :: SoftwareConfig, nhưng sử dụng Map để biểu diễn cấu hình</p>
<p>OS :: Heat :: StructuredDeployment: Thực thi cấu hình tương ứng với OS :: Heat :: StructuredConfig</p>
<p>OS :: Heat :: StructuredDeploymentsGroup: Thực hiện cấu hình tương ứng với OS :: Heat :: StructuredConfig cho một nhóm máy ảo</p>


### 3. Workflow
+ Heat cung cấp hai loại giao diện, bao gồm giao diện dựa trên web được tích hợp vào bảng điều khiển OpenStack và cũng là giao diện dòng lệnh (CLI), có thể được sử dụng từ bên trong vỏ Linux.

+ Các giao diện sử dụng heat-api để gửi lệnh đến Heat engine thông qua messaging service (ví dụ RabbitMQ). Một dịch vụ đo sáng như Ceilometer hoặc CloudWatch API được sử dụng để giám sát hiệu suất của các tài nguyên trong stack. Các dịch vụ monitoring/metering này được sử dụng để kích hoạt các hành động khi đạt đến một ngưỡng nhất định. Một ví dụ về điều này có thể tự động khởi chạy một máy chủ web dư thừa phía sau bộ cân bằng tải khi tải CPU trên máy chủ web chính đạt trên 90%.

<img src="https://github.com/anhict/Openstack-Heat/blob/master/images/heat1.png">

<li>Heat-client : Chấp nhận các lệnh, tham số và template đầu vào ( URL , đường dẫn tệp hoặc dữ liệu), xử lý thông tin và gửi một yêu cầu REST API tới dịch vụ heat-api.</li>


<li>Heat-api: chấp nhận yêu cầu, đọc trong thông tin template và gửi nó đến heat-engine bằng cách sử dụng rpc request .


<li>Heat-engine: phân tích dữ liệu template và gọi các plugin tài nguyên khác nhau.</li>


<li>Resource -plugins  các plugin tài nguyên khác nhau gửi các lệnh tới openstack service thông qua openstack client.</li>


***Simple process***


Bây giờ một mô tả ngắn gọn của Heat là toàn bộ quá trình nhanh chóng tạo ra một ứng dụng phức tạp và hoàn thành công việc cấu hình cuối cùng.

Trong bước đầu tiên, bạn cần phải cài đặt các công cụ cloud-init và heat-cfntools trong machine image. Cloud-init trước đây được sử dụng để xử lý một số cấu hình ban đầu của các virtual machine instances, chủ yếu để hoàn thành các công việc sau:

+ Đặt ngôn ngữ mặc định.

+ Đặt tên máy chủ.

+ Generate ssh private keys
	
+ Thêm các keys ssh vào tệp .ssh / authorized_keys của người dùng để tạo điều kiện đăng nhập người dùng.

+ Có thể xem các tùy chọn cụ thể cho Dữ liệu người dùng thông qua liên kết này. https://help.ubuntu.com/community/CloudInit

***Create an app***

+ Gọi heat-api để tạo ra, ví dụ heat stack-create myApplication.

+ Heat-engine tạo ra dữ liệu data mà cloud-init sẽ sử dụng.

+ Heat-engine gọi nova-api, tạo ra virtual machine instance và truyền dữ liệu được sử dụng bởi cloud-init với nova-api call.

+ Nova chọn một node compute để tạo một virtual machine instance, sử dụng cloud-init.

+ Khi virtual machine instance khởi động, nó sẽ thực thi kịch bản lệnh cloud-init, sẽ thực hiện như sau: tải xuống dữ liệu từ nova metadata server vào thư mục  /var/lib/cloud 
chạy các lệnh khác của cloud-init như resize kích thước hệ thống tệp gốc, set hostname ... chạy user's script, script nằm trong thư mục /var/lib/cloud/data/cfn-userdata, các tập lệnh này có thể là bất kỳ loại tập lệnh nào (chẳng hạn như bash, python, v.v.) và phải gọi cfn-init.


+ Cfn-init  tải  /var/lib/cloud/data/cfn-init-data (copy  Metadata->AWS::CloudFormation::Init->Config attribute from the AWS template) và có thể  install packages, setup users & Groups, create files ...






























Tài liệu tham khảo:
https://blog.csdn.net/yeasy/article/details/38678817
https://blog.csdn.net/u010305706/article/details/54377552
https://github.com/yeasy/tech_writing/blob/master/OpenStack/OpenStack%20Heat%E4%BB%A3%E7%A0%81%E5%88%86%E6%9E%90.pdf
