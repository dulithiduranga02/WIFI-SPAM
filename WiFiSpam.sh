#!/bin/bash

# TERMINAL COLORS
NO_COLOR="\e[0m"
WHITE="\e[0;17m"
BOLD_WHITE="\e[1;37m"
BLACK="\e[0;30m"
BLUE="\e[0;34m"
BOLD_BLUE="\e[1;34m"
GREEN="\e[0;32m"
BOLD_GREEN="\e[1;32m"
CYAN="\e[0;36m"
BOLD_CYAN="\e[1;36m"
RED="\e[0;31m"
BOLD_RED="\e[1;31m"
PURPLE="\e[0;35m"
BOLD_PURPLE="\e[1;35m"
BROWN="\e[0;33m"
BOLD_YELLOW="\e[1;33m"
GRAY="\e[0;37m"
BOLD_GRAY="\e[1;30m"
# END OF TERMINAL COLORS

function coolexit() {
    clear
    ifconfig "$AD" down > /dev/null 2>&1
    macchanger -p "$AD" > /dev/null 2>&1
    iwconfig "$AD" mode managed > /dev/null 2>&1
    ifconfig "$AD" up > /dev/null 2>&1
    rm RANDOM_wordlist.txt > /dev/null 2>&1
    nmcli device connect "$AD" > /dev/null 2>&1
    clear
    title
    echo -e "$BOLD_RED   Thank you for using this script."
    echo -e "   Visit my GitHub at: $BOLD_WHITE https://github.com/125K"
    exit
}

function title() {
    echo -e "$BOLD_GREEN    _       ___ _______    _____                     "
    echo "   | |     / (_) ____(_)  / ___/____  ____ _____ ___ "
    echo "   | | /| / / / /_  / /   \\__ \\/ __ \\/ __ \`/ __ \`__ \\"
    echo "   | |/ |/ / / __/ / /   ___/ / /_/ / /_/ / / / / / /"
    echo "   |__/|__/_/_/   /_/   /____/ .___/\\__,_/_/ /_/ /_/"
    echo "                            /_/                      "
    echo " "
}

title
sleep 1
echo -e "$BOLD_GREEN   Available interfaces: "
echo -e -n "$BOLD_WHITE"
ifconfig | grep -e ": " | sed -e 's/: .*//g' | sed -e 's/^/   /'
echo " "
echo -n -e "$BOLD_BLUE   Please enter your wireless interface name > "
echo -n -e "$BOLD_WHITE"
read -r AD
clear
title
echo -e "$BOLD_BLUE  Select an option:"
echo " "
echo -e "$BOLD_BLUE  1.$BOLD_WHITE Use the default word list (1000 SSIDs)"
echo -e "$BOLD_BLUE  2.$BOLD_WHITE Create a custom word list and use it"
echo -e "$BOLD_BLUE  3.$BOLD_WHITE Use an existing word list"
echo -e "$BOLD_BLUE  4.$BOLD_WHITE Generate random SSIDs"
echo " "
echo -n -e "$BOLD_BLUE  > "
echo -n -e "$BOLD_WHITE"
read -r DD
clear

case $DD in
    1)
        nmcli device disconnect "$AD" > /dev/null 2>&1
        clear
        title
        echo -e "$BOLD_GREEN Initiating process..."
        echo " Press CTRL+C to stop at any time."
        echo " "
        trap coolexit EXIT
        sleep 1
        ifconfig "$AD" down
        macchanger -r "$AD"
        iwconfig "$AD" mode monitor
        ifconfig "$AD" up
        trap coolexit EXIT
        mdk3 "$AD" b -f ./SSID_List.txt -a -s 1000
        ;;
    2)
        nmcli device disconnect "$AD" > /dev/null 2>&1
        clear
        title
        echo -n -e "$BOLD_BLUE Please enter a string (Max. length: 12) > "
        echo -n -e "$BOLD_WHITE"
        read -r WORD
        echo -n -e "$BOLD_BLUE How many SSIDs do you want? > "
        echo -n -e "$BOLD_WHITE"
        read -r N
        COUNT=1
        while [ "$COUNT" -le "$N" ]; do
            echo "$WORD $COUNT" >> "$WORD"_wordlist.txt
            ((COUNT++))
        done
        clear
        title
        echo -e "$BOLD_GREEN Initiating process..."
        echo " Press CTRL+C to stop at any time."
        echo " "
        trap coolexit EXIT
        sleep 1
        ifconfig "$AD" down
        macchanger -r "$AD"
        iwconfig "$AD" mode monitor
        ifconfig "$AD" up
        trap coolexit EXIT
        mdk3 "$AD" b -f ./"$WORD"_wordlist.txt -a -s 1000
        ;;
    3)
        nmcli device disconnect "$AD" > /dev/null 2>&1
        clear
        title
        echo -e "$BOLD_WHITE Note: Your word list must have the same structure as"
        echo -e " SSID_List.txt, otherwise the process won't work."
        echo " "
        echo -n -e "$BOLD_BLUE Please enter the name of your own word list > "
        echo -n -e "$BOLD_WHITE"
        read -r OWN
        clear
        title
        echo -e "$BOLD_GREEN Initiating process..."
        echo " Press CTRL+C to stop at any time."
        echo -e "$BOLD_WHITE"
        sleep 1
        ifconfig "$AD" down
        macchanger -r "$AD"
        iwconfig "$AD" mode monitor
        ifconfig "$AD" up
        trap coolexit EXIT
        mdk3 "$AD" b -f ./"$OWN" -a -s "$(wc -l < "$OWN")"
        ;;
    4)
        nmcli device disconnect "$AD" > /dev/null 2>&1
        clear
        title
        echo -n -e "$BOLD_BLUE How many random SSIDs do you want? > "
        echo -n -e "$BOLD_WHITE"
        read -r N
        COUNT=1
        while [ "$COUNT" -le "$N" ]; do
            echo "$(pwgen 14 1)" >> "RANDOM_wordlist.txt"
            ((COUNT++))
        done
        clear
        title
        echo -e "$BOLD_GREEN Initiating process..."
        echo " Press CTRL+C to stop at any time."
        echo " "
        sleep 1
        ifconfig "$AD" down
        macchanger -r "$AD"
        iwconfig "$AD" mode monitor
        ifconfig "$AD" up
        trap coolexit EXIT
        mdk3 "$AD" b -f ./RANDOM_wordlist.txt -a -s "$N"
        ;;
    *)
        echo -e "$BOLD_RED Invalid option! Exiting..."
        exit 1
        ;;
esac
