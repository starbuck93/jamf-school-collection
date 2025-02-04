#!/bin/bash

#writing my own swiftdialog script to get people to reboot. The example icon was of the Apple menu --> Restart... option highlighted 

# Define variables
DIALOG_PATH="/usr/local/bin/dialog"  # Update if SwiftDialog is installed elsewhere
ICON_PATH="/Users/astarbuck/Pictures/SCR-20241113-jhoz.png"  # Example icon
IMG_PATH="/Users/astarbuck/Pictures/SCR-20241113-jhoz.png"  # Example icon
TITLE="Wow, it's time to reboot"

#get uptime
days=$(uptime | awk '{ print $4 }' | sed 's/,//g')
num=$(uptime | awk '{ print $3 }')

if [ "$days" = "days" ]; then
    echo "$num $days"
elif [ "$days" = "day" ]; then
    num=1
    echo "1 $days"
else
    num=0
    echo "0 $days"
fi

MESSAGE="It appears your laptop has been powered on for $num $days. Please reboot it now to avoid any issues. Don't worry, your Chrome tabs will reopen!"

if [ "$num" -gt 1 ]; then

    "$DIALOG_PATH" \
        --title "$TITLE" \
        --imagecaption "$MESSAGE" \
        --icon "$ICON_PATH" \
        --image "$IMG_PATH" \
        --quitkey "q" \
        --ontop \
        --button1text "Ok I'll reboot, I promise!" \
        --json \
        --blurscreen 
    status=$?
    if [ $status -eq 3 ]; then
        reboot
    fi
fi
