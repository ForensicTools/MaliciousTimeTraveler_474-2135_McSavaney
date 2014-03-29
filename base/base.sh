#!/bin/bash

# bash.sh
# sources all required files, by default, all of those in:
#   - base
#   - model
#   - view
#   - controller

shopt -s extglob

source ./base/!(base.sh)   2>/dev/null
source ./model/*.sh        2>/dev/null
source ./view/*.sh         2>/dev/null
source ./controller/*.sh   2>/dev/null
