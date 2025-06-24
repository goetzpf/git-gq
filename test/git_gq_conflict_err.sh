#!/bin/bash

echo "* Test git gq abort"
echo "---------------------------------------"
echo

GIT_GQ="$1"

source util.sh

SRCDIR="tmp_git_gq_add_2"
TMPDIR="tmp_git_gq_conflict_err"

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
echo "\$ git gq applied"
$GIT_GQ applied | filter_linestart_hash
echo
echo "\$ git gq unapplied"
$GIT_GQ unapplied | filter_linestart_hash

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
$GIT_GQ push 2>&1 | filter_git_head_hash

echo
echo "Test if certain commands fail due to an unresolved conflict."

echo
echo "---------------------------------------------"
touch ABC
echo "\$git gq restore ABC"
$GIT_GQ restore ABC 2>&1 

echo
echo "---------------------------------------------"
echo "\$git gq qname ABC"
$GIT_GQ qname ABC 2>&1 

echo
echo "---------------------------------------------"
echo "\$git gq change-order"
$GIT_GQ change-order 2>&1 

echo
echo "---------------------------------------------"
echo "\$git gq parent ABC"
$GIT_GQ parent ABC 2>&1 

echo
echo "---------------------------------------------"
echo "\$git gq new ABC"
$GIT_GQ new ABC 2>&1 

echo
echo "---------------------------------------------"
echo "\$git gq record ABC"
$GIT_GQ record ABC 2>&1 

echo
echo "---------------------------------------------"
echo "\$git gq refresh"
$GIT_GQ refresh 2>&1 

echo
echo "---------------------------------------------"
echo "\$git gq pop"
$GIT_GQ pop 2>&1 

echo
echo "---------------------------------------------"
echo "\$git gq push"
$GIT_GQ push 2>&1 

echo
echo "---------------------------------------------"
echo "\$git gq goto ABC"
$GIT_GQ goto ABC 2>&1 

echo
echo "---------------------------------------------"
echo "\$git gq fold ABC"
$GIT_GQ fold ABC 2>&1 
exit 0
