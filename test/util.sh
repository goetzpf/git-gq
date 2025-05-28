# utilities for tests

DUMMY_HASH="abcdef0"
DUMMY_HASH2="abcdef1"
DUMMY_HASH3="abcdef3"
DUMMY_HASH_LONG="abcdef0123456789abcdef0123456789"
DUMMY_AUTHOR="Homer Simpson <simpson@burns-powerplant.com>"
DUMMY_DATE="Sun Dec 31 09:12:34 2001 +0100"

function dummy_hash_filter_br {
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/([a-f0-9]\+)/($DUMMY_HASH)/"
    done
}

function dummy_hash_filter_sqbr {
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\[\([^ ]\+\) \+[a-f0-9]\+\]/[\1 $DUMMY_HASH]/"
    done
}

function dummy_hash_filter_commit {
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(commit\) \+[a-f0-9]\+/\1 $DUMMY_HASH_LONG/"
    done
}

function dummy_hash_filter_from_hash {
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(From\) \+[a-f0-9]\+/\1 $DUMMY_HASH_LONG/"
    done
}

function dummy_hash_filter_git {
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/[0-9a-f]\{7\}/$DUMMY_HASH/"
    done
}

function dummy_hash_filter_author {
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(Author:\).*/\1 $DUMMY_AUTHOR/"
    done
}

function dummy_hash_filter_from_author {
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(From:\).*/\1 $DUMMY_AUTHOR/"
    done
}

function dummy_hash_filter_author {
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(Author:\).*/\1 $DUMMY_AUTHOR/"
    done
}

function dummy_hash_filter_date {
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(Date:\).*/\1 $DUMMY_DATE/"
    done
}

function dummy_hash_filter_index {
    local line
    while read -r line ; do
        echo "$line" | sed -e "s/^\(index\) \+[0-9a-f \.]\+$/\1 $DUMMY_HASH..$DUMMY_HASH2 $DUMMY_HASH3/"
    done
}

