#!/bin/bash

# input.sh
# A script to handle input prompting and validation. This should be sourced
# instead of being run directly.

function affirm ()
{
    POSITIVES="^yes|yep|uh huh|sure|go for it|affirmative|yessir|confirm$"
    [[ -n $1 ]] && [[ ${1,,} =~ $POSITIVES ]]
}
