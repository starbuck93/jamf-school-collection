#!/bin/bash

# I needed a script to change the password if the current logged in user is a default account I created before moving to Jamf Connect so people can't use the Loaner account anymore
# Turns out, there doesn't appear to be a way to change a user's password automatically, so I just pop up the System Settings dialog
# I could also disable the account.........

# pwpolicy -u username disableuser


# Define variables
USERNAME="loaner"
DIALOG_PATH="/usr/local/bin/dialog"  # Update if SwiftDialog is installed elsewhere
ICON_PATH="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Everyone.icns"  # Example icon
TITLE="Password Change Required"
MESSAGE="Please enter and confirm a new password for your account."

loggedInUser=$(stat -f "%Su" /dev/console)
loggedInUser="loaner"
# Download a dictionary file if not already downloaded
DICTIONARY_URL="https://www.mit.edu/~ecprice/wordlist.10000"
DICTIONARY_FILE="/tmp/words.txt"

if [ ! -f "$DICTIONARY_FILE" ]; then
  curl -s "$DICTIONARY_URL" -o "$DICTIONARY_FILE"
fi

# Count the number of words in the dictionary
WORD_COUNT=$(wc -l < "$DICTIONARY_FILE")

# Generate three random numbers and save them to separate variables
NUM1=$(( RANDOM ))
NUM2=$(( RANDOM ))
NUM3=$(( RANDOM ))

# Generate three distinct random words
WORD1=$(awk "NR == $(( NUM1 % WORD_COUNT + 1 ))" "$DICTIONARY_FILE")
WORD2=$(awk "NR == $(( NUM2 % WORD_COUNT + 1 ))" "$DICTIONARY_FILE")
WORD3=$(awk "NR == $(( NUM3 % WORD_COUNT + 1 ))" "$DICTIONARY_FILE")

# Combine words with dashes to form the new password
PASSWORD="$WORD1-$WORD2-$WORD3"

echo $PASSWORD

# Check if the user is logged in as the specified username
if [[ "$loggedInUser" == "$USERNAME" ]]; then
    echo "User is logged in as $USERNAME."
        # Run the SwiftDialog prompt
    "$DIALOG_PATH" \
        --title "$TITLE" \
        --message "$MESSAGE <br><br> Suggested password: $PASSWORD" \
        --icon "$ICON_PATH" \
        --infobutton \
        --infobuttontext "Click to change the password in System Settings" \
        --quitkey "q" \
        --ontop \
        --button1text "Sure whatever" \
        --json \
        --blurscreen \
        -s
    status=$?
    if [ $status -eq 3 ]; then
        # Open the Touch ID settings in System Preferences
        open x-apple.systempreferences:com.apple.Touch-ID-Settings.extension
    else
        open x-apple.systempreferences:com.apple.Touch-ID-Settings.extension
        "$DIALOG_PATH" \
        --title "Too Bad" \
        --message "Do it anyways. <br><br> Opened System Settings for you." \
        --button1text "Ugh OK" \
        --icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarDeleteIcon.icns" \
        --quitkey "q" \
        --ontop \
        --style alert \
        --json
    fi
else
    echo "User is not logged in as $USERNAME. Got $loggedInUser instead. Exiting script."
    exit 1
fi


