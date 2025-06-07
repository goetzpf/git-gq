#!/bin/bash

SCRIPT_FULL_NAME=$(readlink -e "$0")
MYDIR=$(dirname "$SCRIPT_FULL_NAME")
#MYNAME=$(basename "$SCRIPT_FULL_NAME")

GITREPO="git@github.com:goetzpf/git-gq.git"

if [ ! -d "$MYDIR/../doc" ]; then
    echo "Error, 'doc' directory doesn't exist." >&2
    exit 1
fi

DOCDIR=$(readlink -e "$MYDIR/../doc")
HTMLDIR="$DOCDIR/_build/html"

GH_PAGES_SHORT_DIR="git-gq-pages"

GH_PAGES_DIR="$MYDIR/$GH_PAGES_SHORT_DIR"

if [ -z "$DOCDIR" ]; then
    echo "error, directory 'doc' not found"
    exit 1
fi

if [ ! -d "$HTMLDIR" ]; then
    echo "Error, html documentation is not yet built." >&2
    exit 1
fi

if [ ! -d "$GH_PAGES_DIR" ]; then
    git clone -b gh-pages "$GITREPO" "$GH_PAGES_DIR"
else
    git -C "$GH_PAGES_DIR" pull
fi

rm -f "$GH_PAGES_DIR/*.html" "$GH_PAGES_DIR/*.inv" "$GH_PAGES_DIR/*.js"
rm -rf "$GH_PAGES_DIR/_sources" "$GH_PAGES_DIR/_static"
echo "cp -a $HTMLDIR/* \"$GH_PAGES_DIR\""
cp -a $HTMLDIR/* "$GH_PAGES_DIR"
git -C "$GH_PAGES_DIR" add --all

echo "Now enter:"
echo
echo "git -C $GH_PAGES_SHORT_DIR status"
echo "git -C $GH_PAGES_SHORT_DIR commit"
echo "git -C $GH_PAGES_SHORT_DIR push"


