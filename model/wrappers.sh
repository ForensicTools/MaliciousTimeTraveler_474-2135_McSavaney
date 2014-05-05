#!/bin/bash

. ../control/history.sh

COMMANDS=("file_history" "get_drift" "get_diff" "get_dest_info")
COMMAND_DESC=("Get a file's history" "View the drift between backups" "Compare backups" "Get TM destination information")
COMMAND_WRAPPERS=("file_history_setup" "get_drift_setup" "get_diff_setup" "get_dest_info")

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
    TMDIR="$( tmutil machinedirectory )" || return 1
    get_drift "$TMDIR"
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
