#!/bin/sh

# Create console device if needed
[ -c /dev/ttyPS0 ] || mknod /dev/ttyPS0 c 5 1

# Hook us up to the console before launching a shell
exec </dev/ttyPS0 >/dev/ttyPS0 2>&1

printf '%s\n' "Shell running on $(tty)" >&1
printf '%s\n' "Type 'busybox --help' for help" >&1
printf '\n'

# Set up new session and controlling terminal
exec setsid /bin/sh -c 'exec /bin/sh </dev/ttyPS0 >/dev/ttyPS0 2>&1 --login'

# # Launch busybox (via sh) as a login shell, so it'll pick up /etc/profile and
# # others
# exec /bin/sh +m --login


# # Redirect stdin/out/err to console
# exec </dev/console >/dev/console 2>&1


