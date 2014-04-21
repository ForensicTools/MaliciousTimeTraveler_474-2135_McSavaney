#!/bin/bash

# colors.sh

# source me!

function reset_colors ()
{
    tput sgr0
}

function hsv2rgb()
{
    h="$1"
    s="$2"
    v="$3"

    i=$( echo "$h/60" | bc )
    h=$( echo -e "scale=4\n $h/60" | bc ) 
    f=$( echo  "$h - $i" | bc )
    p=$( echo "($v * (6 - $s)) / 6" | bc )
    q=$( echo "($v * (6 - $s * $f)) / 6" | bc )
    t=$( echo "($v * (6 - $s * (1 - $f))) / 6" | bc )

    case $i in
        0)
            echo "$(( v * 36 + t * 6 + p ))"
            ;;

        1)
            echo "$(( q * 36 + v * 6 + p ))"
            ;;

        2)
            echo "$(( p * 36 + v * 6 + t ))"
            ;;

        3)
            echo "$(( p * 36 + q * 6 + v ))"
            ;;

        4)
            echo "$(( t * 36 + p * 6 + v ))"
            ;;

        5)
            echo "$(( v * 36 + p * 6 + q ))"
            ;;
    esac
}

