#!/bin/bash

. ../control/history.sh
. ../control/assume_control.sh

COMMANDS=( "file_history" "get_drift" "get_diff" "get_dest_info" "get_status"\
    "assuming_control" "substitute" "edit_in_place" )

COMMAND_DESC=( "Get a file's history" "View the drift between backups"\
    "Compare backups" "Get TM destination information" "Get current TM status"\
    "!! Bypass TM safeguards !!" \
    "!! Overwrite a file in-place !!" \
    "!! Edit a file in-place (vim) !!" )

COMMAND_WRAPPERS=( "file_history_setup" "get_drift_setup" "get_diff_setup"\
    "get_dest_info" "get_status" "assuming_control_setup" "substitute_setup"\
    "edit_in_place_setup" )

function check_root()
{
    if [[ $UID = 0 ]]; then
        return 0
    fi

    echo "ERROR: you are not root. Please re-run as root." >&2
    return 1
}

function file_history_setup()
{
    read -e -p "Target path: " TARGET_PATH
    file_history "$TARGET_PATH"
}

function get_drift()
{
    tmutil calculatedrift "$1"
}

function get_drift_setup()
{
    shopt -s nocasematch
    echo "WARNING: this usually takes an incredibly long time."
    read -p "Are you sure you want to proceed? [Y/n] : " SOPHIESCHOICE
    if [[ $SOPHIESCHOICE =~ "n" ]]; then
        echo "Yeah, I don't really blame you..."
    else
        TMDIR="$( tmutil machinedirectory )" || return 1
        get_drift "$TMDIR"
    fi
}

function get_diff()
{
    tmutil compare -a "$1" "$2"
}

function get_diff_setup()
{
    read -e -i "$( tmutil machinedirectory )" -p "Path 1: " P1
    read -e -i "$( tmutil machinedirectory )" -p "Path 2: " P2

    get_diff "$P1" "$P2"
}

function get_dest_info()
{
    tmutil destinationinfo
}

function get_status()
{
    tmutil currentphase
}

function assuming_control_setup()
{
    if ! check_root; then return 1; fi

    read -e -p "Command to run unrestricted: " -i "$( which $SHELL )" CMD
    assuming_control $CMD
}

function substitute_setup()
{
    if ! check_root; then return 1; fi

    shopt -s nocasematch
    echo "$DAMAGE_WARNING" >&2
    read -p "Be damn sure you know what you are doing. Proceed? [y/N] : " \
            SOPHIESCHOICE
    if [[ $SOPHIESCHOICE =~ "n" ]]; then
        echo "Good call, champ."
        return 1
    fi

    TARGET="$( tmutil machinedirectory 2>/dev/null )"
    read -e -p "File to alter: " -i "${TARGET:-/Volumes/}" TARGET
    if [[ ! -f $TARGET ]]; then #-w $TARGET breaks because ACLs
        echo "ERROR: either $TARGET doesn't exist or is not writable." >&2
        return 1
    fi
    echo "NOTE: enter '/dev/stdin' if you wish to use STDIN."
    read -ep "File to write over in the target's place: " -i "$HOME" INFILE
    if [[ $INFILE = "/dev/stdin" || ( -f $INFILE && -r $INFILE ) ]]; then
        substitute "$TARGET" "$INFILE"
    else
        echo "ERROR: File $INFILE is invalid, nonexistent or can't be read.">&2
        return 1
    fi
}


function edit_in_place_setup()
{
    if ! check_root; then return 1; fi

    shopt -s nocasematch
    echo "$DAMAGE_WARNING" >&2
    read -p "Be damn sure you know what you are doing. Proceed? [y/N] : " \
            SOPHIESCHOICE
    if [[ $SOPHIESCHOICE =~ "n" ]]; then
        echo "Good call, champ."
        return 1
    fi

    TARGET="$( tmutil machinedirectory 2>/dev/null )"
    read -e -p "File to alter: " -i "${TARGET:-/Volumes/}" TARGET
    if [[ ! -f $TARGET ]]; then
        echo "ERROR: $TARGET doesn't appear to exist." >&2
        return 1
    fi
    edit_in_place "$TARGET"
}

