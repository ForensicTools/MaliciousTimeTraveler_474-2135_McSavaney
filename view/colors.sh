#!/bin/bash

# colors.sh

# source me!

function reset_colors ()
{
    tput sgr0
}

function get_colors()
{
    echo "default black red green yellow blue pink cyan lgray dgray lred lgreen lyellow lblue lpink lcyan white"
    
}

function set_color ()
{
    if [[ -z $1 ]]; then
        reset_colors
        return 0
    fi
    

    declare -A FOREGROUNDS
    declare -A BACKGROUNDS

    FOREGROUNDS[default]=39
    FOREGROUNDS[black]=30
    FOREGROUNDS[red]=31
    FOREGROUNDS[green]=32
    FOREGROUNDS[yellow]=33
    FOREGROUNDS[blue]=34
    FOREGROUNDS[pink]=35
    FOREGROUNDS[cyan]=36
    FOREGROUNDS[lgray]=37
    FOREGROUNDS[dgray]=90
    FOREGROUNDS[lred]=91
    FOREGROUNDS[lgreen]=92
    FOREGROUNDS[lyellow]=93
    FOREGROUNDS[lblue]=94
    FOREGROUNDS[lpink]=95
    FOREGROUNDS[lcyan]=96
    FOREGROUNDS[white]=97
    
    BACKGROUNDS[default]=49
    BACKGROUNDS[black]=40
    BACKGROUNDS[red]=41
    BACKGROUNDS[green]=42
    BACKGROUNDS[yellow]=43
    BACKGROUNDS[blue]=44
    BACKGROUNDS[pink]=45
    BACKGROUNDS[cyan]=46
    BACKGROUNDS[lgray]=47
    BACKGROUNDS[dgray]=100
    BACKGROUNDS[lred]=101
    BACKGROUNDS[lgreen]=102
    BACKGROUNDS[lyellow]=103
    BACKGROUNDS[lblue]=104
    BACKGROUNDS[lpink]=105
    BACKGROUNDS[lcyan]=106
    BACKGROUNDS[white]=107


    FG=${FOREGROUNDS[$1]}
    BG=${BACKGROUNDS[$2]}
    if [[ -z $BG ]]; then
        BG=49
    fi
        
    echo -en "\033[${FG};${BG}m"
}
