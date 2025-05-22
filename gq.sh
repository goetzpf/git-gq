#!/bin/bash

# activate if the script should abort on error:
# set -e

SCRIPT_FULL_NAME=$(readlink -e "$0")
#MYDIR=$(dirname "$SCRIPT_FULL_NAME")
MYNAME=$(basename "$SCRIPT_FULL_NAME")

QUEUENAME="default"
TOPPATCHDIR=".patches"
PATCHDIR="$TOPPATCHDIR/$QUEUENAME"
SERIESFILE="$PATCHDIR/series"
PARENTFILE="$PATCHDIR/parent"
QUEUEFILE="$TOPPATCHDIR/queue"

ALL_COMMANDS="completion qabort qapplied qbackup qcontinue qdelete qfold qinit qname qnew qparent qpop qpush qrecord qrefresh qunapplied"

ALL_COMMANDS_RX=$(echo "$ALL_COMMANDS" | sed -e 's/ /|/g')

verbose=""
dryrun=""

all=""
rev=""
name=""

cmdret=""
cmddata=""

function CMD {
    # execute a shell command
    # arguments:
    #   $1: command
    # returns:
    #   cmdret (global variable): the return code of the command
    if [ -n "$verbose" ] || [ -n "$dryrun" ]; then
        echo "$1"
    fi
    if [ -z "$dryrun" ]; then
        bash -c "$1"
        cmdret=$?
    else
        cmdret=0
    fi
}

function CMDRET {
    # execute a shell command and catch standard out
    # arguments:
    #   $1: command
    # returns:
    #   cmdret (global variable): the return code of the command
    #   cmddata (global variable): the stdout output of the command
    if [ -n "$verbose" ] || [ -n "$dryrun" ]; then
        echo "$1"
    fi
    cmdret=0
    # without '|| ...' the script will exit right here
    # in case of an error:
    cmddata=$(bash -c "$1") || cmdret=$?
}

function CD {
    # change directory but not when dryrun is set
    # $1: dir
    if [ -n "$verbose" ] || [ -n "$dryrun" ]; then
        echo "cd $1"
    fi
    if [ -z "$dryrun" ]; then
        if ! cd "$1" > /dev/null; then
            echo "cd $1 failed!"
            exit 1
        fi
    fi
}

function git_head_log {
    # $1: name of file to create
    CMD "git log -1 --pretty=%B > $1"
}

function git_add_changes {
    # add only changes files to stash
    CMD "git status --porcelain | grep -v '^??' | sed -e 's/^.. //' | xargs git add"
}

function git_select_changes {
    # add only changes files to stash
    CMD "git add --patch"
}

function git_add_all_changes {
    # add all changes except patchqueue files
    CMD "git status --porcelain | sed -e 's/^.. //' | grep -v '\(^$PATCHDIR[/-]\|\.rej$\)'| xargs git add"
}

function git_amend {
    # simple amend of HEAD revision
    # $1: if not empty, take log message from here
    EXTRA=""
    if [ -n "$1" ]; then
        EXTRA="-F $1"
    fi
    git_add_changes
    CMD "git commit --amend $EXTRA"
}

function select_queue {
    # $1: queue name
    # modifies global variables: QUEUENAME, PATCHDIR, SERIESFILE,
    #                            PARENTFILE
    QUEUENAME="$1"
    PATCHDIR="$TOPPATCHDIR/$QUEUENAME"
    SERIESFILE="$PATCHDIR/series"
    PARENTFILE="$PATCHDIR/parent"
}

function qpop_check {
    # returns 0 if qpop is not beyond qparent,
    # returns 1 when qpop is not allowed.
    # $1: if non-zero, instead of returning 1 abort with an error message
    CMDRET "git rev-parse --short HEAD"
    rev="$cmddata"
    CMD "[ ! -s $PARENTFILE ] || [ $(cat $PARENTFILE) != $cmddata ]"
    if [ "$cmdret" -ne 0 ]; then
        if [ -n "$1" ]; then
            echo "cannot do qpop, parent revision $rev reached" >&2
            exit 1
        else
            return 1
        fi
    fi
    return 0
}

