#!/bin/sh

. /etc/init.d/functions.sh

# Mount virtual filesystems before we get started
action "Mounting NFS shares" sh -c 'mount -t nfs -o nolock,ro 192.168.0.3:/srv/nfs4/storage /storage'

