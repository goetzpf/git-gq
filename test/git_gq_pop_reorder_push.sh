#!/bin/bash

echo "* Test git gq pop -a; reorder patches;  git gq push -a"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_pop_reorder_push"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo
echo "\$ git log"
git log | filter_commit_hash | filter_author | filter_mail_date

echo "\$ git gq pop -a"
$GIT_GQ pop -a 2>&1 | filter_git_head_hash

echo
echo "# Invert order of patches"
SF=".gqpatches/default/series"
tac "$SF" > "$SF.new" && rm -f "$SF" && mv "$SF.new" "$SF"

echo
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
