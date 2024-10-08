#!/bin/bash -ex 
function echocolor {
    echo "#---------------------------------------------------------------------#"
    echo "$(tput setaf 2)##### $1 #####$(tput sgr0)                              "
    echo "#---------------------------------------------------------------------#"

}

function ops_edit {
    crudini --set "$1" "$2" "$3" "$4"
}

function ops_del {
    crudini --del "$1" "$2" "$3"
}

function copykey {
        ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P ""
        for IP_ADD in $CTL1_IP_NIC1 $CTL2_IP_NIC1 $COM1_IP_NIC1 $COM2_IP_NIC1 $CINDER1_IP_NIC1
        do
                ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub root@$IP_ADD
        done
}

function setup_config {
        for IP_ADD in $CTL1_IP_NIC1 $CTL2_IP_NIC1 $COM1_IP_NIC1 $COM2_IP_NIC1 $CINDER1_IP_NIC1
        do
                scp ./config.cfg root@$IP_ADD:/root/
                chmod +x config.cfg

        done
}

function install_repo_openstack {
        for IP_ADD in $CTL1_IP_NIC1 $CTL2_IP_NIC1 $COM1_IP_NIC1 $COM2_IP_NIC1 $CINDER1_IP_NIC1
        do
            echocolor "Cai dat install_repo tren $IP_ADD"
            sleep 3
        ssh root@$IP_ADD << EOF 
yum -y install centos-release-openstack-queens
yum -y upgrade
yum -y install crudini wget vim
yum -y install python-openstackclient openstack-selinux python2-PyMySQL
yum -y update
EOF
        done
}

function khai_bao_host {
        echo "$CTL1_IP_NIC1 controller1" >> /etc/hosts
		echo "$CTL2_IP_NIC1 controller2" >> /etc/hosts
        echo "$COM1_IP_NIC1 compute1" >> /etc/hosts
        echo "$COM2_IP_NIC1 compute2" >> /etc/hosts
        echo "$CINDER1_IP_NIC1 cinder1" >> /etc/hosts
        scp /etc/hosts root@$COM1_IP_NIC1:/etc/
        scp /etc/hosts root@$COM2_IP_NIC1:/etc/
}


function setup_mode_sysctl () {
		echo 'net.ipv4.conf.all.arp_ignore = 1' >> /etc/sysctl.conf
		echo 'net.ipv4.conf.all.arp_announce = 2' >> /etc/sysctl.conf
		echo 'net.ipv4.conf.all.rp_filter = 2' >> /etc/sysctl.conf
		echo 'net.netfilter.nf_conntrack_tcp_be_liberal = 1' >> /etc/sysctl.conf
cat << EOF >> /etc/sysctl.conf
net.ipv4.ip_nonlocal_bind = 1
net.ipv4.tcp_keepalive_time = 6
net.ipv4.tcp_keepalive_intvl = 3
net.ipv4.tcp_keepalive_probes = 6
net.ipv4.ip_forward = 1
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
EOF
}
function check_mode_sysctl () {
		sysctl -p
		sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
		sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
		systemctl disable firewalld
		systemctl stop firewalld
}

function khaibao_repo () {
echo '[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.2/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1' >> /etc/yum.repos.d/MariaDB.repo
		yum -y update
}

function khai_bao_host {
        scp /etc/hosts root@$1:/etc/

}

# Cai dat NTP server 
function install_ntp_server {
        
				echocolor "Cau hinh NTP cho $1"
        sleep 3 
ssh root@$1 << EOF
yum -y install chrony									
sed -i 's/server 0.centos.pool.ntp.org iburst/server $CTL1_IP_NIC1 iburst/g' /etc/chrony.conf
sed -i 's/server 1.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/server 2.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/server 3.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
systemctl enable chronyd.service
systemctl start chronyd.service
systemctl restart chronyd.service
chronyc sources
EOF
      
}








