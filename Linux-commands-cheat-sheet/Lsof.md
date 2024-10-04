### Losf

`yum install lsof -y`

```
[root@mail ~]# lsof
COMMAND     PID  TID    USER   FD      TYPE             DEVICE  SIZE/OFF       NODE NAME
systemd       1         root  cwd       DIR              253,0       224         64 /
systemd       1         root  rtd       DIR              253,0       224         64 /
systemd       1         root  txt       REG              253,0   1612152   50551538 /usr/lib/systemd/systemd
systemd       1         root  mem       REG              253,0     20112      52341 /usr/lib64/libuuid.so.1.3.0
systemd       1         root  mem       REG              253,0    261456      52343 /usr/lib64/libblkid.so.1.1.0
systemd       1         root  mem       REG              253,0     90664      48129 /usr/lib64/libz.so.1.2.7
systemd       1         root  mem       REG              253,0    157424      52334 /usr/lib64/liblzma.so.5.2.2
systemd       1         root  mem       REG              253,0     23968      52368 /usr/lib64/libcap-ng.so.0.0.0
systemd       1         root  mem       REG              253,0     19896      48186 /usr/lib64/libattr.so.1.1.0
systemd       1         root  mem       REG              253,0     19776      19224 /usr/lib64/libdl-2.17.so
systemd       1         root  mem       REG              253,0    402384      48206 /usr/lib64/libpcre.so.1.2.0
systemd       1         root  mem       REG              253,0   2173512      19218 /usr/lib64/libc-2.17.so
systemd       1         root  mem       REG              253,0    144792      19244 /usr/lib64/libpthread-2.17.so
systemd       1         root  mem       REG              253,0     88720         84 /usr/lib64/libgcc_s-4.8.5-20150702.so.1
systemd       1         root  mem       REG              253,0     44448      19248 /usr/lib64/librt-2.17.so
systemd       1         root  mem       REG              253,0    273616      72616 /usr/lib64/libmount.so.1.1.0
systemd       1         root  mem       REG              253,0     91800     142901 /usr/lib64/libkmod.so.2.2.10
systemd       1         root  mem       REG              253,0    127096      52370 /usr/lib64/libaudit.so.1.0.0
systemd       1         root  mem       REG              253,0     61672      72678 /usr/lib64/libpam.so.0.83.1
systemd       1         root  mem       REG              253,0     20032      48191 /usr/lib64/libcap.so.2.22
systemd       1         root  mem       REG              253,0    155784      48205 /usr/lib64/libselinux.so.1
systemd       1         root  mem       REG              253,0    164240      19211 /usr/lib64/ld-2.17.so
```

* Chú thích output của chương trình lệnh

```
– COMMAND : 9 kí tự đầu tiên của tên chương trình lệnh tương ứng với tiến trình.

– PID : thông tin PID của tiến trình.

– USER : user thực thi tiến trình đó. Có thể là UID hoặc username.

– FD : File Descriptor của file được liệt kê, hoặc các thông tin khác hay mode (w,u,r) của file.

+ cwd : là thư mục đang hoạt động của tiến trình

+ txt : program text (code và data)

+ mmap : memory-mapped file

+ rtd : root directory

+ DEL : Linux map file đã bị xoá.

+ w : đang truy cập ghi xuống dữ liệu

+ u : đang truy cập ghi và đọc dữ liệu

+ r : đang truy cập đọc dữ liệu

– TYPE :

+ REG : file bình thường
+ sock : socket.
+ ipv4/ipv6 : socket ipv4/v6
+ DIR : thư mục

– DEVICE : số đại diện của thiết bị như partition mà file nằm trên partition đó.

– SIZE/OFF : dung lượng của file.
– NODE : số node của file.
– NAME : tên file.
```

* Liệt kê các tệp đã mở trong một thư mục

`lsof +D /var/log/`

* Liệt kê các tệp đã mở dựa vào tên tiến trình:

`lsof -c ssh`







