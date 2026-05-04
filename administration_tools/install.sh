#!/bin/bash

SCRIPT_FULL_NAME=$(readlink -e "$0")
MYDIR=$(dirname "$SCRIPT_FULL_NAME")
MYNAME=$(basename "$SCRIPT_FULL_NAME")

GLOBAL_DIR="/usr/local"

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "$MYNAME : Installs git-gq"
    echo
    echo "Usage:"
    echo "  $MYNAME [DIRECTORY] [OPTIONS]"
    echo
    echo "DIRECTORY:"
    echo "  if given, install in DIRECTORY/bin"
    echo "  if not given, install in /usr/local/bin"
    echo "OPTIONS may be:"
    echo
    echo "   -h --help: This help"
    exit 0
fi

if ! cd "$MYDIR"; then
    echo "Error, chdir $MYDIR failed" >&2
    exit 1
fi

TOPDIR="$1"

if [ -z "$TOPDIR" ]; then
    TOPDIR="$GLOBAL_DIR"
fi

if ! install -D bin/git-gq -t "$TOPDIR/bin"; then
    echo "Cannot install, maybe you should use 'sudo' ?" >&2
    exit 1
fi
install -D git-gq-uninstall.sh -t "$TOPDIR/bin"
install -D -m 644 man/man1/git-gq.1 -t "$TOPDIR/man/man1"
install -D -d doc "$TOPDIR/share/git-gq"
cp -a doc/* "$TOPDIR/share/git-gq"
chmod a+r "$TOPDIR/share/git-gq"

echo "git-gq was installed in the following directories:"
echo "    $TOPDIR/bin"
echo "    $TOPDIR/man/man1"
echo "    $TOPDIR/share/git-gq"
echo
echo
echo "Final notes:"
echo "Directory $TOPDIR/bin should be in your PATH."
echo "To have bash completion, add this line to your .bashrc file for bash or"
echo ".zshrc file for zsh:"
echo
echo 'eval "$(git-gq completion)"'
echo
echo "To find the man page do:"
echo
echo "MANPATH=:$TOPDIR/man"
echo 
echo "HTML documentation is found at"
echo "file://$TOPDIR/share/git-gq" 
echo
echo "and"
echo
echo "https://goetzpf.github.io/git-gq"
echo
echo "Uninstall with:"
echo
echo "$TOPDIR/bin/git-gq-uninstall.sh uninstall"

