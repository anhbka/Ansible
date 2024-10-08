### SSL

SSL là viết tắt của từ Secure Sockets Layer. Đây là một tiêu chuẩn an ninh công nghệ toàn cầu tạo ra một liên kết giữa máy chủ web và trình duyệt. Liên kết này đảm bảo tất cả dữ liệu trao đổi giữa máy chủ web và trình duyệt luôn được bảo mật và an toàn.SSL đảm bảo rằng tất cả các dữ liệu được truyền giữa các máy chủ web và các trình duyệt được mang tính riêng tư, tách rời. SSL là một chuẩn công nghệ được sử dụng bởi hàng triệu trang web trong việc bảo vệ các giao dịch trực tuyến với khách hàng của họ.

<img src="/img/1.png">

<img src="/img/2.png.jpg">

Một số định nghĩa, thuật ngữ SSL thường gặp:

Để hiểu rõ hơn, chúng ta cần phải biết Certificate Authority (CA) là gì?

CA là tổ chức phát hành các chứng thực các loại chứng thư số cho người dùng, doanh nghiệp, máy chủ (server), mã code, phần mềm. Nhà cung cấp chứng thực số đóng vai trò là bên thứ ba (được cả hai bên tin tưởng) để hỗ trợ cho quá trình trao đổi thông tin an toàn.

Trong bài viết này, chúng tôi đơn cử Global Sign – một trong những doanh nghiệp đầu tiên trên thế giới được công nhận là nhà cung cấp dịch vụ chứng thực chữ ký số công cộng cung cấp tất cả các loại chứng thư, gói chứng thư, giải pháp chứng thư số cho các ngành tài chính – ngân hàng, y tế, giáo dục và các lĩnh vực kinh doanh khác.

* Chứng thư tiêu chuẩn toàn cầu.

* Tương thích với 99% các trình duyệt.

* Cung cấp bởi một trong những CA uy tín nhất thế giới.

* Định hướng doanh nghiệp với tất cả các dòng sản phẩm SSL.

* Tiết kiệm cho doanh nghiệp với lựa chọn Wildcard, SAN.

Domain Validation (DV SSL): chứng thư số SSL chứng thực cho Domain Name – Website. Khi 1 Website sử dụng DV SSL thì sẽ được xác thực tên domain, website đã được mã hoá an toàn khi trao đổi dữ liệu.

Organization Validation (OV SSL): chứng thư số SSL chứng thực cho Website và xác thực doanh nghiệp đang sở hữu website đó .

Extended Validation (EV SSL): cho khách hàng của bạn thấy Website đang sử dụng chứng thư SSL có độ bảo mật cao nhất và được rà soát pháp lý kỹ càng. Với thanh địa chỉ sang màu xanh với hiển thị đầy đủ thông tin của công ty, cung cấp một cấp độ cao hơn tin tưởng vào website của bạn

Subject Alternative Names (SANs SSL) – Nhiều tên miền hợp nhất trong 1 chứng thư số:

Một chứng thư số SSL tiêu chuẩn chỉ bảo mật cho duy nhất một tên miền đã được kiểm định. Lựa chọn thêm SANs chỉ với chứng thư duy nhất bảo đảm cho nhiều tên miền con. SANs mang lại sự linh hoạt cho người sử dụng, dễ dàng hơn trong việc cài đặt, sử dụng và quản lý chứng thư số SSL. Ngoài ra, SANs có tính bảo mật cao hơn Wildcard SSL, đáp ứng chính xác yêu cầu an toàn đối với máy chủ và làm giảm tổng chi phí triển khai SSL tới tất cả các tên miền và máy chủ cần thiết.

Chứng thư số SSL SANs có thể tích hợp với tất cả các loại chứng thư số SSL của GlobalSign bao gồm: Chứng thực tên miền (DV SSL), Chứng thực tổ chức doanh nghiệp (OV SSL) và Chứng thực mở rộng cao cấp (EV SSL).

Wildcard SSL Certificate (Wildcard SSL): sản phẩm lý tưởng dành cho các cổng thương mại điện tử. Các website dạng này thường có thể tạo ra các trang e-store dành cho các chủ cửa hàng trực tuyến, mỗi e-store là một sub domains và được chia sẻ trên một địa chỉ IP duy nhất. Khi đó, để triển khai giải pháp bảo bảo mật giao dịch trực tuyến (khi đặt hàng, thanh toán, đăng ký & đăng nhập tài khoản,…) bằng SSL, chúng ta có thể dùng duy nhất một chứng chỉ số Wildcard cho tên miền chính của website và dùng chung một địa chỉ IP duy nhất để chia sẻ cho tất cả mọi sub domains.

Nếu việc sử dụng các chứng chỉ của Global Sign khá tốn kèm thì chứng chỉ số GeoTrust rất thích hợp cho các bạn muốn triển khai bảo mật giao dịch trực tuyến cho website của mình với chi phí thấp.

Đặc biệt, các loại chứng chỉ RapidSSL (sản phẩm của RapidSSL, một công ty con của GeoTrust) và QuickSSL chấp nhận các khách hàng cá nhân với mức xác minh chỉ là quyền sở hữu tên miền.



















