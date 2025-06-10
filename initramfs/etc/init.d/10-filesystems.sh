#!/bin/sh

. /etc/init.d/functions.sh

# Mount virtual filesystems before we get started
action "Mounting virtual filesystems" sh -c '
            mount -t proc proc /proc >/dev/null 2>&1 &&
            mount -t sysfs sysfs /sys >/dev/null 2>&1 &&
            mount -t devtmpfs devtmpfs >/dev/null 2>&1 /dev
            '

