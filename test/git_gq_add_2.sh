#!/bin/bash

echo "* Add two more patches after 'git gq init'"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_init"
TMPDIR="tmp_git_gq_add_2"


cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "# Change README.txt ..."
echo "This is an improved README file." > README.txt
echo "\$ git commit"
git commit -a -m 'README was improved.' 2>&1 | filter_squarebracket_hash | filter_commit_hash
echo
echo "# Change script.sh ..."
sed -i -e 's/^echo.*/echo "Script prototype"/' script.sh
echo "\$ git commit"
git commit -a -m 'script.sh was improved.'  2>&1 | filter_squarebracket_hash | filter_commit_hash
echo
echo "\$ git log"
git log | filter_commit_hash | filter_author | filter_mail_date
echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash


