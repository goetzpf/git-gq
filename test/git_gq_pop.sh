#!/bin/bash

# add two more patches after 'git gq init'

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_pop"

echo "Run 'git gq pop'"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

$GIT_GQ pop

echo "Output of 'git log' now:"
git log | dummy_hash_filter_commit | dummy_hash_filter_author | dummy_hash_filter_date

echo "Files in .gqpatches:"
find ls .gqpatches/default | sort
echo "Content of patch file:"
cat .gqpatches/default/script.sh-was-improved.patch | dummy_hash_filter_from_hash | dummy_hash_filter_from_author | dummy_hash_filter_date | dummy_hash_filter_index
