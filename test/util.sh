# utilities for tests

DUMMY_HASH="abcdef0"
DUMMY_HASH2="abcdef1"
DUMMY_HASH3="abcdef3"
DUMMY_HASH_LONG="abcdef0123456789abcdef0123456789"
DUMMY_AUTHOR="Homer Simpson <simpson@burns-powerplant.com>"
DUMMY_DATE="Sun Dec 31 09:12:34 2001 +0100"
DUMMY_ISODATE="2001-12-31T091234"

function filter_pwd {
    # remove part of a file path
    local pwd_
    pwd_=$(pwd)
    while read -r line ; do
        echo "$line" | sed -e "s#$pwd_##"
    done
}

function filter_tar_isodate {
    # .gqpatches-2025-06-04T144559.tgz --> .gqpatches-2001-12-31T091234.tgz
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\([^-]\+\)-[0-9T-]\+.tgz/\1-$DUMMY_ISODATE.tgz/"
    done
}

function filter_linestart_hash {
    # '983fda7 TEXT' --> 'abcdef0 TEXT'
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^[a-f0-9]\+ \+/$DUMMY_HASH /"
    done
}

function filter_parenthesis_hash {
    # '(983fda7)' --> '(abcdef0)'
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/([a-f0-9]\+)/($DUMMY_HASH)/"
    done
}

function filter_set_to_hash {
    # '(983fda7)' --> '(abcdef0)'
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/\(set to\) [a-f0-9]\+/\1 $DUMMY_HASH/"
    done
}

function filter_squarebracket_hash {
    # '[sometext 76ad5f4]' --> '[sometext abcdef0]'
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\[\([^ ]\+\) \+[a-f0-9]\+\]/[\1 $DUMMY_HASH]/"
    done
}

function filter_star_commit_hash {
    # '* commit 76abd54efac7d5e783' --> '* commit abcdef0123456789abcdef0123456789'
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(\* commit\) \+[a-f0-9]\+/\1 $DUMMY_HASH_LONG/"
    done
}

function filter_commit_hash {
    # 'commit 76abd54efac7d5e783' --> 'commit abcdef0123456789abcdef0123456789'
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(commit\) \+[a-f0-9]\+/\1 $DUMMY_HASH_LONG/"
    done
}

function filter_from_hash {
    # 'From 76abd54efac7d5e783' --> 'From abcdef0123456789abcdef0123456789'
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(From\) \+[a-f0-9]\+/\1 $DUMMY_HASH_LONG/"
    done
}

function filter_author {
    # 'Author: Max Meyer <meyer@ibm.com>' --> 
    # 'Author: Homer Simpson <simpson@burns-powerplant.com>"
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(Author:\).*/\1 $DUMMY_AUTHOR/"
    done
}

function filter_mail_from {
    # 'From: Max Meyer <meyer@ibm.com>' --> 
    # 'From: Homer Simpson <simpson@burns-powerplant.com>"
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(From:\).*/\1 $DUMMY_AUTHOR/"
    done
}

function filter_mail_date {
    # 'Date: Wed May 15 10:12:00 2025 +0200' -->
    # 'Sun Dec 31 09:12:34 2001 +0100'
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(Date:\).*/\1 $DUMMY_DATE/"
    done
}

function filter_pipe_mail_date {
    # 'Date: Wed May 15 10:12:00 2025 +0200' -->
    # 'Sun Dec 31 09:12:34 2001 +0100'
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(| Date:\).*/\1 $DUMMY_DATE/"
    done
}

function filter_git_index_hash {
    # 'index a5de4ef..234abd6 876defa' -->
    # 'abcdef0..abcdef1 abcdef2'
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(index\) \+[0-9a-f \.]\+$/\1 $DUMMY_HASH..$DUMMY_HASH2 $DUMMY_HASH3/"
    done
}

function filter_git_head_hash {
    # 'HEAD is not at 54da6cd' -->
    # 'HEAD is not at abcdef0'
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(HEAD is now at\) \+[a-f0-9]\+ \+\(.*\)/\1 $DUMMY_HASH \2/"
    done
}

