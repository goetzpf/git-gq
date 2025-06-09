#!/bin/bash

SCRIPT_FULL_NAME=$(readlink -e "$0")
MYDIR=$(dirname "$SCRIPT_FULL_NAME")
MYNAME=$(basename "$SCRIPT_FULL_NAME")

GLOBAL_DIR="/usr/local"

mode=""

if echo "$MYNAME" | grep -q uninstall; then
    # run uninstall as a default
    mode="uninstall"
fi

if [ -z "$mode" ]; then
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "$MYNAME : Installs git-gq"
        echo
        echo "Usage:"
        echo "  $MYNAME COMMAND ARGUMENT"
        echo
        echo "COMMAND may be:"
        echo "  install  : installs the program"
        echo "  uninstall: removes the program"
        echo
        echo "ARGUMENT:"
        echo "  global   : installs with sudo in $GLOBAL_DIR"
        echo "  DIRECTORY: installs in DIRECTORY"
        echo
        echo "OPTIONS may be:"
        echo
        echo "   -h --help: This help"
        exit 0
    fi
else
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        echo "$MYNAME : Uninstalls git-gq"
        echo
        echo "Usage:"
        echo "  $MYNAME"
        echo
        echo "OPTIONS may be:"
        echo
        echo "   -h --help: This help"
        exit 0
    fi
fi

cd "$MYDIR" || exit 1

if [ -z "$mode" ]; then
    COMMAND="$1"
    if [ -z "$COMMAND" ]; then
        echo "Error, no command given." >&2
        echo "Run $MYNAME -h for help." >&2
        exit 1
    fi
    ARG="$2"
    if [ -z "$ARG" ]; then
        echo "Error, no argument given." >&2
        echo "Run $MYNAME -h for help." >&2
        exit 1
    fi
else
    COMMAND="uninstall"
    if echo "$MYDIR" | grep -q "$GLOBAL_DIR"; then
        ARG="global"
    else
        ARG="$(readlink -e "$MYDIR/..")"
    fi
fi

if [ "$COMMAND" == "install" ]; then
    # install
    if [ "$ARG" == "global" ]; then
        sudo cp -a bin/git-gq  $GLOBAL_DIR/bin
        sudo cp -a "$SCRIPT_FULL_NAME" $GLOBAL_DIR/bin/git-gq-uninstall.sh
        sudo cp -a profile.d/git-gq.sh /etc/profile.d
        sudo mkdir -p $GLOBAL_DIR/share/man/man1
        sudo cp -a man/man1/git-gq.1 $GLOBAL_DIR/share/man/man1
        sudo mkdir -p $GLOBAL_DIR/share/git-gq
        sudo cp -a doc $GLOBAL_DIR/share/git-gq
        echo "git-gq was installed at $GLOBAL_DIR"
        echo
        echo "Final notes:"
        echo
        echo "HTML documentation is found at"
        echo "file://$GLOBAL_DIR/share/git-gq"
        echo
        echo "and"
        echo
        echo "https://goetzpf.github.io/git-gq"
        echo
        echo "Uninstall with:"
        echo
        echo "$GLOBAL_DIR/bin/git-gq-uninstall.sh uninstall global"
        exit 0
    fi
    # interpret "$ARG" as a directory
    INSTALLDIR="$ARG"
    if [ ! -d "$INSTALLDIR" ]; then
        echo "Directory $INSTALLDIR doesn't exist."
        read -p "Enter 'y' or 'Y' to create it, everything else aborts " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
        mkdir -p "$INSTALLDIR"
    fi
    mkdir -p "$INSTALLDIR/bin"
    mkdir -p "$INSTALLDIR/profile.d"
    mkdir -p "$INSTALLDIR/man/man1"
    mkdir -p "$INSTALLDIR/share/git-gq"
    cp -a bin/git-gq  "$INSTALLDIR/bin"
    cp -a "$SCRIPT_FULL_NAME" "$INSTALLDIR/bin/git-gq-uninstall.sh"
    cp -a profile.d/git-gq.sh "$INSTALLDIR/profile.d"
    cp -a man/man1/git-gq.1 "$INSTALLDIR/man/man1"
    cp -a doc "$INSTALLDIR/share/git-gq"
    echo "git-gq was installed at $INSTALLDIR"
    echo
    echo "Final notes:"
    echo "Directory $INSTALLDIR/bin should be in your PATH."
    echo "To have command completion, add this line to your .bashrc file:"
    echo
    echo "source $INSTALLDIR/profile.d/git-gq.sh"
    echo
    echo "To find the man page do:"
    echo
    echo "MANPATH=:$INSTALLDIR/man"
    echo 
    echo "HTML documentation is found at"
    echo "file://$INSTALLDIR/share/git-gq" 
    echo
    echo "and"
    echo
    echo "https://goetzpf.github.io/git-gq"
    echo
    echo "Uninstall with:"
    echo
    echo "$INSTALLDIR/bin/git-gq-uninstall.sh uninstall"
    exit 0
fi
if [ "$COMMAND" == "uninstall" ]; then
    # uninstall
    if [ "$ARG" == "global" ]; then
        echo "Uninstall program from $GLOBAL_DIR ?"
        read -p "Enter 'y' or 'Y' to create it, everything else aborts " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
        sudo rm $GLOBAL_DIR/bin/git-gq
        sudo rm $GLOBAL_DIR/bin/git-gq-uninstall.sh
        sudo rm /etc/profile.d/git-gq.sh
        sudo rm $GLOBAL_DIR/share/man/man1/git-gq.1
        sudo rm -rf $GLOBAL_DIR/share/git-gq
        exit 0
    fi
    # interpret "$ARG" as a directory
    INSTALLDIR="$ARG"
    if [ -z "$ARG" ]; then
        # try directory taken from script location instead:
        INSTALLDIR="$(readlink -e "$MYDIR/..")"
    fi
    if [ ! -d "$INSTALLDIR" ]; then
        echo "Error, directory '$INSTALLDIR' doesn't exist." >&2
        exit 1
    fi
    if [ ! -e "$INSTALLDIR/bin/git-gq" ]; then
        echo "Error, git-gq not found in '$INSTALLDIR/bin'." >&2
        exit 1
    fi
    echo "Uninstall program from $INSTALLDIR ?"
    read -p "Enter 'y' or 'Y' to create it, everything else aborts " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
    rm "$INSTALLDIR/bin/git-gq"
    rm "$INSTALLDIR/bin/git-gq-uninstall.sh"
    rm "$INSTALLDIR/profile.d/git-gq.sh"
    rm "$INSTALLDIR/man/man1/git-gq.1"
    rm -rf "$INSTALLDIR/share/git-gq"
    exit 0
fi
echo "Unknown command: '$COMMAND'" >&2
exit 1

