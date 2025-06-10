#!/bin/sh

# Hook us up to the console before launching a shell
exec </dev/console >/dev/console 2>&1

printf '%s\n' "Shell running on $(tty)" >&1
printf '%s\n' "Type 'busybox --help' for help" >&1
printf '\n'

# Launch busybox (via sh) as a login shell, so it'll pick up /etc/profile and
# others
exec /bin/sh +m --login

