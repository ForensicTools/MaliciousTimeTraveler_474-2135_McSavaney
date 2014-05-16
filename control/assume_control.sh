#!/bin/bash

DAMAGE_WARNING="WARNING: THIS WILL DAMAGE THE INTEGRITY OF YOUR BACKUPS AND REQUIRES ROOT."

function assuming_control()
{
    shopt -s nocasematch
    # Leaving this check in place to strongly discourage scripting this
    # function blindly. if you're going to damage your data's integrity,
    # you better know what you're doing.
    echo "$DAMAGE_WARNING" >&2
    read -p "Be damn sure you know what you are doing. Proceed? [y/N] : " \
            SOPHIESCHOICE
    if [[ $SOPHIESCHOICE =~ "y" ]]; then
        pushd $( tmutil machinedirectory )
        find /System/Library/Extensions/TMSafetyNet.kext -name bypass \
            -exec {} "${@:-$( which $SHELL )}" \;
        popd
    else
        echo "I honestly don't blame you."
    fi 
}

function substitute()
{
    # not as potentially damaging as seatbelt-less arbitrary command execution
    # if you use dd to overwrite a file you will NOT change its inode number
    find /System/Library/Extensions/TMSafetyNet.kext -name bypass -exec {} \
        dd if="$2" of="$1" \;
}

function edit_in_place()
{
    # technically, people can also execute arbitrary commands from vim.
    # but that's dumb.
    find /System/Library/Extensions/TMSafetyNet.kext -name bypass -exec {} \
        vim "+set nobackup" "+set nowritebackup" "$1" \;
}
