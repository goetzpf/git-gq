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
    sudo cp -a bin/git-gq  /usr/local/bin
    sudo cp -a profile.d/git-gq.sh /etc/profile.d
    sudo mkdir -p /usr/local/share/man/man1
    sudo cp -a man/man1/git-gq.1 /usr/local/share/man/man1
    sudo mkdir -p /usr/local/share/git-gq
    sudo cp -a html /usr/local/share/git-gq
    exit 0
fi
if [ "$1" == "local" ]; then
    DIR="$2"
    if [ -z "$DIR" ]; then
        echo "Error, DIRECTORY is missing." >&2
        exit 1
    fi
    if [ ! -d "$DIR" ]; then
        echo "Error, directory $DIR doesn't exist." >&2
        exit 1
    fi
    mkdir -p "$DIR/bin"
    cp -a bin/git-gq  "$DIR/bin"
    mkdir -p "$DIR/profile.d"
    sudo cp -a profile.d/git-gq.sh "$DIR/profile.d"
    mkdir -p "$DIR/man/man1"
    cp -a man/man1/git-gq.1 "$DIR/man/man1"
    mkdir -p "$DIR/share/git-gq"
    cp -a html "$DIR/share/git-gq"
    exit 0
fi


