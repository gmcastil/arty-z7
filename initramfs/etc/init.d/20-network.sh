#!/bin/sh

. /etc/init.d/functions.sh

eth_dev='eth0'
udhcpc_script="/usr/share/udhcpc/default.script"

action "Bringing up ethernet device ${eth_dev}" sh -c "ip link set ${eth_dev} up"
action "Obtaining IP address via DHCP" sh -c "udhcpc -i ${eth_dev} -s ${udhcpc_script}"

