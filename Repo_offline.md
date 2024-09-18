### 1. Create repo offline with DVD for Centos 7:

- Mount the CD/DVD ROM on any directory of your wish.
```
mount -o loop /dev/sr0 /mnt

* Note: The Warning mount: /mnt/disc: WARNING: source write-protected, mounted read-only. is expected.

mv /etc/yum.repos.d/*.repo /tmp/
vi /etc/yum.repos.d/local.repo

[LocalRepo]
name=LocalRepository
baseurl=file:///mnt
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

yum clean all
yum repolist
```

### 2. Create repo offline with DVD for Rhel 7

```
mount -o loop /dev/sr0 /mnt

* Note: The Warning mount: /mnt/disc: WARNING: source write-protected, mounted read-only. is expected.

cp /mnt/media.repo /etc/yum.repos.d/rhel7dvd.repo
chmod 644 /etc/yum.repos.d/rhel7dvd.repo

Edit the new repo file, changing the gpgcheck=0 setting to 1 and adding the following 3 lines:

vi /etc/yum.repos.d/rhel7dvd.repo
[InstallMedia]
name=DVD for Red Hat Enterprise Linux 7.9 Server
mediaid=1359576196.686790
metadata_expire=-1
gpgcheck=1
cost=500
enabled=1
baseurl=file:///mnt/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

Clear the cache and check whether you can get the packages list from the DVD repo:

yum clean all
yum repolist enabled
yum update
```

### 3. Create repo offline with DVD for Rhel 8

Mount the downloaded RHEL installation ISO to a directory like /mnt:

```
# mount -o loop <downloaded iso name> /mnt

Example:
# mount -o loop rhel-server-8.8-x86_64-dvd.iso /mnt

If you use DVD media, you can mount like below.

mount -o loop /dev/sr0  /mnt

* Note: The Warning mount: /mnt/disc: WARNING: source write-protected, mounted read-only. is expected.

Create new repo file like below. There are two repositories in RHEL 8, named BaseOS and AppStream.

cat << EOF > /etc/yum.repos.d/my.repo 
[dvd-BaseOS]
name=DVD for RHEL - BaseOS
baseurl=file:///mnt/BaseOS/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[dvd-AppStream]
name=DVD for RHEL - AppStream/
baseurl=file:///mnt/AppStream/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
EOF
Check whether you can get the packages list from the DVD repositories.

yum clean all
yum  --noplugins list

```

### 4. Create repo offline with DVD for Rhel 9:

```
Mount the RHEL Binary DVD ISO to a directory such as /mnt, e.g.:

mkdir -p  /mnt
mount -o loop rhel-baseos-9.0-x86_64-dvd.iso /mnt

mount /dev/sr0  /mnt
* Note: The Warning mount: /mnt/disc: WARNING: source write-protected, mounted read-only. is expected.

vi /etc/yum.repos.d/rhel9dvd.repo 
[BaseOS]
name=BaseOS Packages Red Hat Enterprise Linux 9
metadata_expire=-1
gpgcheck=1
enabled=1
baseurl=file:///mnt/BaseOS/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[AppStream]
name=AppStream Packages Red Hat Enterprise Linux 9
metadata_expire=-1
gpgcheck=1
enabled=1
baseurl=file:///mnt/AppStream/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

- Clear the cache and check whether you are able to get the packages from this DVD repository:

yum clean all
yum repolist

```

### 5. Update repo online for Centos 7:

```
sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo
sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo
sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo

yum clean all

yum repolist

https://mirrors.bkns.vn/centos/7.9.2009/
https://mirror.nsc.liu.se/centos-store/centos/7.9.2009/
http://hcm-mirrors.viettelidc.com.vn/centos/7.9.2009/
https://mirror.cs.princeton.edu/pub/mirrors/centos/7.9.2009/
http://mirrors.viettelidc.com.vn/centos/7/

cat <<\EOF > /etc/yum.repos.d/repovietnam.repo
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