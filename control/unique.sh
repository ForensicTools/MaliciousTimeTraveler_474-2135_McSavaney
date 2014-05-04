#!/bin/bash

source ../view/colors.sh

COLORS=( `get_colors` )
echo ${FOREGROUNDS[*]}

declare -A inodecolors
FG=0
BG=0

while read inode; do
    if [[ -z ${inodecolors[$inode]} ]]; then
        FG_COLOR=${COLORS[$FG]}
        BG_COLOR=${COLORS[$BG]}
        inodecolors[$inode]="${FG_COLOR} ${BG_COLOR}"
        FG=$(( FG + 1 ))
        if [[ $FG -eq ${#FOREGROUNDS} ]]; then
            FG=0
            BG=$(( BG + 1 ))
        fi
    fi

    echo "${inodecolors[$inode]}$inode"
done
