#!/bin/bash

echo "* Test git gq show"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_new"
TMPDIR="tmp_git_gq_show"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "# Dump an applied patch."
echo "\$ git gq show 'README'"
$GIT_GQ show 'README' 2>&1 | filter_commit_hash | filter_author | filter_mail_date | filter_git_index_hash

echo
echo "\$ git gq pop -a"
$GIT_GQ pop -a | filter_git_head_hash

echo
echo "# Dump an unapplied patch."
echo "\$ git gq show 'README'"
$GIT_GQ show 'README' 2>&1 | filter_from_hash | filter_mail_from | filter_mail_date

echo
echo "# Dump an HEAD commit."
echo "\$ git gq show 'HEAD'"
$GIT_GQ show 'HEAD' 2>&1 | filter_commit_hash | filter_author | filter_mail_date | filter_git_index_hash
