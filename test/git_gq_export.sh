#!/bin/bash

echo "* Test git gq export"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_export"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

mkdir "patchdir"

echo "\$ git gq export patchdir"
$GIT_GQ export patchdir | filter_pwd

echo
echo "\$ ls patchdir"
ls patchdir

echo
echo "# Content of patchfiles:"
for f in patchdir/*.patch; do
    echo "---------------------"
    echo "File: $f"
    cat $f | filter_from_hash | filter_mail_from | filter_mail_date | filter_git_index_hash
done

