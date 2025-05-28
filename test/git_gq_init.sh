#!/bin/bash

# run 'git gq init'

source util.sh

GIT_GQ="$1"

TMPDIR="tmp_git_gq_init"
echo "Run 'gq init'"

cp -a repo $TMPDIR

cd $TMPDIR || exit 1

$GIT_GQ init 2>&1 | filter_parenthesis_hash
echo "Files in .gqpatches:"
find .gqpatches
