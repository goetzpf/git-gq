#!/bin/bash

echo "* Test git gq import"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_import"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo
echo "# Change README.txt again ..."
echo "This file will describe my project." >> README.txt
echo "\$ git gq new My-README"
$GIT_GQ new My-README | filter_squarebracket_hash
echo "\$ git gq pop"
$GIT_GQ pop | filter_git_head_hash
echo "\$ cp .gqpatches/default/My-README.patch p1.patch"
cp .gqpatches/default/My-README.patch p1.patch
echo "\$ git gq delete My-README"
$GIT_GQ delete My-README

echo
echo "# Change script.sh ..."
echo "# some comment" >> script.sh
echo "\$ git gq new My-script"
$GIT_GQ new My-script | filter_squarebracket_hash
echo "\$ git gq pop"
$GIT_GQ pop | filter_git_head_hash
echo "\$ cp .gqpatches/default/My-script.patch p1.patch"
cp .gqpatches/default/My-script.patch p2.patch
echo "\$ git gq delete My-script"
$GIT_GQ delete My-script

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "# Now import both patch files p1.patch and p2.patch."
echo "\$ $GIT_GQ import p1.patch p2.patch"
$GIT_GQ import p1.patch p2.patch

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "\$ git gq push -a"
$GIT_GQ push -a 2>&1

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

