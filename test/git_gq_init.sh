#!/bin/bash

echo "* Test git gq init"
echo "---------------------------------------"
echo

source util.sh

GIT_GQ="$1"

TMPDIR="tmp_git_gq_init"

cp -a repo $TMPDIR

cd $TMPDIR || exit 1

echo "\$ git gq init"
$GIT_GQ init 2>&1 | filter_parenthesis_hash
echo
echo "# Files in directory .gqpatches:"
find .gqpatches
echo
echo "\$ git gq applied"
$GIT_GQ applied
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied
