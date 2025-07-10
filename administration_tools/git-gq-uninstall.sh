#!/bin/bash

SCRIPT_FULL_NAME=$(readlink -e "$0")
MYDIR=$(dirname "$SCRIPT_FULL_NAME")
MYNAME=$(basename "$SCRIPT_FULL_NAME")

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "$MYNAME : Uninstalls git-gq"
    echo
    echo "Usage:"
    echo "  $MYNAME [OPTIONS]"
    echo
    echo "OPTIONS:"
    echo "   -h --help: This help"
    exit 0
fi

if ! cd "$MYDIR"; then
    echo "Error, chdir $MYDIR failed" >&2
    exit 1
fi

if echo "$MYDIR" | grep -q '^/usr'; then
    etcdir="/etc/profile.d"
else
    etcdir="$TOPDIR/profile.d"
fi

if basename "$(pwd)" != "bin"; then
    echo "Error, script not installed in 'bin' sub-directory, cannot continue" >&2
    exit 1
fi

if ! cd "$MYDIR/.."; then
    echo "Error, chdir $MYDIR/.. failed" >&2
    exit 1
fi

TOPDIR="$(readlink -e "$(pwd)")"

echo "Uninstall git-gq ?"
read -p "Enter 'y' or 'Y' to uninstall, everything else aborts " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

rm "$TOPDIR/bin/git-gq"
rm "$TOPDIR/bin/git-gq-uninstall.sh"
rm "$etcdir/git-gq.sh"
rm "$TOPDIR/share/man/man1/git-gq.1"
rm -rf "$TOPDIR/share/git-gq"

echo "Uninstall finished"

# Delete myself:
rm -- "$SCRIPT_FULL_NAME"
