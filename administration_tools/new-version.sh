#!/bin/bash

ME=$(readlink -f "$0")
MYDIR=$(dirname "$ME")

cd "$MYDIR/.."

if [ -z "$1" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
    echo "usage: $0 <version-string>"
    echo "patches the version strings in all parts of the project"
    exit 0
fi

VERSION="$1"

if ! echo "$VERSION" | grep -q '^[0-9\.]\+$'; then
    echo "Error, '$VERSION' doesn't seem to be a valid version number." >&2
    exit 1
fi

FILES="doc/conf.py bin/git-gq"

for f in $FILES; do
    sed -i -e "s/^\([^'\"]\+\)\(['\"]\)[^'\"]\+\(['\"]\)\( *#VERSION#\) *$/\1\2$VERSION\3\4/" $f
done

git add $FILES
git commit -m "The version was changed to $VERSION."
git tag -a "$VERSION" -m "The version was changed to $VERSION."

