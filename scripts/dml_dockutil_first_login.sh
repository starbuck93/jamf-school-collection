#!/bin/bash

# This script modifies a user's Dock on their first login by removing default apps and adding specific ones, while ensuring it only runs once per user account to prevent duplicate modifications.

# Get the current username
USERNAME=$(stat -f %Su /dev/console)

# Get the user's account creation time in Unix timestamp format
createdTime=$(dscl . readpl /Users/"$USERNAME" accountPolicyData creationTime | awk -F: '{ print $2 }' | tr -d " " | cut -d "." -f 1)

# Check if the .dockdone file exists to avoid running the script multiple times
if [ -f /Users/"$USERNAME"/.dockdone ]; then
    echo "I think the dock has already been modified."
else
    # Check if the user's account was created within the last 5 minutes and if dockutil is installed
    if [ $(($(date +%s) - $createdTime)) -le 300 ] || [ -e /usr/local/bin/dockutil ]; then
    echo "User account is new. Cleaning up dock..."

        # Remove unwanted apps from the dock
    /usr/local/bin/dockutil --remove "Safari" /Users/"$USERNAME" --no-restart
    /usr/local/bin/dockutil --remove "Mail" /Users/"$USERNAME" --no-restart 
    /usr/local/bin/dockutil --remove "Messages" /Users/"$USERNAME" --no-restart 
    /usr/local/bin/dockutil --remove "Maps" /Users/"$USERNAME" --no-restart 
    /usr/local/bin/dockutil --remove "Photos" /Users/"$USERNAME" --no-restart 
    /usr/local/bin/dockutil --remove "FaceTime" /Users/"$USERNAME" --no-restart 
    /usr/local/bin/dockutil --remove "Calendar" /Users/"$USERNAME" --no-restart 
    /usr/local/bin/dockutil --remove "Contacts" /Users/"$USERNAME" --no-restart 
    /usr/local/bin/dockutil --remove "Reminders" /Users/"$USERNAME" --no-restart 
    /usr/local/bin/dockutil --remove "Notes" /Users/"$USERNAME" --no-restart 
    /usr/local/bin/dockutil --remove "Freeform" /Users/"$USERNAME" --no-restart 
    /usr/local/bin/dockutil --remove "TV" /Users/"$USERNAME" --no-restart 
    /usr/local/bin/dockutil --remove "Music" /Users/"$USERNAME" --no-restart 
    /usr/local/bin/dockutil --remove "News" /Users/"$USERNAME" --no-restart 

        # Add specific apps to the dock
    /usr/local/bin/dockutil --add '/Applications/Google Chrome.app' /Users/"$USERNAME" --no-restart
    /usr/local/bin/dockutil --add '/Applications/Utilities/Adobe Creative Cloud/ACC/Creative Cloud.app' /Users/"$USERNAME"

        # Create the .dockdone file to mark that the script has run
    touch /Users/"$USERNAME"/.dockdone
    fi
fi
