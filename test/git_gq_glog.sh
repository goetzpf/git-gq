#!/bin/bash

echo "* Test git gq glog"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_glog"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "\$ git gq glog"
$GIT_GQ glog | filter_star_commit_hash | filter_author | filter_pipe_mail_date | filter_mail_date

