# Common variables that need to shared
HOSTNAME=arty-z7
USERNAME=castillo
BOOT_PASS=0
ROOT_PASS=1
ETH_DEV=end0
TIMEZONE="America/Denver"

log_err () {
    local msg
    msg="${1}"
    builtin printf 'Error: %s\n' "${msg}" >&2
    return
}


log_info () {
    local msg
    msg="${1}"
    builtin printf 'Info: %s\n' "${msg}" >&1
    return
}

