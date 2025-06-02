#!/bin/bash

echo "* Test git gq refresh"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_refresh"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "\$ git log"
git log | filter_commit_hash | filter_author | filter_mail_date

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
echo "# Change README.txt again ..."
echo "This file will describe my project." >> README.txt
echo "\$ git gq refresh"
$GIT_GQ refresh | filter_squarebracket_hash | filter_mail_date

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
echo "\$ git show HEAD"
git show HEAD | filter_commit_hash | filter_author | filter_mail_date | filter_git_index_hash

