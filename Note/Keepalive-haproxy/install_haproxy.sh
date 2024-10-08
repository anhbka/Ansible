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
function install_haproxy () {
	yum install haproxy -y	
}

function khaibao () {
	echo " Nhap vao password root : "
	read pw
	echo " Nhap vao IP VIP : "
	read ip
	echo " Nhap vao IP web1 : "
	read ip1
	echo " Nhap vao IP web2 : "
	read ip2	
}

function config_haproxy () {
echo "global
        daemon
        maxconn 256

defaults
        mode http
        timeout connect 5000ms
        timeout client 50000ms
        timeout server 50000ms
        stats enable
        stats uri /monitor
        stats auth root:$pw

listen httpd
    bind $ip:80
    balance  roundrobin
    mode  http
    server web1 $ip1:80 check
    server web2 $ip2" > /etc/haproxy/haproxy.cfg	
}

function restart_haproxy () {
	systemctl start haproxy
	systemctl enable haproxy
	firewall-cmd --zone=public --add-port=80/tcp --permanent
	firewall-cmd --reload
}

#----------------------------------------------------------------------------#
# 							 Start functions 						 		 # 															 				 
#----------------------------------------------------------------------------#

echocolor " Start install_haproxy "
sleep 3
install_haproxy

echocolor " Khai bao IP "
sleep 3
khaibao

echocolor " Cau hinh haproxy "
sleep 3
config_haproxy

echocolor " Restart haproxy "
sleep 3
restart_haproxy














