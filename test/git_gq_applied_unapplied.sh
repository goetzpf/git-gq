#!/bin/bash

echo "* Test git gq applied/unapplied"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_new"
TMPDIR="tmp_git_gq_applied_unapplied"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash

echo
echo "\$ git gq applied --lines 1"
$GIT_GQ applied --lines 1 | filter_linestart_hash

echo
echo "\$ git gq pop -a"
$GIT_GQ pop -a | filter_git_head_hash

echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "\$ git gq unapplied --lines 1"
$GIT_GQ unapplied --lines 1 | filter_linestart_hash

