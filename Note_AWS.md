```
AWS Snowball: Thích hợp cho việc di chuyển dữ liệu lớn đến AWS với chi phí thấp và dễ sử dụng.
AWS Snowball Edge: Phù hợp cho các trường hợp cần xử lý dữ liệu tại chỗ trước khi gửi lên AWS.
AWS Snowmobile: Dành cho các tổ chức cần di chuyển khối lượng dữ liệu cực lớn, chẳng hạn như toàn bộ trung tâm dữ liệu.
```

```
AWS Comprehend: Chuyên về phân tích ngôn ngữ tự nhiên.
AWS Kendra: Tập trung vào tìm kiếm thông tin.
AWS Lex: Dùng để tạo chatbot.
AWS Polly: Chuyển đổi văn bản thành giọng nói.
AWS Rekognition: Nhận diện hình ảnh và video.
AWS Textract: Nhận diện văn bản từ hình ảnh.
AWS Transcribe: Chuyển đổi giọng nói thành văn bản.
AWS Translate: Dịch ngôn ngữ.
AWS Forecast: Dự đoán xu hướng dữ liệu.
AWS Fraud Detector: Phát hiện gian lận.
AWS SageMaker: Cung cấp nền tảng cho machine learning và AI.
```

```
S3 File Gateway:
Mục đích: Cung cấp khả năng lưu trữ tệp trên Amazon S3, cho phép ứng dụng truy cập tệp như thể chúng đang được lưu trữ cục bộ.
Trường hợp sử dụng: Thích hợp cho các ứng dụng web, phân tích dữ liệu, và lưu trữ tệp dài hạn.
FSx File Gateway:
Mục đích: Cung cấp khả năng truy cập tệp trên Amazon FSx, đặc biệt dành cho các ứng dụng Windows.
Trường hợp sử dụng: Dùng cho các ứng dụng doanh nghiệp yêu cầu chia sẻ tệp thông qua SMB hoặc NFS.
Tape Gateway:
Mục đích: Giả lập các băng từ vật lý, cho phép các ứng dụng sao lưu sử dụng VTL để lưu trữ dữ liệu trên S3.
Trường hợp sử dụng: Thích hợp cho các tổ chức cần lưu trữ dữ liệu sao lưu lâu dài.
Volume Gateway:
Mục đích: Cung cấp lưu trữ khối cho các ứng dụng, cho phép tạo snapshot và quản lý dữ liệu dễ dàng.
Trường hợp sử dụng: Thích hợp cho các ứng dụng yêu cầu lưu trữ khối và khả năng sao lưu.
```

```
Stored Volume Gateway:
Mô hình: Tất cả dữ liệu được lưu trữ cục bộ, giúp truy cập nhanh chóng.
Sao lưu: Dễ dàng và nhanh chóng, phù hợp cho các ứng dụng yêu cầu độ trễ thấp.
Cached Volume Gateway:
Mô hình: Chỉ lưu trữ dữ liệu thường xuyên truy cập cục bộ, phần còn lại nằm trên S3.
Tính linh hoạt: Giúp tiết kiệm chi phí lưu trữ và mở rộng dễ dàng hơn.
```

```
Snowcone: 8 TB
Snowball Edge Compute Optimized: 42 TB
Snowball Edge Storage Optimized: 80 TB
Snowmobile: Lên đến 100 PB
```

```
Route 53 Resolver
Inbound and Outbound Endpoints:
Inbound Endpoints: Cho phép các truy vấn DNS từ bên ngoài đến các tài nguyên trong VPC.
Outbound Endpoints: Cho phép các tài nguyên trong VPC thực hiện truy vấn DNS đến các máy chủ DNS bên ngoài.
DNS Forwarding:
Hỗ trợ chuyển tiếp các truy vấn DNS đến máy chủ DNS khác, cả trong AWS và trên-premises.
Rule-Based Forwarding:
Tạo các quy tắc chuyển tiếp để định hướng các truy vấn dựa trên tên miền.
Hybrid Cloud Support:
Tích hợp giữa môi trường on-premises và AWS, cho phép quản lý DNS cho cả hai.
Logging and Monitoring:
Tích hợp với Amazon CloudWatch và CloudTrail để theo dõi và ghi lại các truy vấn DNS.
DNSSEC Support:
Hỗ trợ DNSSEC để đảm bảo tính xác thực của các phản hồi DNS.
```

```
Route 53 Hosted Zone
Public and Private Hosted Zones:
Public Hosted Zones: Quản lý DNS cho các tên miền mà bạn muốn công khai trên Internet.
Private Hosted Zones: Quản lý DNS cho các tên miền chỉ có thể truy cập từ các tài nguyên trong VPC.
DNS Record Types:
Hỗ trợ nhiều loại bản ghi DNS, bao gồm A, AAAA, CNAME, MX, TXT, và nhiều loại khác.
Alias Records:
Cho phép bạn tạo bản ghi tên miền mà không cần một địa chỉ IP cụ thể, hỗ trợ các dịch vụ AWS như S3 và CloudFront.
Integration with AWS Services:
Tích hợp sâu với các dịch vụ AWS khác để tối ưu hóa hiệu suất và khả năng quản lý.
Health Checks:
Theo dõi tình trạng của các endpoint và tự động chuyển hướng lưu lượng nếu một endpoint không hoạt động.
Traffic Flow:
Cung cấp khả năng quản lý lưu lượng truy cập phức tạp thông qua các chính sách định tuyến.
```




