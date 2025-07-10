#!/bin/bash

echo "* Test git gq pop /push with NULL parent"
echo "----------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_pop_push_null"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "\$ ls"
ls

echo
echo "\$ git status --porcelain"
git status --porcelain

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "Set parent to 'NULL'."
echo "\$ git gq parent NULL"
$GIT_GQ parent NULL

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "Now unapply all patches."
echo "\$ git gq pop -a"
$GIT_GQ pop -a | filter_git_head_hash | filter_squarebracket_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "\$ ls"
ls

echo
echo "\$ git status --porcelain"
git status --porcelain

echo
echo "Now apply all patches."
echo "\$ git gq push -a"
$GIT_GQ push -a | filter_git_head_hash | filter_squarebracket_hash | filter_mail_date

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "\$ ls"
ls

echo
echo "\$ git status --porcelain"
git status --porcelain

