#!/usr/bin/env bash
source ./provision.methods.sh

function setup_adminer() {

    mkdir -p /srv/main/nginx/adminer
    cd /srv/main/nginx/adminer
    
    ln -s -f $CFG_PATH/config/adminer.php adminer.php
    ln -s -f $CFG_PATH/config/adminer.css adminer.css
    
    cd /etc/nginx/sites-enabled
    ln -s -f $CFG_PATH/config/adminer.site.conf
    sed -i "s/yeksatr.io/$HOST_DOMAIN/" adminer.site.conf 
}

#this is not needed for live website. Only here for development server
function setup_traq() {
    mkdir -p /srv/main/nginx/traq
    cd /tmp
    wget --quiet http://sourceforge.net/projects/traq/files/3.x/traq-3.5.2.tar.gz
    tar xf traq-3.5.2.tar.gz
    cp upload/* /srv/main/nginx/traq -r
    
    cd /etc/nginx/sites-enabled
    ln -s -f $CFG_PATH/config/traq.site.conf
    sed -i "s/yeksatr.io/$HOST_DOMAIN/" traq.site.conf 
}

