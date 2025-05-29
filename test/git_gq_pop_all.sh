#!/bin/bash

echo "* Test git gq pop -a"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_pop_all"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "\$ git gq pop -a"
$GIT_GQ pop -a | filter_git_head_hash

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
FILE="README-was-improved.patch"
echo "# Content of patch file $FILE:"
cat .gqpatches/default/$FILE | filter_from_hash | filter_mail_from | filter_mail_date | filter_git_index_hash
echo
FILE="script.sh-was-improved.patch"
echo "# Content of patch file $FILE:"
cat .gqpatches/default/$FILE | filter_from_hash | filter_mail_from | filter_mail_date | filter_git_index_hash
