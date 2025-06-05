#!/bin/bash

echo "* Test git gq pop -a && git gq push -a"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_pop_all_push_all"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "\$ git gq pop -a"
$GIT_GQ pop -a 2>&1 | filter_git_head_hash

echo "\$ git gq push -a"
$GIT_GQ push -a 2>&1 | filter_git_head_hash

echo
echo "\$ git log"
git log | filter_commit_hash | filter_author | filter_mail_date

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
