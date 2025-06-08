#!/bin/bash

echo "* Test git gq qname"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_qname"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "\$ git gq qname"
$GIT_GQ qname

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "# Create another queue."
echo "\$ git gq qname queue2"
$GIT_GQ qname queue2 | filter_parenthesis_hash

echo
echo "# Change README.txt again ..."
echo "This file will describe my project." >> README.txt
echo "\$ git gq new README-was-extended"
$GIT_GQ new README-was-extended | filter_squarebracket_hash

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
echo "# Switch back to 'default' queue."
echo "\$ git gq qname default"
$GIT_GQ qname default

echo
echo "\$ git log"
git log | filter_commit_hash | filter_author | filter_mail_date

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

