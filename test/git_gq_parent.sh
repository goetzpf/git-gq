#!/bin/bash

echo "* Test git gq parent"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_parent"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "\$ git gq parent"
$GIT_GQ parent | filter_linestart_hash

echo
echo "# Set parent to revision with log 'README was'."
REV=$(GIT_PAGER=cat git log --oneline | grep 'README was' | sed -e 's/ .*//')
echo "\$ git gq parent REV"
$GIT_GQ parent "$REV" | filter_set_to_hash

echo
echo "\$ git gq parent"
$GIT_GQ parent | filter_linestart_hash

