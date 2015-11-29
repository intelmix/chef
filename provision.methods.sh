#TODO: store everything in SVN/GIT and just a simple one line script to checkout 
#and run the provisioning bootstrapper script
#adminer will be installed in another server for monitoring
#so we won't need nginx on the main server. Only java, jdk, Play, mysql
#!/usr/bin/env bash
CFG_PATH="./config"
IS_VERBOSE=0

function cleanup_system {
    echo_start "clean-up"
    apt-get -q -y autoclean > /dev/null
    apt-get -q -y autoremove > /dev/null
    echo_done "clean-up"
}

function init_system {
    echo_start "init"
    printf "nameserver 4.2.2.4\nnameserver 10.0.2.3\n" > /etc/resolv.conf
    export DEBIAN_FRONTEND=noninteractive
    echo "deb http://ftp.au.debian.org/debian testing main contrib" >> /etc/apt/sources.list
    
    #repeat three times due to some network issues 
    if [[ $IS_VERBOSE == 0 ]] 
    then
        apt-get update > /dev/null
        apt-get update > /dev/null
        apt-get update --fix-missing > /dev/null
    else
        apt-get update
        apt-get update
        apt-get update --fix-missing
    fi
     
    echo_done "init"
}

function install_sys_packages {
    apt_get_install bsdutils
    apt_get_install chkconfig
    apt_get_install lynx
    apt_get_install curl
    apt_get_install gcc
    apt_get_install g++
    apt_get_install build-essential    
    apt_get_install nginx
    apt_get_install mysql-server
    apt_get_install ufw
}

function setup_firewall {
    echo_start "firewall setup"
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow 22   #ssh
    ufw allow 6915
    #ufw allow 80   #nginx
    ufw allow 9001 #supervisord
    ufw allow 3306 #mysql
    ufw --force enable
    echo_done "firewall setup"
}

function start_services {
    echo_start "service start"
    service cron restart
    #service nginx restart
    service mysql restart
    service supervisord start
    echo_done "service start"
}

function config_system {
    echo_start "configure system"

    cd /etc/ssh
    ln -s -f $CFG_PATH/config/sshd_config

    cd /etc
    ln -s -f $CFG_PATH/config/supervisord.conf

    cd /etc/init.d
    ln -s -f $CFG_PATH/config/supervisord
    chmod +x /etc/init.d/supervisord
    sudo update-rc.d supervisord defaults
    
    #cd /etc/nginx
    #ln -s -f $CFG_PATH/config/nginx.conf nginx.conf
    #ln -s -f $CFG_PATH/config/htpasswd htpasswd
    
    cd /etc/nginx/sites-enabled
    ln -s -f $CFG_PATH/config/yeksatr.site.conf yeksatr.site.conf
    rm default
    #service nginx stop
    #chkconfig nginx off
    rm /etc/init.d/mysql
    mkdir -p /var/run/mysqld
    chown mysql:mysql /var/run/mysqld
    
    mkdir /var/log/yeksatr

    #TODO: clone git
    cd /srv
    git clone 
    
    cd /etc/mysql
    ln -s -f $CFG_PATH/config/my.cnf
   
    #initialize db schema 
    mysqladmin -u root password 123456
    mysql --user=root --password=123456 < $CFG_PATH/config/database.sql
    service mysql stop
    chkconfig mysql off
    rm /etc/init.d/mysql

    cd /var/spool/cron/crontabs
    ln -s -f $CFG_PATH/config/root.crontab root
    
    #setup_adminer
    
    echo_done "configure system"
}

function setup_backup_schedule() {
    echo "Not implemented yet"
}

function apt_get_install {
    if [[ $IS_VERBOSE == 0 ]] 
    then
        apt-get install -q -y $1 > /dev/null
    else
        apt-get install -y $1
    fi 
    
    echo_done $1
}

function echo_start {
    echo "> $1...Starting"
}

function echo_done {
    echo "> $1...Done"
}

function echo_section {
    echo ">>> $1"
}