function qpop_one {
    # do a single 'qpop' operation.
    CMD "git format-patch -o $PATCHDIR -1 HEAD > $PATCHDIR/NEW-1"
    CMD "sed -e 's#$PATCHDIR/0001-##' $PATCHDIR/NEW-1 > $PATCHDIR/NEW"
    CMD "mv $(cat $PATCHDIR/NEW-1) $PATCHDIR/$(cat $PATCHDIR/NEW)"
    CMD "if [ ! -s $SERIESFILE ]; then cat $PATCHDIR/NEW > $SERIESFILE; else sed -i \"1i$(cat $PATCHDIR/NEW)\" $SERIESFILE; fi"
    CMD "rm -f $PATCHDIR/NEW-1 $PATCHDIR/NEW"
    CMD "git reset --hard HEAD~1"
}

function qpush_specified {
    # $1: name of patch
    if [ ! -s "$SERIESFILE" ]; then
        echo "error, no patches in $SERIESFILE"
        exit 1
    fi
    CMD "grep -F -e '$name' $SERIESFILE > $PATCHDIR/NEW"
    if [ ! -s "$PATCHDIR/NEW" ]; then
        echo "error, patch '$name' not found in $SERIESFILE, maybe the patch is alraedy applied" >&2
        exit 1
    fi
    CMD "grep -v -F -e '$name' $SERIESFILE > $SERIESFILE.new"
    CMD "git am --reject $PATCHDIR/$(cat $PATCHDIR/NEW)"
    if [ "$cmdret" -ne 0 ]; then
        echo "The patch to be folded could not be applied."
        echo "Fix the change by looking at the *.rej files."
        echo "Then run:"
        echo "  $MYNAME qcontinue"
        echo "To abort the operation without fixing run:"
        echo "  $MYNAME qabort"
        exit 1
    fi
    CMD "cp -a $SERIESFILE.new $SERIESFILE && rm -f $SERIESFILE.new $PATCHDIR/NEW"
}

function qpush_one {
    # do a single 'qpush' operation.
    if [ ! -s "$SERIESFILE" ]; then
        echo "error, no patches in $SERIESFILE"
        exit 1
    fi
    CMD "head -n 1 $SERIESFILE > $PATCHDIR/NEW"
    CMD "cp -a $SERIESFILE $SERIESFILE.new && sed -i -e '1d' $SERIESFILE.new"
    CMD "git am --reject $PATCHDIR/$(cat $PATCHDIR/NEW)"
    if [ "$cmdret" -ne 0 ]; then
        echo "Fix the change by looking at the *.rej files."
        echo "Then run:"
        echo "  $MYNAME qcontinue"
        echo "To abort the operation without fixing run:"
        echo "  $MYNAME qabort"
        exit 1
    fi
    CMD "cp -a $SERIESFILE.new $SERIESFILE && rm -f $SERIESFILE.new $PATCHDIR/NEW"
}

function qdelete {
    # $1: name of patch to delete
    if [ ! -e "$PATCHDIR/$name" ]; then
        echo "error, patch '$name' doesn't exist."
        exit 1
    fi
    CMD "rm $PATCHDIR/$name"
    CMD "if [ -s $SERIESFILE ]; then cp -a $SERIESFILE $SERIESFILE.bak && grep -v -F -e '$name' $SERIESFILE.bak > $SERIESFILE && rm -f $SERIESFILE.bak; fi"
}

function create_parentfile {
    # $1: revision
    CMDRET "git rev-parse --short $1"
    if [ "$cmdret" -ne 0 ]; then
        echo "invalid revision: $1" >&2
        exit 1
    fi
    CMD "echo $cmddata > $PARENTFILE"
}

