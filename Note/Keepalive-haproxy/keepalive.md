### Các thuật toán balance trong haproxy,ngữ cảnh sử dụng.

- roundrobin: Các server sẽ được chọn theo lượt, còn tùy thuộc vào weights. Đây là giải thuật mặc định, được cho là "mượt" và công bằng nhất. Tối đa nó có thể xử lí 4095 server cho mỗi backend.

- leastconn : Server có số lượng connections thấp nhất sẽ được nhận connection mới. Trong khi Round-robin được thực thi nhằm mục đích sử dụng hết các servers thì giải thuật này được khuyến khích sử dụng cho những sessions dài hơi ví dụ như LDAP, SQL, TSE, etc... Nó không thực sực sự phù hợp với những kết nối ngắn hạn như HTTP.

- first : Server đầu tiên mà còn slots sẽ nhận được connections. Đầu tiên ở đây có nghĩa là nó đã được sắp xếp theo số id từ nhỏ nhất tới lớn nhất, thường sẽ là thứ tự của server. Một khi server đã đật đến giới hạn những connections có thể nhận (maxconn) thì server tiếp theo sẽ được chọn. Nếu muốn sử dụng, bạn sẽ phải thiết lập "maxconn". Nó cũng thường được sử dụng cho các sessions dài hơi.

- source : Địa chỉ ip sẽ được "băm" và chia tùy thuộc theo weights của các server đang chạy để chọn server nhận request. Nó đảm bảo những ip từ cùng client sẽ tới cùng một server cho mỗi lần request. Thường thì nod=s được sử dụng cho tcp mode và không có cookie.

Thông thường các dịnh dạng thời gian trong HAProxy thường được biểu diễn theo định dạng milliseconds, tuy nhiên HAProxy cũng hỗ trợ nhiều định dạng khác:

* us : microseconds. 1 microsecond = 1/1000000 second

* ms : milliseconds. 1 millisecond = 1/1000 second. (Mặc định)

* s : seconds. 1s = 1000ms

* m : minutes. 1m = 60s = 60000ms

* h : hours. 1h = 60m = 3600s = 3600000ms

*d : days. 1d = 24h = 1440m = 86400s = 86400000ms

``` sh
   # Simple configuration for an HTTP proxy listening on port 80 on all
   # interfaces and forwarding requests to a single backend "servers" with a
   # single server "server1" listening on 127.0.0.1:8000
   global
       daemon
       maxconn 256

   defaults
       mode http
       timeout connect 5000ms
       timeout client 50000ms
       timeout server 50000ms

   frontend http-in
       bind *:80
       default_backend servers

   backend servers
       server server1 127.0.0.1:8000 maxconn 32


   # The same configuration defined with a single listen block. Shorter but
   # less expressive, especially in HTTP mode.
   global
       daemon
       maxconn 256

   defaults
       mode http
       timeout connect 5000ms
       timeout client 50000ms
       timeout server 50000ms

   listen http-in
       bind *:80
       server server1 127.0.0.1:8000 maxconn 32
```	   



























