#!/bin/bash

ME=$(readlink -f "$0")
MYDIR=`dirname "$ME"`

DOCDIR=$(readlink -e "$MYDIR/../doc")
SRCDIR=$(readlink -e "$MYDIR/../src/git_gq")

GIT_GQ="$SRCDIR/git_gq.py"

if [ -z "$DOCDIR" ]; then
    echo "error, directory 'doc' not found"
    exit 1
fi

cd "$DOCDIR" || exit

function mk_rst {
    # $1: Heading
    # $2: Filename and section name
    #echo "$1" > "$2.rst"
    #echo "$1" | sed -e 's/./=/g' >> "$2.rst"
    #echo >> "$2.rst"
    $GIT_GQ doc "$2" > "$2.rst"
}

make clean -s

cp ../INSTALL.rst install.rst
mk_rst "Overview" "overview"
mk_rst "Implementation" "implementation"
mk_rst "Conflicts" "conflicts"
mk_rst "Examples" "examples"
mk_rst "Command line" "commandline"

make html

for d in doc man profile_d; do
    if [ -d "$d" ]; then
        rm -rf "$d"
    fi
done

mkdir -p "$SRCDIR/doc"

cp -a "$MYDIR/../README.rst" $SRCDIR/doc
cp -a "$MYDIR/../LICENSE" $SRCDIR/doc

mkdir -p "$SRCDIR/doc/rst"
cp -a *.rst "$SRCDIR/doc/rst"

mkdir -p "$SRCDIR/doc/html"
cp -a _build/html/* "$SRCDIR/doc/html"

mkdir -p "$SRCDIR/man/man1"
$GIT_GQ doc | rst2man > "$SRCDIR"/man/man1/git-gq.1
echo "# Dummy for Python 3.9 bug in importlib.resources.files()" > "$SRCDIR"/man/man1/__init__.py

mkdir -p "$SRCDIR/profile_d"
$GIT_GQ completion > "$SRCDIR"/profile_d/git-gq.sh

