#!/bin/bash

ME=$(readlink -f "$0")
MYDIR=$(dirname "$ME")

SRCDIR=$(readlink -e "$MYDIR/../src/git_gq")

cd "$SRCDIR" || exit 1

for d in doc man profile_d; do
    if [ -d "$d" ]; then
        rm -rf "$d"
    fi
done

