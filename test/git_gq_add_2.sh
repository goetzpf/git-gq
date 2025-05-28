#!/bin/bash

# add two more patches after 'git gq init'

#GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_init"
TMPDIR="tmp_git_gq_add_2"

echo "Add two more patches after 'git gq init'"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "This is an improved README file." > README.txt
git commit -a -m 'README was improved.' 2>&1 | filter_squarebracket_hash | filter_commit_hash
sed -i -e 's/^echo.*/echo "Script prototype"/' script.sh
git commit -a -m 'script.sh was improved.'  2>&1 | filter_squarebracket_hash | filter_commit_hash
echo "Output of 'git log' now:"
git log | filter_commit_hash | filter_author | filter_mail_date


