###  CentOS Linux 7 End of Life: June 30, 2024

- Fix CentOS 7 Repositories Not Working (2024):

```
sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo
sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo
sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo
```

- Update repo Ubuntu/Centos 7 VietNam:

```
https://launchpad.net/ubuntu/+archivemirrors repo ubuntu VietNam


https://mirrors.bkns.vn/centos/7.9.2009/
https://mirror.nsc.liu.se/centos-store/centos/7.9.2009/
http://hcm-mirrors.viettelidc.com.vn/centos/7.9.2009/
https://mirror.cs.princeton.edu/pub/mirrors/centos/7.9.2009/

cat <<\EOF > /etc/yum.repo.d/CentOS-Base.repo
[base]
name=CentOS-$releasever - Base
baseurl=http://hcm-mirrors.viettelidc.com.vn/centos/7.9.2009/os/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-$releasever - Updates
baseurl=http://hcm-mirrors.viettelidc.com.vn/centos/7.9.2009/updates/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-$releasever - Extras
baseurl=http://hcm-mirrors.viettelidc.com.vn/centos/7.9.2009/extras/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[centosplus]
name=CentOS-$releasever - Plus
baseurl=http://hcm-mirrors.viettelidc.com.vn/centos/7.9.2009/centosplus/$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

[contrib]
name=CentOS-$releasever - Contrib
baseurl=http://hcm-mirrors.viettelidc.com.vn/centos/7.9.2009/contrib/$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF
```
