#!/bin/bash

function dump_inode ()
{
    if [[ -z $1 ]]; then
        echo "ERROR: dump_inode requires 1 file argument." >&2
        return 1
    fi

    stat -f '"%N" %i' "$1"
}

function dump_inodes ()
{
    if [[ -z $1 ]]; then
        while read FILE; do
            dump_inode "$FILE"
        done
    else
        for FILE in "$@"; do
            dump_inode "$FILE"
        done
    fi
        
}


function diff_inodes ()
{
    if [[ -z $2 ]]; then
        echo "ERROR: diff_inodes requires 2 file arguments." >&2
        echo "ERROR: files must of same type (file, drectory, etc.)" >&2
    fi

    left=( $( dump_inode $1 ) )
    right=( $( dump_inode $2 ) )

    [[ ${left[1]} == ${right[1]} ]]
}
