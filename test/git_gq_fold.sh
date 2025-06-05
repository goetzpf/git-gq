#!/bin/bash

echo "* Test git gq fold"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_fold"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "# Change README.txt again ..."
echo "This file will describe my project." >> README.txt
echo "\$ git gq new README-fold"
$GIT_GQ new README-fold | filter_squarebracket_hash

echo
echo "\$ git show HEAD"
git show HEAD | filter_commit_hash | filter_author | filter_mail_date | filter_git_index_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo "\$ git gq pop"
echo "\$ git gq pop"
$GIT_GQ pop | filter_git_head_hash
$GIT_GQ pop | filter_git_head_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "\$ git show HEAD"
git show HEAD | filter_commit_hash | filter_author | filter_mail_date | filter_git_index_hash

echo
echo "\$ git gq fold README-fold"
$GIT_GQ fold README-fold 2>&1 | filter_squarebracket_hash | filter_mail_date | filter_git_head_hash

echo
echo "\$ git show HEAD"
git show HEAD | filter_commit_hash | filter_author | filter_mail_date | filter_git_index_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo "\$ git gq push -a"
$GIT_GQ push -a 2>&1 | filter_git_head_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash
