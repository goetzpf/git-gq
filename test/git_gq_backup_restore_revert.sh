#!/bin/bash

echo "* Test git gq backup/restore/revert"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_backup_restore_revert"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo
echo "-------------------------------------------------"
echo "state at the beginning"
echo "-------------------------------------------------"
echo

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
echo "-------------------------------------------------"
echo "do backup, then modifiy patches"
echo "-------------------------------------------------"
echo

echo
echo "\$ git backup"
$GIT_GQ backup 2>&1 | filter_pwd | filter_isodate_any | filter_squarebracket_end_hash

echo "\$ git gq pop -a"
$GIT_GQ pop -a 2>&1 | filter_git_head_hash

echo
echo "# Invert order of patches"
SF=".gqpatches/default/series"
tac "$SF" > "$SF.new" && rm -f "$SF" && mv "$SF.new" "$SF"

echo
echo "\$ git gq push -a"
$GIT_GQ push -a 2>&1 | filter_git_head_hash

echo
echo "# Change README.txt again ..."
echo "This file will describe my project." >> README.txt
echo "\$ git gq new README-was-extended"
$GIT_GQ new README-was-extended | filter_squarebracket_hash

echo "\$ git gq pop"
$GIT_GQ pop 2>&1 | filter_git_head_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "-------------------------------------------------"
echo "restore patches"
echo "-------------------------------------------------"
echo

echo
echo "Now restore."
echo "\$git gq restore HEAD"
$GIT_GQ restore HEAD 2>&1 | filter_quoted_hash | filter_git_head_hash | filter_isodate_any

echo
echo "Now revert."
echo "\$git gq revert"
yes | $GIT_GQ revert

echo
echo "-------------------------------------------------"
echo "Final state"
echo "-------------------------------------------------"
echo
echo "\$ git log"
git log | filter_commit_hash | filter_author | filter_mail_date

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

