#!/bin/bash

echo "* Test git gq backup"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_new"
TMPDIR="tmp_git_gq_backup"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "\$ git gq pop"
$GIT_GQ pop 2>&1| filter_git_head_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "\$ git gq backup"
$GIT_GQ backup 2>&1 | filter_pwd | filter_isodate_any | filter_squarebracket_end_hash

echo
echo "Created backup:"
echo "\$ git gq qrepo log -- --oneline | cat"
$GIT_GQ qrepo log -- --oneline | filter_isodate_any | filter_linestart_hash

echo
echo "Now create an extra, new file, 'NEW_FILE':"
echo "I am new" > NEW_FILE
echo "\$ git add NEW_FILE"
git add NEW_FILE
echo "\$ git commit -m 'NEW_FILE added'"
git commit -m 'NEW_FILE added' | filter_squarebracket_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "Now revert the patch queue directly:"
echo "$ git gq revert"
yes | $GIT_GQ revert 2>&1 | filter_git_head_hash | filter_quoted_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

