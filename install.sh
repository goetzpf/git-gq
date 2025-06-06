#!/bin/bash

SCRIPT_FULL_NAME=$(readlink -e "$0")
MYDIR=$(dirname "$SCRIPT_FULL_NAME")
MYNAME=$(basename "$SCRIPT_FULL_NAME")

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "$MYNAME : Installs git-gq"
    echo
    echo "Usage:"
    echo "  $MYNAME COMMAND [ARGS]"
    echo
    echo "COMMAND may be:"
    echo "  global : installs with sudo in /usr/local"
    echo "  local DIRECTORY: installs in DIRECTORY"
    echo
    echo "OPTIONS may be:"
    echo
    echo "   -h --help: This help"
    exit 0
fi

cd "$MYDIR" || exit 1

if [ "$1" == "gobal" ]; then
    sudo cp bin/git-gq  /usr/local/bin
    sudo bin/git-gq bashcompletion > /etc/profile.d/git-gq.sh
    exit 0
fi
if [ "$1" == "local" ]; then
    if [ -z "$2" ]; then
        echo "Error, DIRECTORY is missing." >&2
        exit 1
    fi
    if [ ! -d "$2" ]; then
        echo "Error, directory $2 doesn't exist." >&2
        exit 1
    fi
    cp bin/git-gq "$2"
fi


