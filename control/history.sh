#!/bin/bash

# history.sh
# looks back at the history for a given file or directory

if ! declare -f dump_inode >/dev/null; then
    source dump_inode.sh
fi

if ! declare -f reduce_path >/dev/null; then
    source file_info.sh
fi

function file_history ()
{
    if [[ -z $1 ]]; then
        echo "ERROR: file_history requires a file argument." >&2
        return 1
    fi

    declare -A AA #associative array of filename to inode

    TARGET=$( reduce_path "$1" )
    CURRENT=( $( dump_inode "$TARGET" ) ) #this is a two element array
    if [[ $? -ne 0 ]]; then
        echo "WARNING: $1 not found in existing directory structure." >&2
        echo "NOTE: $1 was reduced to $TARGET" >/&2
    fi
   
    DIR_RGX="*/*"
    
    MACHDIR="$( tmutil machinedirectory 2>/dev/null )"
    if [[ -z $MACHDIR ]]; then
        echo "WARNING: could not locate a TM directory for this system." >&2
        MACHDIR="$( find /Volumes -maxdepth 3 \
            -path ".*/Backups\.backupdb/$(hostname | cut -d. -f1)" \
            -and -print -and -quit 2>/dev/null )"
        if [[ -z $MACHDIR ]]; then
            echo "WARNING: failed to manually locate TM directory." >&2
            echo "NOTE: Well, I tried. We'll scan all of /Volumes." >&2
            MACHDIR="/Volumes"
            DIR_RGX="**/*"
        fi
    fi

    echo "DEBUG: finding ${MACHDIR}/${DIR_RGX}/${TARGET}"
    dump_inodes "${MACHDIR}"/${DIR_RGX}/"${TARGET}"
    #echo ${MACHDIR}/${DIR_RGX}/${TARGET} | sed 's/[^\\] /\\ /g' | dump_inodes
    #for FILE in ${TARGET}/${DIR_RGX}
    #find "$BACKUP" -path ".*${TARGET}" -prune 2>/dev/null | dump_inodes
}
    

