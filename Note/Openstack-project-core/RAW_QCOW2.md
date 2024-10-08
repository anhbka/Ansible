### 1. File raw

* Là định dạng file image phi cấu trúc

* Khi người dùng tạo mới một máy ảo có disk format là raw thì dung lượng của file disk sẽ đúng bằng dung lượng của ổ đĩa máy ảo bạn đã tạo.

* Định dạng raw là hình ảnh theo dạng nhị phân (bit by bit) của ổ đĩa.

* Mặc định khi tạo máy ảo với virt-manager hoặc không khai báo khi tạo VM bằng virt-install thì định dạng ổ đĩa sẽ là raw. Hay nói cách khác, raw chính là định dạng mặc định của QEMU.

### 2. File qcow2

* Qcow là một định dạng tập tin cho đĩa hình ảnh các tập tin được sử dụng bởi QEMU , một tổ chức màn hình máy ảo . Nó viết tắt của "QEMU Copy On Write " và sử dụng một chiến lược tối ưu hóa lưu trữ đĩa để trì hoãn phân bổ dung lượng lưu trữ cho đến khi nó thực sự cần thiết. Các tập tin trong định dạng qcow có thể chứa một loạt các image thường được gắn liền với khách cụ thể các hệ điều hành . Hai phiên bản của các định dạng tồn tại: qcow, và qcow2, trong đó sử dụng các .qcow và .qcow2 mở rộng tập tin, tương ứng.

* Qcow2 là một phiên bản cập nhật của định dạng qcow, nhằm để thay thế nó. Khác biệt với bản gốc là qcow2 hỗ trợ nhiều snapshots thông qua một mô hình mới, linh hoạt để lưu trữ ảnh chụp nhanh. Khi khởi tạo máy ảo mới sẽ dựa vào disk này rồi snapshot thành một máy mới.

* Qcow2 hỗ trợ copy-on-write với những tính năng đặc biệt như snapshot, mã hóa ,nén dữ liệu...

* Các tập tin với định dạng này có thể phát triển khi dữ liệu được thêm vào. Điều này cho phép kích thước tệp nhỏ hơn hình ảnh đĩa thô , phân bổ toàn bộ không gian hình ảnh vào tệp, ngay cả khi các phần của nó trống. Điều này đặc biệt hữu ích cho các hệ thống tập tin không hỗ trợ các lỗ hổng, chẳng hạn như FAT32.

* Định dạng qcow cũng cho phép lưu trữ các thay đổi được thực hiện với một hình ảnh cơ sở chỉ đọc trên một tập tin qcow riêng biệt bằng cách sử dung copy on write . Tập tin qcow mới này chứa đường dẫn đến hình ảnh cơ sở để có thể tham chiếu trở lại khi cần thiết. Khi một phần dữ liệu cụ thể đã được đọc từ hình ảnh mới này, nội dung sẽ được lấy ra từ nó nếu nó là mới và được lưu giữ ở đó. Nếu không, dữ liệu sẽ được lấy ra từ image cơ sở.

* Tính năng tùy chọn bao gồm AES mã hóa và zlib dựa trên giải nén trong suốt .

* Một bất lợi của image qcow là không thể được gắn trực tiếp như hình ảnh đĩa thô.

* Copy on write (cow) Copy-on-write ( COW ), đôi khi được gọi là chia sẻ tiềm ẩn, là một kỹ thuật quản lý tài nguyên được sử dụng trong lập trình máy tính để thực hiện có hiệu quả thao tác "nhân bản" hoặc "sao chép" trên các tài nguyên có thể thay đổi. Nếu một tài nguyên được nhân đôi nhưng không bị sửa đổi, không cần thiết phải tạo một tài nguyên mới. Tài nguyên có thể được chia sẻ giữa bản sao và bản gốc. Sửa đổi vẫn phải tạo ra một bản sao, do đó kỹ thuật: các hoạt động sao chép được hoãn đến việc viết đầu tiên. Bằng cách chia sẻ tài nguyên theo cách này, có thể làm giảm đáng kể lượng tiêu thụ tài nguyên của các bản sao chưa sửa đổi.

* Qcow2 hỗ trợ việc tăng bộ nhớ bằng cơ chế Thin Provisioning (Máy ảo dùng bao nhiêu file có dung lượng bấy nhiêu).


### Copy-on-Write Images

* Một image QCOW có thể được sử dụng để lưu trữ các thay đổi cho một image khác, mà không thực sự ảnh hưởng đến nội dung của image gốc. Images, được gọi là image sao chép, trông giống như một image độc lập với người dùng nhưng hầu hết dữ liệu của nó được lấy từ image gốc. Chỉ các cụm khác với image gốc được lưu trữ trong chính tệp sao chép trên bản ghi.

* Biểu diễn rất đơn giản. Images copy-on-write chứa đường dẫn đến image gốc, và phần đầu hình ảnh cho biết vị trí của chuỗi đường dẫn trong tệp.

* Khi bạn muốn đọc một cụm từ image copy-on-write, trước tiên bạn hãy kiểm tra xem khu vực đó có được cấp phát trong image sao chép hay không. Nếu không, bạn đọc khu vực từ image ban đầu.

Chuyển đổi định dạng raw sang định dạng qcow2:

`qemu-img convert -f raw -O qcow2 image.img image.qcow2`

Chuyển đổi định dạng vmdk sang định dạng img:

`qemu-img convert -f vmdk -O raw image.vmdk image.img`


Chuyển đổi định dạng vmdk sang định dạng qcow2:

`qemu-img convert -f vmdk -O qcow2 image.vmdk image.qcow2`














