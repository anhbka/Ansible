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

function khai_bao {
echo -n "Nhap vao IP VIP:"
read ip
echo -n "Nhap vao priority:"
read priority
echo -n "Lua chon MASTER hoac BACKUP"
read MASTER
}

function install_keepalive {
#		yum -y install chrony
		sudo systemctl disable firewalld
		sudo systemctl stop firewalld
		sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
		yum install keepalived psmisc -y
}

function config_keepalive {
		sleep 3
		echo "net.ipv4.ip_nonlocal_bind=1" >> /etc/sysctl.conf	
}

function ha_proxy () {
echo "vrrp_script chk_haproxy {           
        script "killall -0 haproxy"     
        interval 2                      
        weight 2                        
}

vrrp_instance VI_1 {
        interface eth0
        state $MASTER
        virtual_router_id 51
        priority $priority                    
        virtual_ipaddress {
            $ip       
        }
        track_script {
            chk_haproxy
        }
}
" > /etc/keepalived/keepalived.conf
}

function check_haproxy {
		killall -0 haproxy
}

function restart_haproxy {
		systemctl start keepalived
		systemctl enable keepalived
		ip a
}

#--------------------------------------------------------------------#
# 							 Start functions 						 # 															 				 
#--------------------------------------------------------------------#

echocolor " Start install keepalived "

echocolor " Nhap vao IP VIP va priority "
sleep 3
khai_bao
config_keepalive

echocolor " Install keepalive "
sleep 3
install_keepalive

echocolor " Config ha_proxy "
sleep 3
ha_proxy

echocolor " Kiem tra check_haproxy "
sleep 3
check_haproxy

echocolor " Restart ha_proxy "
sleep 3
restart_haproxy

echocolor " Finish "
