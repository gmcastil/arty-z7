#!/bin/sh

# Launch busybox (via sh) as a login shell, so it'll pick up /etc/profile and
# others
exec /bin/sh +m --login

