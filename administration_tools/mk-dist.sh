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
    echo "   --keep : Do not delete distribution directory after"
    echo "            the tar file is created."
    exit 0
fi

if [ "$1" == "--keep" ]; then
    keep="yes"
fi

if ! cd "$MYDIR/.."; then
    echo "Error, cd $MYDIR/.. failed" >&2
    exit 1
fi

if [ ! -d "doc/_build" ]; then
    echo "Run ./doc-rebuild.sh first">&2
    exit 1
fi


DISTDIR="git-gq-$(bin/git-gq --version)"
DISTPATH="dist/$DISTDIR"

mkdir -p dist
rm -rf "$DISTPATH" "$DISTPATH.tar.gz"
mkdir -p "$DISTPATH"

cp -a README.rst "$DISTPATH"
cp -a LICENSE "$DISTPATH"
sed -n '/^Install from distribution/,$p' INSTALL.rst > "$DISTPATH"/INSTALL.rst
cp -a bin "$DISTPATH"
mkdir -p "$DISTPATH"/man/man1
bin/git-gq doc | rst2man > "$DISTPATH"/man/man1/git-gq.1
mkdir -p "$DISTPATH"/profile.d
bin/git-gq bashcompletion > "$DISTPATH"/profile.d/git-gq.sh
cp "$MYDIR/install.sh" "$DISTPATH"
cp "$MYDIR/git-gq-uninstall.sh" "$DISTPATH"
cp -a doc/_build/html "$DISTPATH/doc"

(cd dist && tar -czf "$DISTDIR.tar.gz" "$DISTDIR")

if [ -z "$keep" ]; then
    rm -rf "$DISTPATH"
fi
