#!/bin/bash

echo "* Test git gq pop when git has started tracking .gqpatches"
echo "----------------------------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_pop_tracking_err"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "\$ git gq pop"
$GIT_GQ pop 2>&1 | filter_git_head_hash

echo
echo "# Change README.txt again ..."
echo "This file will describe my project." >> README.txt

echo
echo "# Now deliberatly add .gqpatches to git stash"
echo "\$ git add .gqpatches"
git add .gqpatches

echo
echo "# Add README.txt."
echo "\$ git add README.txt"
git add README.txt

echo
echo "\$ git commit -m 'Changes in README.txt'."
git commit -m 'Changes in README.txt' | filter_squarebracket_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash

echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "# Files in .gqpatches:"
find .gqpatches | sort


echo "\$ git gq pop"
$GIT_GQ pop 2>&1 | filter_git_head_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash

echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "# Files in .gqpatches:"
find .gqpatches | sort

echo
echo "# Fix the problem as described in the error message:"
echo "\$ git reset HEAD~1 .gqpatches"
git reset HEAD~1 .gqpatches
echo "\$ git commit -C HEAD --amend"
git commit -C HEAD --amend | filter_squarebracket_hash | filter_mail_date

echo "# Now run git gq pop again:"
echo "\$ git gq pop"
$GIT_GQ pop 2>&1 | filter_git_head_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash

echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "# Files in .gqpatches:"
find .gqpatches | sort
