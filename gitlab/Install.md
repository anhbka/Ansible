## Install gitlab on Centos 7

- Update repo:
```
cat <<\EOF > /etc/yum.repos.d/CentOS-Base.repo
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

yum clean all 
yum repolist

```
For system performance purposes, it is recommended to configure the kernel's swappiness setting to a low value like 10:

```
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
cat /proc/sys/vm/swappiness
```

* Requirement: 

```
CPU: 4 Core
RAM: 4 GB
Disk: 100 GB
```

* Install repo and udpate

```
yum install epel-release -y
yum update -y
init 6


sudo yum install -y curl policycoreutils-python openssh-server openssh-clients
sudo yum install -y postfix
sudo systemctl enable postfix.service
sudo systemctl start postfix.service
```

* Set host name

```
hostnamectl set-hostname gitlab
```

* Disabled firewalld and selinux

```
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
systemctl stop firewalld
systemctl disable firewalld
```

* Install chrony and sync time, restart server

```
timedatectl set-timezone Asia/Ho_Chi_Minh

yum -y install chrony
systemctl enable chronyd.service
systemctl restart chronyd.service
chronyc sources
timedatectl set-local-rtc 0

init 6
````

* Install Gitlab

```
sudo yum install -y curl policycoreutils-python openssh-server
sudo systemctl enable sshd
sudo systemctl start sshd
```

* Install repo gitlab

`curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash`

* Install gitlab CE

`sudo EXTERNAL_URL="http://192.168.30.101" yum install -y gitlab-ce`

```
Gitlab use IP 192.168.239.200 for EXTERNAL_URL = IP
If you want use domain => update EXTERNAL_URL
```
* Result

```
Chef Client finished, 543/1469 resources updated in 03 minutes 24 seconds
gitlab Reconfigured!

       *.                  *.
      ***                 ***
     *****               *****
    .******             *******
    ********            ********
   ,,,,,,,,,***********,,,,,,,,,
  ,,,,,,,,,,,*********,,,,,,,,,,,
  .,,,,,,,,,,,*******,,,,,,,,,,,,
      ,,,,,,,,,*****,,,,,,,,,.
         ,,,,,,,****,,,,,,
            .,,,***,,,,
                ,*,.



     _______ __  __          __
    / ____(_) /_/ /   ____ _/ /_
   / / __/ / __/ /   / __ `/ __ \
  / /_/ / / /_/ /___/ /_/ / /_/ /
  \____/_/\__/_____/\__,_/_.___/


Thank you for installing GitLab!
GitLab should be available at http://192.168.138.200

For a comprehensive list of configuration options please see the Omnibus GitLab readme
https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/README.md

  Verifying  : gitlab-ce-13.0.0-ce.0.el7.x86_64                                                                                                              1/1

Installed:
  gitlab-ce.x86_64 0:13.0.0-ce.0.el7

Complete!
```

* Seting basic for gitlab

`http://192.168.30.101/`

`cat /etc/gitlab/initial_root_password`

`Change password`

```
From now on, use the below credentials to log in as the administrator:

Username: root
Password: <your-new-password>
```

* Configure GitLab URL

```
cd /etc/gitlab/
vim gitlab.rb
external_url 'http://gitlab.hakase-labs.co'
```

* Install Letsencrypt tool on CentOS 7 with yum command below.


`yum -y install letsencrypt`

* After the installation is complete, generate new SSL certificate letsencrypt with the command below.

`letsencrypt certonly --standalone -d gitlab.example.com`


* Next, create new 'ssl' directory under the GitLab configuration directory '/etc/gitlab/'.


`mkdir -p /etc/gitlab/ssl/`

```
sudo openssl dhparam -out /etc/gitlab/ssl/dhparams.pem 2048
chmod 600 /etc/gitlab/ssl/*
```

* Enable Nginx HTTPS for GitLab


```
cd /etc/gitlab/
vim gitlab.rb
And change HTTP to HTTPS on the external_url line.
external_url 'https://gitlab.hakase-labs.co'.

Then paste the following configuration under the 'external_url' line configuration.


nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/letsencrypt/live/gitlab.hakase-labs.co/fullchain.pem"
nginx['ssl_certificate_key'] = "/etc/letsencrypt/live/gitlab.hakase-labs.co/privkey.pem"
nginx['ssl_dhparam'] = "/etc/gitlab/ssl/dhparams.pem"

```
Finally, apply the GitLab configuration using the following command.


`gitlab-ctl reconfigure`

* Install gitlab runner

```
# Download the binary for your system
sudo curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh" | sudo bash
yum list gitlab-runner --showduplicates | sort -r
sudo yum install gitlab-runner-16.5.0-1 -y

# Give it permissions to execute
sudo chmod +x /usr/local/bin/gitlab-runner
ln -s /usr/local/bin/gitlab-runner /usr/bin/gitlab-runner
echo "gitlab-runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create a GitLab CI user
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash

# Install and run as service
sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
sudo gitlab-runner start
```

* Change other user use gitlab runner

```
vim /etc/systemd/system/gitlab-runner.service
[Unit]
Description=GitLab Runner
After=network.target

[Service]
User=gitlab-runner
Group=gitlab-runner
ExecStart=/usr/bin/gitlab-runner run --working-directory /home/gitlab-runner
Restart=always

[Install]
WantedBy=multi-user.target
```

* install docker on server

`curl -sSL https://get.docker.com | sudo sh`

* Add user to docker group

```
sudo usermod -aG docker $(whoami)
sudo usermod -aG docker gitlab-runner
```
`before_script` – ý là trước khi thực hiện script. Ở đây ta khai báo before_script ở “root level” nên nó sẽ được áp dụng cho tất cả các job.


* Shared runners pipeline minutes quota

```
To change the pipelines minutes quota:

Go to Admin Area > Settings > CI/CD.
Expand Continuous Integration and Deployment.
In the Pipeline minutes quota box, enter the maximum number of minutes.
Click Save changes for the changes to take effect.
```
https://docs.gitlab.com/ee/user/admin_area/settings/continuous_integration.html#shared-runners-pipeline-minutes-quota

https://docs.gitlab.com/runner/install/docker.html



