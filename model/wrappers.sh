#!/bin/bash

. ../control/history.sh

COMMANDS=("file_history" "get_drift" "get_diff" "get_dest_info" "get_status")
COMMAND_DESC=("Get a file's history" "View the drift between backups" "Compare backups" "Get TM destination information" "Get current TM status")
COMMAND_WRAPPERS=("file_history_setup" "get_drift_setup" "get_diff_setup" "get_dest_info" "get_status")

file_history_setup()
{
    read -e -p "Target path: " TARGET_PATH
    file_history "$TARGET_PATH"
}

get_drift()
{
    tmutil calculatedrift "$1"
}

get_drift_setup()
{
    shopt -s nocasematch
    echo "WARNING: this usually takes an incredibly long time."
    read -p "Are you sure you want to proceed? [Y/n] " SOPHIESCHOICE
    if [[ $SOPHIESCHOICE =~ "n" ]]; then
        echo "Yeah, I don't really blame you..."
    else
        TMDIR="$( tmutil machinedirectory )" || return 1
        get_drift "$TMDIR"
    fi
}

get_diff()
{
    tmutil compare -a "$1" "$2"
}

get_diff_setup()
{
    read -e -i "$( tmutil machinedirectory )" -p "Path 1: " P1
    read -e -i "$( tmutil machinedirectory )" -p "Path 2: " P2

    get_diff "$P1" "$P2"
}

get_dest_info()
{
    tmutil destinationinfo
}

get_status()
{
    tmutil currentphase
}
