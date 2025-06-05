#!/bin/bash

echo "* Test git gq backup"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_new"
TMPDIR="tmp_git_gq_backup"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo "\$ git gq pop"
$GIT_GQ pop | filter_git_head_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "\$ git gq backup"
$GIT_GQ backup | filter_git_head_hash

echo
echo "Tar file generated:"
ls .gq*.tgz | filter_tar_isodate

echo
echo "Files stored in tar file:"
tar -tf .gqpatches-*.tgz | sort
