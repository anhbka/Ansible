### Cài đặt KVM trên Ubuntu 16.04
### Mô hình
<img src="/img/1.jpg">	

NIC1 : ens33 192.168.239.0/24

NIC2 : ens34 10.10.10.0/24

Kiểm tra :

`egrep -c '(svm|vmx)' /proc/cpuinfo`

Cài đặt KVM:

``` sh
sudo apt-get update -y
sudo apt-get install qemu-kvm libvirt-bin bridge-utils -y 
```

Gán quyền user:

``` sh
sudo adduser `id -un` libvirtd
sudo adduser `id -un` kvm
```

- Do khi cài KVM thì mặc định `Linux Bridge` (Linux Bridge là một trong các sự lựa chọn để ảo hóa network trong Linux - tương đương với OpenvSwtich) sẽ được cài cùng và sinh ra bridge `virbr0`. Có thể kiểm tra bằng lệnh dưới, ta sẽ thấy có tên bridge.
	```sh
	brctl show
	```

- Do vây, ta sẽ xóa các bridge do Linux Bridge khi cài cùng KVM sinh ra để sử dụng OpenvSwitch
	```sh
	sudo virsh net-destroy default 
	sudo virsh net-autostart --disable default
	```

- Kiểm tra lại bằng lệnh `brctl show` ta sẽ không thấy bridge `virbr0`. Lúc này OK
	```sh
	root@u16-com2:~# brctl show
	bridge name     bridge id               STP enabled     interfaces
	```
Chạy lệnh : 

`virsh --connect qemu:///system list`
















