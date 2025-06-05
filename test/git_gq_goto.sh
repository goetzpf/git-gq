#!/bin/bash

echo "* Test git gq goto"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_new"
TMPDIR="tmp_git_gq_goto"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "# git gq goto to an applied patch"
echo "\$ git gq goto 'README was'"
$GIT_GQ goto 'README was' | filter_git_head_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "# git gq goto to an unapplied patch"
echo "\$ git gq goto 'was-extended'"
$GIT_GQ goto 'was-extended' 2>&1 | filter_git_head_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

