#!/bin/bash

. ./ui/tui.sh
. ../model/wrappers.sh

TOP_LANE=2
MENU_OPTIONS=("Get file history" "View drift between backups" "Compare backups")
TITLE="Select a command to run:"
show_menu_quit
command_selection="$?"

if [[ -z ${COMMAND_WRAPPERS[$command_selection]} ]]; then
    return 0 2>/dev/null || exit 0
fi

${COMMAND_WRAPPERS[$command_selection]}
