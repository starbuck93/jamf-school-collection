#!/bin/bash
## postinstall

pathToScript=$0
pathToPackage=$1
targetLocation=$2
targetVolume=$3

#If a user is already logged in, then bootstrap. If no user is logged in, don't bootstrap.
# get the currently logged in user
currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )

# As needed through script, logged in user is variable below
loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

# Get loggedInUser ID
userID=$( id -u "$loggedInUser" )

# Define the path to the default Nudge LaunchAgent
LAUNCHDAEMON_PATH="/Library/LaunchAgents/com.github.macadmins.Nudge.plist"

# Step 1: Unload the existing LaunchAgent if it exists
# global check if there is a user logged in
if [ -z "$currentUser" -o "$currentUser" = "loginwindow" ]; then
  echo "no user logged in, no need to bootout the LaunchAgent"
else 
    echo "Unloading existing com.github.macadmins.Nudge..."
    if ! launchctl bootout gui/"$userID" "$LAUNCHDAEMON_PATH"; then
        echo "Failed to unload the new Nudge agent."
        exit 1
    fi
fi


# Step 2: Replace the existing PLIST file with the new content

#accomplishing this with the PKG

# Step 3: Load the new LaunchAgent

# global check if there is a user logged in
if [ -z "$currentUser" -o "$currentUser" = "loginwindow" ]; then
  echo "no user logged in, no need to bootstrap the LaunchAgent"
else 
    echo "Loading the new com.github.macadmins.Nudge..."
    if ! launchctl bootstrap gui/"$userID" "$LAUNCHDAEMON_PATH"; then
        echo "Failed to load the new Nudge agent."
        exit 1
    fi
fi


echo "Script completed. Custom Nudge LaunchAgent has been updated and reloaded."

# Only run if on a running system
if [[ $3 == "/" ]] ; then
  if [ -f '/Applications/Utilities/Nudge.app/Contents/Resources/postinstall-launchagent' ]; then
    /bin/zsh --no-rcs -c '/Applications/Utilities/Nudge.app/Contents/Resources/postinstall-launchagent'
  else
    echo "File does not exist: Please ensure Nudge is installed prior to installation of these packages"
  fi
fi

# ls $LAUNCHDAEMON_PATH


exit 0		## Success
exit 1		## Failure
