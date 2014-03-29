#!/bin/bash

# history.sh
# looks back at the history for a given file or directory

if ! declare -f dump_inode >/dev/null; then
    source dump_inode.sh
fi

function file_history ()
{
    if [[ -z $1 ]]; then
        echo "ERROR: file_history requires a file argument." >&2
        return 1
    fi

    CURRENT=( $( dump_inode $1 ) )
    if [[ $? -ne 0 ]]; then
        echo "WARNING: $1 not found in existing directory structure." >&2
    fi

    

