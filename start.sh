#!/bin/bash

if [[ 4 > ${BASH_VERSINFO[0]} ]]; then
    echo "FATAL: THIS PROGRAM USES FEATURES ADDED IN BASH V4" >&2
    echo "PLEASE UPGRADE TO THE NEWEST VERSION OF BASH" >&2
    echo "You could use MacPorts or Homebrew, for examples" >&2
    return 1 2>/dev/null || exit 1
fi

cd ./view
bash run.sh
