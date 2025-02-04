#!/bin/bash

# Get the currently logged in user
loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
# Define the path for the symlink that will be created on the user's desktop
my_link=/Users/"$loggedInUser"/Desktop/Saved\ From\ dmlstudent\ Acct

# Check if the symlink already exists and is valid
if [ -L "${my_link}" ] && [ -e "${my_link}" ]; then
    echo "Already exists & good link"
# Check if the shared folder exists but link needs to be created
elif [ -d "/Users/Shared/Saved From dmlstudent Acct" ]; then
    echo "Files already moved, just need to create link"
    # Create symlink from shared folder to user's desktop
    ln -s /Users/Shared/Saved\ From\ dmlstudent\ Acct/ /Users/"$loggedInUser"/Desktop/Saved\ From\ dmlstudent\ Acct
else
    echo "Move files"
    # Create necessary directories in the shared location
    mkdir -vp /Users/Shared/Saved\ From\ dmlstudent\ Acct/ /Users/Shared/Saved\ From\ dmlstudent\ Acct/Desktop /Users/Shared/Saved\ From\ dmlstudent\ Acct/Documents /Users/Shared/Saved\ From\ dmlstudent\ Acct/Pictures
    
    # Move all files from dmlstudent account to shared location
    mv -v /Users/dmlstudent/Desktop/* /Users/Shared/Saved\ From\ dmlstudent\ Acct/Desktop
    mv -v /Users/dmlstudent/Downloads/* /Users/Shared/Saved\ From\ dmlstudent\ Acct/Downloads
    mv -v /Users/dmlstudent/Documents/* /Users/Shared/Saved\ From\ dmlstudent\ Acct/Documents
    mv -v /Users/dmlstudent/Pictures/* /Users/Shared/Saved\ From\ dmlstudent\ Acct/Pictures

    echo "create link"
    # Create symlink from shared folder to user's desktop
    ln -s /Users/Shared/Saved\ From\ dmlstudent\ Acct/ /Users/"$loggedInUser"/Desktop/Saved\ From\ dmlstudent\ Acct
fi
