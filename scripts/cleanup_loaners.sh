#!/bin/bash

#adapted from https://community.jamf.com/t5/jamf-pro/script-to-find-delete-local-accounts-with-unique-id-higher-than/m-p/70027

# The script must be run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Retrieve all users having a UID >= 500
user_dirs_to_delete=($(dscl . -list /Users UniqueID | awk '$2 >= 500 {print $1}'))

# Print the total number of user directories that will be potentially deleted
echo "Total user accounts to be potentially deleted: ${#user_dirs_to_delete[@]}"

# Iterate over the array and delete each user and their home directory
for user_dir in "${user_dirs_to_delete[@]}"; do
    # Skip over specific users
    if [[ "$user_dir" == "admin" || "$user_dir" == "astarbuck" || "$user_dir" == "macports" || "$user_dir" == "Shared" || "$user_dir" == "com.malwarebytes.ncep.nobody" ]]; then
        echo "Skipping $user_dir"
        continue
    fi

    home_dir="/Users/$user_dir"
    echo "Processing user: $user_dir"

    # Try to delete the user using sysadminctl
    sysadminctl -deleteUser "$user_dir" 
    echo "User account '$user_dir' deleted via sysadminctl."

    # Now, clean up any remaining traces using dscl
    # Terminate any processes running under the user's ID
    pkill -u "$user_dir"
    echo "Killed processes"

    # Remove the user account using dscl
    dscl . -delete /Users/"$user_dir"
    echo "User account '$user_dir' deleted via dscl."

    # Remove the user's group if it exists
    dscl . -delete /Groups/"$user_dir"
    echo "User's group '$user_dir' deleted via dscl."

    # Delete the user's home directory if it still exists
    if [ -d "$home_dir" ]; then
        echo "Removing home directory: $home_dir"
        rm -rf "$home_dir"
        if [ $? -eq 0 ]; then
            echo "Successfully removed home directory: $home_dir"
        else
            echo "Failed to remove home directory: $home_dir" 1>&2
        fi
    else
        echo "Home directory $home_dir does not exist"
    fi
done

echo "Cleanup complete."