#!/bin/bash

SCRIPT_FULL_NAME=$(readlink -e "$0")
MYDIR=$(dirname "$SCRIPT_FULL_NAME")
MYNAME=$(basename "$SCRIPT_FULL_NAME")

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "$MYNAME : create files for distribution."
    echo
    echo "Usage:"
    echo "  $MYNAME [OPTIONS]"
    echo
    echo "OPTIONS may be:"
    echo
    echo "   -h --help: This help"
    exit 0
fi

cd "$MYDIR/.."

if [ ! -d "doc/_build" ]; then
    echo "Run ./doc-rebuild.sh first">&2
    exit 1
fi

rm -rf dist
mkdir -p dist
cp -a bin dist
mkdir -p dist/man/man1
bin/git-gq doc | rst2man > dist/man/man1/git-gq.1
mkdir -p dist/profile.d
bin/git-gq bashcompletion > dist/profile.d/git-gq.sh
cp "$MYDIR/install.sh" dist
cp -a doc/_build/html dist