function print_short_help {
  echo "$MYNAME : handle git patch queue"
  echo "usage: $MYNAME COMMAND [options]"
  echo
  echo "known commands":
  echo "  completion    : print bash completion code. Activate completion in your"
  echo "                  shell with:"
  echo "                  eval ($MYNAME completion)"
  echo "  qinit [NAME]  : create/select a patch queue with name 'NAME'."
  echo "                  This is optional, the default patch queue is named"
  echo "                  'default'."
  echo "                  You must run this command once to initialize the"
  echo "                  patch queue."
  echo "  qname         : show current patch queue name."
  echo "  qnew [NAME]   : create new patch (commit with log-message NAME)"
  echo "  qrecord [NAME]: interactively select changes for a new patch"
  echo "                  (commit with log-message NAME)"
  echo "  qrefresh      : update the topmost patch"
  echo "  qpop          : pop the topmost patch."
  echo "  qpush         : apply the top patch from the patch queue"
  echo "  qparent [REV} : set REV as patch queue parent revision. Do never go "
  echo "                  beyond this revision with qpop. The default for REV"
  echo "                  is 'HEAD'."
  echo "  qfold NAME    : fold patch 'NAME' to the topmost patch. Patch 'name'"
  echo "                  must not be appled already."
  echo "  qdelete NAME  : delete unapplied patch with given name."
  echo "  qcontinue     : continue 'qpush' after you had a conflict and had"
  echo "                  it fixed manually."
  echo "  qabort        : abort (undo) 'qpush' after you had a conflict and could"
  echo "                  not fix it manually."
  echo "  qapplied      : show all applied patches up to parent+1"
  echo "  qunapplied    : show all patches of the patch queue"
  echo "  qbackup       : create backup tar file of patch directory."
  echo
  echo "options:"
  echo "-h --help  : this help"
  echo "-f --file FILE: specify FILE"
  echo "-a --all    : qpush: push ALL patches"
  echo "-v --verbose: show what the script does"
  echo "-n --dry-run: just show what the script would do"
  exit 0
}

declare -a ARGS
skip_options=""

while true; do
    case "$1" in
        -h | --help)
            # if the "less" is present, use it:
            if less -V >/dev/null 2>&1; then
                # use less pager for help:
                $SCRIPT_FULL_NAME --help-raw | less
                exit 0
            else
                print_short_help
            fi
            ;;
        --help-raw)
            print_short_help
            ;;
        -a | --all)
            all="yes"
            shift
            ;;
        -v | --verbose)
            verbose="yes"
            shift
            ;;
        -n | --dry-run)
            verbose="yes"
            dryrun="yes"
            shift
            ;;
        -- )
            skip_options="yes"
            shift;
            break
            ;;
        *)
            if [ -z "$1" ]; then
                break;
            fi
            if [[ $1 =~ ^- ]]; then
                echo "unknown option: $1"
                exit 1
            fi
            ARGS+=("$1")
            shift
            ;;
    esac
done

if [ -n "$skip_options" ]; then
    while true; do
        if [ -z "$1" ]; then
            break;
        fi
        ARGS+=("$1")
        shift
    done
fi

COMMAND=""

for arg in "${ARGS[@]}"; do
    # examine extra args
    # match known args here like:
    # if [ "§arg" == "doit" ]; then ...
    #     continue
    # fi
    if [ "$COMMAND" == "qparent" ]; then
        if [ -n "$rev" ]; then
            echo "unexpected: '$arg'" >&2
            exit 1
        fi
        rev="$arg"
        continue
    fi
    if [[ "$COMMAND" =~ qinit|qfold|qnew|qrecord|qdelete ]]; then
        if [ -n "$name" ]; then
            echo "unexpected: '$arg'" >&2
            exit 1
        fi
        name="$arg"
        continue
    fi
    if [[ "$arg" =~ $ALL_COMMANDS_RX ]]; then
        if [ -n "$COMMAND" ]; then
            echo "unexpected: '$arg'" >&2
            exit 1
        fi
        COMMAND="$arg";
        continue
    fi
    echo "unexpeced argument: $arg"
    exit 1
done

if [ "$COMMAND" == "completion" ]; then
    echo "complete -W \"$ALL_COMMANDS\" $MYNAME"
    exit 0
fi

if [ ! -d .git ]; then
    echo "error, '.git' not found" >&2
    exit 1
fi

if [ "$COMMAND" == "qinit" ]; then
    if [ -n "$name" ]; then
        QUEUENAME="$name"
    fi
    mkdir -p "$TOPPATCHDIR"
    echo "$QUEUENAME" > "$QUEUEFILE"
    select_queue "$QUEUENAME"
    mkdir -p "$TOPPATCHDIR/$QUEUENAME"
    if [ ! -s "$PARENTFILE" ]; then
        create_parentfile HEAD
    fi
    exit 0
fi

if [ ! -d "$TOPPATCHDIR" ]; then
    echo "please run '$MYNAME qinit' first." >&2
    exit 1
fi

QUEUENAME=$(cat "$QUEUEFILE")
if [ ! -d "$PATCHDIR" ]; then
    mkdir -p "$PATCHDIR/$QUEUENAME"
fi
select_queue "$QUEUENAME"

