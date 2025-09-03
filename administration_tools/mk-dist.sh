#!/bin/bash
ME=$(readlink -f "$0")
MYDIR=`dirname "$ME"`

DOCDIR=$(readlink -e "$MYDIR/../src/git_gq/doc")

if [ ! -d "$DOCDIR" ]; then
    echo "Error: Run doc-rebuild.sh first"
    exit 1
fi

cd "$MYDIR/.."
# Note: module "build" for python must be installed for the following line.
# On Fedora and Debian this package is named "python3-build".
if ! python -m build; then
    echo "Error, 'python -m build' failed, maybe python3-build is not installed ?"
fi
