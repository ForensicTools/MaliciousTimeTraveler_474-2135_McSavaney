#!/bin/bash

# analyze.sh
# Script to prompt for file paths

source ../control/*.sh
source ./colors.sh

echo "Enter file paths on the local filesystem to analyze for changes."
echo "Press ctrl-D to end."
echo

echo -n "file_info :: "

while read var; do
    file_history "$var" | less -R
    echo -n "file_info :: "
done
