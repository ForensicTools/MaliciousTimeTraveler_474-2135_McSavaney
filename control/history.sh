#!/bin/bash

# history.sh
# looks back at the history for a given file or directory

if ! declare -f dump_inode >/dev/null; then
    source ../control/dump_inode.sh
fi

if ! declare -f get_colors >/dev/null; then
    source ../view/colors.sh
fi

if ! declare -f reduce_path >/dev/null; then
    source ../control/file_info.sh
fi

function file_history ()
{
    shopt -s globstar
    if [[ -z $1 ]]; then
        echo "ERROR: file_history requires a file argument." >&2
        return 1
    fi

    TARGET=$( reduce_path "$1" )
    TARGETPATH=""
    CURRENT=( $( dump_inode "$TARGET" ) ) #this is a two element array
    if [[ $? -ne 0 ]]; then
        echo "WARNING: $1 not found in existing directory structure." >&2
        echo "NOTE: $1 was reduced to $TARGET" >&2
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

    #COLORS=( `get_colors` )
    MAX_COLOR="$( tput colors )"
    HEAD=0
    TAIL=0
    if [[ $MAX_COLOR -eq 256 ]]; then
        HEAD=16 #skip ugly, sporadic ANSI colors
        TAIL=24 #skip greyscale values at the end
    fi     #don't need this if doing HSV


    declare -A inodecolors
    local _FG=0
    local _BG=$HEAD
    
    TARGETPATH=`reduce_path "${MACHDIR}/${DIR_RGX}/${TARGET}"`

    INODE_TABLE="`dump_inodes ${TARGETPATH}`"
    if [[ -z $INODE_TABLE ]]; then
        echo "Failed to detect any matches." >&2
        exit 1
    fi
    
    COLOR_INCREMENT=$( echo "$INODE_TABLE" | cut -d' ' -f1 | sort -u | wc -l )
    COLOR_INCREMENT=$(( 360 / COLOR_INCREMENT ))
    # +1 because zero-indexing

    while read LINE; do
        inode="`echo $LINE | cut -d' ' -f1`"
        if [[ -z ${inodecolors[$inode]+abc} ]]; then
            if [[ $_FG -eq $_BG ]]; then
                _FG="$(( _FG + COLOR_INCREMENT ))"
                if [[ $_FG -ge 360 ]]; then
                    _FG="$HEAD"
                    _BG="$(( _BG + COLOR_INCREMENT ))"
                fi
                if [[ $_BG -ge 360 ]]; then
                    _BG="$HEAD"
                fi
            fi
            FG_COLOR=$(( $( hsv2rgb $_FG 5 5 ) + $HEAD ));
            BG_COLOR=${COLORS[$BG]}
            inodecolors[$inode]=$( tput setaf $FG_COLOR ; tput setab $_BG )
            
            _FG=$(( _FG + COLOR_INCREMENT ))

            if [[ $_FG -ge 360 ]]; then
                _FG="$HEAD"
                _BG="$(( _BG + COLOR_INCREMENT ))"
            fi
            if [[ $_BG -ge 360 ]]; then
                _BG="$HEAD"
            fi
        fi
        #set_color ${inodecolors[$inode]}
        echo -n ${inodecolors[$inode]}
        printf "%-9s  :  " "$inode"
        echo -n "$LINE" | cut -d' ' -f2- | xargs echo -n
        reset_colors
        echo
    done <<< "$INODE_TABLE"
    # the above allows us to process our table without creating a subprocess

    #reset_colors
    #echo ${MACHDIR}/${DIR_RGX}/${TARGET} | sed 's/[^\\] /\\ /g' | dump_inodes
    #for FILE in ${TARGET}/${DIR_RGX}
    #find "$BACKUP" -path ".*${TARGET}" -prune 2>/dev/null | dump_inodes
}
    

