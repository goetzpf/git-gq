#!/bin/bash

echo "* Test git gq delete"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_new"
TMPDIR="tmp_git_gq_delete"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "\$ git gq pop -a"
$GIT_GQ pop -a | filter_git_head_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "# Files in .gqpatches:"
find .gqpatches/default | sort

echo
echo "\$ git gq delete 'script was'"
$GIT_GQ delete 'script was' 2>&1| filter_git_head_hash

echo
echo "\$ git gq delete 'script.sh-was'"
$GIT_GQ delete 'script.sh-was' 2>&1| filter_git_head_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "# Files in .gqpatches:"
find .gqpatches/default | sort
