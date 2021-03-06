#!/bin/bash

# file_info.sh

function get_volume ()
{
    if [[ -z $1 ]]; then
        echo "ERROR: get_volume requires a mountpoint argument." >&2
        return 1
    fi
    diskutil info $1 | grep "Volume Name" | sed "s/.*Volume Name:[ ]*//"
}

function reduce_path ()
{
    REDUCABLES="/\.\./|//|/\./"
    if [[ -z $1 ]]; then
        echo "ERROR: reduce_path requires a path argument." >&2
        return 1
    fi 
 
    P="$1"

    while [[ $P =~ $REDUCABLES ]]; do
        P="$( echo "$P" | sed -E \
            -e "s%/[^\.\.][^/]+/\.\./%/%g" \
            -e "s%^/\.\./%/%g" \
            -e "s%//%/%g" \
            -e "s%/\./%/%g" )"
    done

    echo "$P"
}
