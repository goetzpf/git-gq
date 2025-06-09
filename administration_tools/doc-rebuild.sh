#!/bin/bash

ME=$(readlink -f "$0")
MYDIR=`dirname "$ME"`

DOCDIR=$(readlink -e "$MYDIR/../doc")
BINDIR=$(readlink -e "$MYDIR/../bin")

GIT_GQ="$BINDIR/git-gq"

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

