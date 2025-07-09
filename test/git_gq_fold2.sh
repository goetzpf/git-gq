#!/bin/bash

echo "* Test git gq fold"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_fold2"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo
echo "-------------------------------------------------"
echo "initial state"
echo "-------------------------------------------------"
echo

echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "-------------------------------------------------"
echo "create two fold patches, README-fold, README-fold2"
echo "-------------------------------------------------"
echo

echo
echo "# Change README.txt again ..."
echo "This file will describe my project." >> README.txt
echo "\$ git gq new README-fold"

$GIT_GQ new README-fold | filter_squarebracket_hash

echo "# Add a file named 'extra.txt'."
echo "New file" > extra.txt
echo "\$git add extra.txt"
git add extra.txt
echo "Delete file 'script.sh'."
git rm script.sh
echo "Rename README.txt to README2.txt"
echo "\$ git mv README.txt README2.txt"
git mv README.txt README2.txt

echo "\$ git gq new README-fold2"
$GIT_GQ new README-fold2 | filter_squarebracket_hash

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
echo "-------------------------------------------------"
echo "fold README-fold"
echo "-------------------------------------------------"
echo

echo
echo "\$ git gq fold README-fold.patch"
$GIT_GQ fold README-fold.patch 2>&1 | filter_squarebracket_hash | filter_mail_date | filter_git_head_hash

echo
echo "\$ git show HEAD"
git show HEAD | filter_commit_hash | filter_author | filter_mail_date | filter_git_index_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "-------------------------------------------------"
echo "fold README-fold2"
echo "-------------------------------------------------"
echo

echo
echo "\$ git gq fold README-fold2"
$GIT_GQ fold README-fold2 2>&1 | filter_squarebracket_hash | filter_mail_date | filter_git_head_hash

echo
echo "\$ git show HEAD"
git show HEAD | filter_commit_hash | filter_author | filter_mail_date | filter_git_index_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

