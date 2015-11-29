#!/usr/bin/env bash
source ./provision.methods.sh

echo "*** Starting provisioning process... ***"

if [ -n "${VERBOSE_PROVISION+1}" ] 
then
    IS_VERBOSE=1
    echo "*** Running in verbose mode ***"
fi

init_system
echo_section "Installing System Packages"
install_sys_packages

echo_section "Cleaning Up"
cleanup_system

echo_section "Configuring System"
config_system

echo_section "Starting Services"
start_services

echo_section "Finalizing Configuration"
setup_firewall

echo "*** Provisioning finished ***"