if [ "$COMMAND" == "qname" ]; then
    echo "Exissting queues:"
    CMD "cd $TOPPATCHDIR && ls -d */ | sed -e 's#/##;s/^/\\t/'"
    echo
    echo "Currently selected:"
    echo -e "\t$QUEUENAME"
    exit 0
fi

if [ "$COMMAND" == "qbackup" ]; then
    date_=$(date '+%Y-%m-%dT%H%M%S')
    CMD "tar -czf $TOPPATCHDIR-$date_.tgz $TOPPATCHDIR"
    exit 0
fi

if [ "$COMMAND" == "qparent" ]; then
    if [ -z "$rev" ]; then 
        rev="HEAD"
        exit 1
    fi
    create_parentfile
    exit 0
fi

if [ "$COMMAND" == "qnew" ]; then
    git_add_changes
    if [ -n "$name" ]; then
        name="-m '$name'"
    fi
    CMD "git commit $name"
    exit 0
fi

if [ "$COMMAND" == "qrecord" ]; then
    git_select_changes
    if [ -n "$name" ]; then
        name="-m '$name'"
    fi
    CMD "git commit $name"
    exit 0
fi

if [ "$COMMAND" == "qrefresh" ]; then
    git_amend ""
    exit 0
fi

if [ "$COMMAND" == "qdelete" ]; then
    if [ -z "$name" ]; then
        echo "error, patchname is missing" >&2
        exit 1
    fi
    qdelete "$name"
    exit 0
fi

if [ "$COMMAND" == "qpop" ]; then
    abort_on_err=""
    if [ -z "$all" ]; then
        abort_on_err="yes"
    fi
    while true; do
        if ! qpop_check "$abort_on_err"; then
            break
        fi
        qpop_one
        if [ -z "$all" ]; then
            break
        fi
    done
    exit 0
fi

if [ "$COMMAND" == "qpush" ]; then
    while true; do
        if [ ! -s $SERIESFILE ]; then
            break
        fi
        qpush_one
        if [ -z "$all" ]; then
            break
        fi
    done
    exit 0
fi

if [ "$COMMAND" == "qfold" ]; then
    if [ -z "$name" ]; then
        echo "error, patchname is missing" >&2
        exit 1
    fi
    git_head_log "$PATCHDIR/LOG"
    CMD "echo -e '\n***\n' >> $PATCHDIR/LOG"
    qpush_specified "$name"
    git_head_log "$PATCHDIR/LOG2"
    CMD "cat $PATCHDIR/LOG2 >> $PATCHDIR/LOG && rm -f $PATCHDIR/LOG2"
    qpop_one
    CMD "git apply $PATCHDIR/$name"
    git_amend "$PATCHDIR/LOG"
    CMD "rm -f $PATCHDIR/LOG"
    qdelete "$name"
    echo "Note: Log messages were combined into one" >&2
    exit 0
fi

if [ "$COMMAND" == "qapplied" ]; then
    if [ -s $PARENTFILE ]; then
        CMDRET "cat $PARENTFILE"
        START="${cmddata}.."
    fi
    CMD "git log --color=always --oneline $START | cat"
    exit 0
fi

if [ "$COMMAND" == "qunapplied" ]; then
    if [ -s $SERIESFILE ]; then
        CMD "cat $SERIESFILE"
    fi
    exit 0
fi

if [ "$COMMAND" == "qcontinue" ]; then
    CMD "git status --porcelain | sed -e 's/^.. //' | grep -v '\(^$PATCHDIR/\|\.rej$\)'| xargs git add"
    CMD "git am --continue"
    if [ "$cmdret" -ne 0 ]; then
        echo "Fix the change by looking at the *.rej files."
        echo "Then run:"
        echo "  $MYNAME qcontinue"
        echo "To abort the operation without fixing run:"
        echo "  $MYNAME qabort"
    fi
    CMD "if [ -e $SERIESFILE.new ]; then cp -a $SERIESFILE.new $SERIESFILE && rm -f $SERIESFILE.new; fi"
    exit 0
fi

if [ "$COMMAND" == "qabort" ]; then
    CMD "git am --abort"
    CMD "rm -f $SERIESFILE.new"
    exit 0
fi

if [ "$COMMAND" == "qcontinue" ]; then
    git_add_all_changes
    CMD "git am --continue"
    if [ "$cmdret" -ne 0 ]; then
        echo "Fix the change by looking at the *.rej files."
        echo "Then run:"
        echo "  $MYNAME qcontinue"
    fi
    exit 0
fi
