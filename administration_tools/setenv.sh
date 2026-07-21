SCRIPT_FULL_NAME=$(readlink -e "$0")
MYDIR=$(dirname "$SCRIPT_FULL_NAME")
#MYNAME=$(basename "$SCRIPT_FULL_NAME")

SCRIPT_SOURCE="$(readlink -e "${BASH_SOURCE[0]}")"

if [ "$SCRIPT_SOURCE" != "$SCRIPT_FULL_NAME" ]; then
    # The script is called with 'source'
    SCRIPT_IS_SOURCED="yes"
    SCRIPT_FULL_NAME="$SCRIPT_SOURCE"
    MYDIR=$(dirname "$SCRIPT_FULL_NAME")
    #MYNAME=$(basename "$SCRIPT_FULL_NAME")
fi

if [ -z "$SCRIPT_IS_SOURCED" ]; then
    echo "Error, you must call this script with:"
    echo "source $0"
    exit 1
fi

mkdir -p "$MYDIR/../bin"
(cd $MYDIR/../bin && ln -s ../src/git_gq/git_gq.py git-gq)
PATH="$(readlink -e "$MYDIR/../bin"):$PATH"
eval "$(git-gq completion)"
MYPS="$PS1"
export PS1="gitgq $MYPS"
