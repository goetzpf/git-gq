#!/bin/bash

echo "* Test git gq continue"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_continue"

cp -a $SRCDIR $TMPDIR

cd $TMPDIR || exit 1

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "# Insert at line 1 of README.txt"
sed -i "1iThis is a new first line" "README.txt"
echo "\$ git gq new README-insert-line-1"
$GIT_GQ new README-insert-line-1 | filter_squarebracket_hash

echo
echo "# Append line to README.txt"
echo "This is a new last line" >> "README.txt"
echo "\$ git gq new README-append-last-line"
$GIT_GQ new README-append-last-line | filter_squarebracket_hash

echo
echo "Content of README.txt now:"
echo "----------"
cat README.txt
echo "----------"

echo
echo "\$ git gq pop"
$GIT_GQ pop | filter_git_head_hash

echo
echo "\$ git gq pop"
$GIT_GQ pop | filter_git_head_hash

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "# Invert order of patches"
SF=".gqpatches/default/series"
tac "$SF" > "$SF.new" && rm -f "$SF" && mv "$SF.new" "$SF"

echo
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

echo
echo "At the next 'push' we expect a conflict."
echo "\$ git gq push"
$GIT_GQ push | filter_git_head_hash 2>&1

echo
echo "# Take change from reject file and apply to file README.txt."
grep '^+' README.txt.rej | sed -e 's/^.//' >> README.txt

echo
echo "\$ git gq continue"
$GIT_GQ continue

echo
echo "\$ git gq push"
$GIT_GQ push | filter_git_head_hash

echo
echo "Content of README.txt now:"
echo "----------"
cat README.txt
echo "----------"
