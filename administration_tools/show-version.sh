#!/bin/bash

ME=$(readlink -f "$0")
MYDIR=$(dirname "$ME")

cd "$MYDIR/.." || exit

if [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
    echo "usage: $0"
    echo
    echo "Shows the current version."
    exit 0
fi

FILES="doc/conf.py bin/git-gq"

for f in $FILES; do
    VER=$(grep '#VERSION#' "$f" | sed -e 's/^[^=]\+= *//;s/ #.*//;s/"//g' | sed -e "s/'//g")
    echo "$f: $VER"
done

