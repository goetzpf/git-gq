#!/bin/bash

SCRIPT_FULL_NAME=$(readlink -e "$0")
MYDIR=$(dirname "$SCRIPT_FULL_NAME")
MYNAME=$(basename "$SCRIPT_FULL_NAME")

SRCDIR=$(readlink -e "$MYDIR/../src/git_gq")
GIT_GQ="$SRCDIR/git_gq.py"

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


DISTDIR="git-gq-$(python $GIT_GQ --version)"
DISTPATH="dist-github/$DISTDIR"

rm -rf "dist-github"
mkdir -p "$DISTPATH"

cp -a README.rst "$DISTPATH"
cp -a LICENSE "$DISTPATH"
sed -n '/^Install from distribution/,$p' INSTALL.rst > "$DISTPATH"/INSTALL.rst
mkdir -p "$DISTPATH/bin"
cp -a $GIT_GQ "$DISTPATH/bin/git-gq"
mkdir -p "$DISTPATH"/man/man1
python $GIT_GQ doc | rst2man > "$DISTPATH"/man/man1/git-gq.1
cp "$MYDIR/install.sh" "$DISTPATH"
cp "$MYDIR/git-gq-uninstall.sh" "$DISTPATH"
cp -a doc/_build/html "$DISTPATH/doc"

(cd dist-github && tar -czf "$DISTDIR.tar.gz" "$DISTDIR")

if [ -z "$keep" ]; then
    rm -rf "$DISTPATH"
fi
