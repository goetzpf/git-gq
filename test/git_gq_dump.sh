#!/bin/bash

echo "* Test git gq dump"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_pop"
TMPDIR="tmp_git_gq_dump"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "# Dump an applied patch."
echo "\$ git gq dump 'README was'"
$GIT_GQ dump 'README was' | filter_commit_hash | filter_author | filter_mail_date | filter_git_index_hash

echo
echo "# Dump an unapplied patch."
echo "\$ git gq dump 'script.sh-was'"
$GIT_GQ dump 'script.sh-was' | filter_from_hash | filter_mail_from | filter_mail_date

