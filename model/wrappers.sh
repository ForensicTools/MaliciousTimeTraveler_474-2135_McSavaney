#!/bin/bash

. ../control/history.sh

COMMANDS=("file_history" "get_drift" "get_diff")
COMMAND_DESC=("Get a file's history" "View the drift between backups" "Compare backups")
COMMAND_WRAPPERS=("file_history_setup" "get_drift_setup" "get_diff_setup")

file_history_setup()
{
    read -r -p "Target path: " TARGET_PATH
    file_history "$TARGET_PATH"
}

get_diff()
{
    tmutil calculatedrift "$1"
}

get_drift_setup()
{
    TMDIR="$( tmutil machinedirectory )" || return 1
    get_diff "$TMDIR"
}
