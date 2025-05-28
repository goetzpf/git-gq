#!/bin/bash

# add two more patches after 'git gq init'

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_pop"

echo "Run 'git gq pop'"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

$GIT_GQ pop 2>&1 | filter_git_head_hash

echo "Output of 'git log' now:"
git log | filter_commit_hash | filter_author | filter_mail_date

echo "Files in .gqpatches:"
find .gqpatches/default | sort
echo "Content of patch file:"
cat .gqpatches/default/script.sh-was-improved.patch | filter_from_hash | filter_mail_from | filter_mail_date | filter_git_index_hash
