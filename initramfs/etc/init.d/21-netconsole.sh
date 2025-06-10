#!/bin/sh

. /etc/init.d/functions.sh

netcon_server_port=6667
netcon_client_ip=192.168.0.84
netcon_client_port=6667

netcon_cmd_str="netconsole=${netcon_server_port}@/eth0,${netcon_client_port}@${netcon_client_ip}/"

action "Starting netconsole for ${netcon_client_port}@${netcon_client_ip}" \
    modprobe netconsole "${netcon_cmd_str}"

