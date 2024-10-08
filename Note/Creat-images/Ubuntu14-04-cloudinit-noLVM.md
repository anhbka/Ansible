### Hướng dẫn đóng image Ubuntu 14.04 với cloud-init (không dùng LVM)

Sử dụng virt-install hoặc virt manager để cài OS.

``` sh
qemu-img create -f qcow2 /tmp/trusty1.qcow2 10G
virt-install --virt-type kvm --name trusty1 --ram 1024 \
  --cdrom=/var/lib/libvirt/images/ubuntu-14.04.4-server-amd64.iso \
  --disk /tmp/trusty1.qcow2,format=qcow2 \
  --network bridge=br0 \
  --graphics vnc,listen=0.0.0.0 --noautoconsole \
  --os-type=linux --os-variant=ubuntutrusty
``` 

Lưu ý: Virtual size mà bạn chọn cho ổ đĩa sẽ là size tối thiểu của volume nếu bạn muốn boot máy ảo từ volume sau này. Nên tạo máy ảo với định dạng file ổ đĩa là qcow2 để không mất công chuyển đổi sau này.

Một số lưu ý trong quá trình cài đặt

Đối với hostname, các bạn có thể đặt mặc định bởi ta dùng cloud-init để set sau.

Đối với cấu hình partion, do ở đây mình dùng cloud-init nên không thể cấu hình LVM mặc định. Thay vào đó, ta sẽ cấu hình bằng tay với 1 phân vùng root (/) để máy ảo có thể tự resize theo flavor mới.

Lưu ý: không dùng cấu hình tự động, mình đã thử và thấy máy ảo không thể tự resize.  
  
  
<img src="/img/1.jpg">
<img src="/img/2.jpg">
<img src="/img/3.jpg">
<img src="/img/4.jpg">
<img src="/img/5.jpg">
<img src="/img/6.jpg">
<img src="/img/7.jpg">
<img src="/img/8.jpg">
<img src="/img/9.jpg">
<img src="/img/10.jpg">
<img src="/img/11.jpg">
<img src="/img/12.jpg">  
<img src="/img/13.jpg">
<img src="/img/14.jpg">
<img src="/img/15.jpg">
<img src="/img/16.jpg">
<img src="/img/17.jpg">
<img src="/img/18.jpg">  
<img src="/img/19.jpg">
<img src="/img/20.jpg">
<img src="/img/21.jpg">
<img src="/img/22.jpg">
<img src="/img/23.jpg">
<img src="/img/24.jpg">  


Install GRUB boot loader

Sau khi cài đặt xong, chọn Continue để reboot máy ảo. Lưu ý: Có một số trường hợp đối với ubuntu14.04, máy ảo sẽ không reboot kể cả khi nó báo là sẽ reboot

Sau khi đã hoàn tất cài đặt, tiến hành gỡ bỏ ổ đĩa, libvirt yêu cầu bạn gán một ổ đĩa trống tại nơi trước đó cd-rom được gán, có thể là hdc. Bạn có thể xem nó bằng câu lệnh `virsh dumpxml name-vm-image`

``` sh
root@mdtserver31:~# virsh dumpxml trusty1
<domain type='kvm'>
  <name>trusty1</name>
  <uuid>deea7cb9-0f1a-0e21-6e43-03511102b9e4</uuid>
  <memory unit='KiB'>1048576</memory>
  <currentMemory unit='KiB'>1048576</currentMemory>
  <vcpu placement='static'>1</vcpu>
  <os>
    <type arch='x86_64' machine='pc-i440fx-trusty'>hvm</type>
    <boot dev='hd'/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <pae/>
  </features>
  <clock offset='utc'/>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>restart</on_crash>
  <devices>
    <emulator>/usr/bin/kvm-spice</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/tmp/trusty1.qcow2'/>
      <target dev='vda' bus='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x0'/>
    </disk>
    <disk type='block' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <target dev='hdc' bus='ide'/>
      <readonly/>
      <address type='drive' controller='0' bus='1' target='0' unit='0'/>
    </disk>
    <controller type='usb' index='0'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x2'/>
    </controller>
    <controller type='pci' index='0' model='pci-root'/>
    <controller type='ide' index='0'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x1'/>
    </controller>
    <interface type='bridge'>
      <mac address='52:54:00:1b:9a:6a'/>
      <source bridge='br0'/>
      <model type='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
    </interface>
    <serial type='pty'>
      <target port='0'/>
    </serial>
    <console type='pty'>
      <target type='serial' port='0'/>
    </console>
    <input type='mouse' bus='ps2'/>
    <input type='keyboard' bus='ps2'/>
    <graphics type='vnc' port='-1' autoport='yes' listen='0.0.0.0'>
      <listen type='address' address='0.0.0.0'/>
    </graphics>
    <video>
      <model type='cirrus' vram='9216' heads='1'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0'/>
    </video>
    <memballoon model='virtio'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>
    </memballoon>
  </devices>
</domain>

root@mdtserver31:~#
```

Chạy câu lệnh sau trên KVM để gỡ bỏ ổ đĩa

``` sh
virsh start trusty1 --paused
virsh attach-disk --type cdrom --mode readonly trusty1 "" hdc
virsh resume trusty1
```


Bước 2: Cài các dịch vụ cần thiết

Truy cập vào máy ảo. Lưu ý với lần đầu boot, bạn phải sử dụng tài khoản tạo trong quá trình cài os, chuyển đổi nó sang tài khoản root để sử dụng.

Cài đặt `cloud-init`, `cloud-utils` và `cloud-initramfs-growroot`

`apt-get install cloud-utils cloud-initramfs-growroot cloud-init -y`

Bước 3: Cấu hình để instance nhận metadata từ datasource

`dpkg-reconfigure cloud-init`

Sau khi màn hình mở ra, lựa chọn duy nhất EC2

<img src="/img/25.jpg">

Bước 5: Xóa bỏ thông thin của địa chỉ MAC

xóa nội dung file `/lib/udev/rules.d/75-persistent-net-generator.rules và `/etc/udev/rules.d/70-persistent-net.rules` (file này được gen bởi file trước) bằng các sử dụng :%d trong vi.

Bạn cũng có thể thay thế file trên bằng 1 file rỗng. Lưu ý: không được xóa bỏ hoàn toàn file mà chỉ xóa nội dung.

Bước 6: Cấu hình để instance báo log ra console

Thay đổi `GRUB_CMDLINE_LINUX_DEFAULT="console=tty0 console=ttyS0,115200n8"` trong file `/etc/default/grub`.

Sau đó nhập lệnh update-grub để lưu lại.

Bước 7: tắt máy ảo

`/sbin/shutdown -h now`

Bước 8: Cài libguestfs-tools để xử lý image

`apt-get install libguestfs-tools -y`

Lưu ý:

Từ bước này thực hiện trên host KVM.

Bước 8 chỉ cần thực hiện ở lần đóng image đầu tiên.

Bước 9: Clean up image

`virt-sysprep -d trusty1`

Bước 10: Undefine libvirt domain

`virsh undefine trusty1`

Bước 11: Giảm kích thước máy ảo

virt-sparsify --compress /tmp/trusty1.qcow2 /tmp/trusty1-shrink.qcow2

<img src="/img/26.jpg"> 







  