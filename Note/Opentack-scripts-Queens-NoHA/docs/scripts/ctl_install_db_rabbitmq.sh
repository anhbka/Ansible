#!/bin/bash -ex

source config.cfg 

function echocolor {
    echo "#######################################################################"
    echo "$(tput setaf 2)##### $1 #####$(tput sgr0)"
    echo "#######################################################################"

}

function ops_edit {
    crudini --set $1 $2 $3 $4
}

# Cach dung
## Cu phap:
##			ops_edit_file $bien_duong_dan_file [SECTION] [PARAMETER] [VALUAE]
## Vi du:
###			filekeystone=/etc/keystone/keystone.conf
###			ops_edit_file $filekeystone DEFAULT rpc_backend rabbit


# Ham de del mot dong trong file cau hinh
function ops_del {
    crudini --del $1 $2 $3
}

function install_mariadb {
        echocolor "Install DB"
        yum -y install mariadb mariadb-server python2-PyMySQL rsync xinetd crudini vim
        
cat << EOF > /etc/my.cnf.d/openstack.cnf
[mysqld]
bind-address = 0.0.0.0
default-storage-engine = innodb
innodb_file_per_table
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
EOF
        
}


function restart_db {
        echocolor "Khoi dong lai DB"
        sleep 3
        systemctl enable mariadb.service
        systemctl start mariadb.service		
}

function set_passdb {
		mysql_secure_installation
}

function rabbitmq_install {
        echocolor "Cai dat rabbitmq"
        sleep 3
        yum -y install rabbitmq-server

        systemctl enable rabbitmq-server.service
        systemctl start rabbitmq-server.service
        
}

function rabbitmq_create_user() {
	sleep 5
	rabbitmqctl add_user openstack Welcome123
	sleep 5
	rabbitmqctl set_permissions openstack ".*" ".*" ".*"
}

### Thuc hien ham
install_mariadb
restart_db
set_passdb
echocolor "Tao user cho rabbitmq"
rabbitmq_install
rabbitmq_create_user