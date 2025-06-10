#!/bin/sh

ansi_red="$(printf '\033[1;31m')"
ansi_green="$(printf '\033[1;32m')"
ansi_yellow="$(printf '\033[1;33m')"
ansi_normal="$(printf '\033[0m')"

success () {
    printf '[ %sOK%s ]\n' ${ansi_green} ${ansi_normal} >&1
}

fail () {
    printf '[%sFAIL%s]\n' ${ansi_red} ${ansi_normal} >&1
}

warn () {
    printf '[%sWARN%s]\n' ${ansi_yellow} ${ansi_normal} >&1
}

action () {
    desc="${1}"
    shift
    printf '%-40s' "${desc}" >&1
    "$@" >/dev/null 2>&1
    status=$?
    if [ ${status} -eq 0 ]; then
        success
    else
        fail
    fi
    return
}

