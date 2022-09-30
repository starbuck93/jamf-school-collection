#!/bin/sh

#https://gist.github.com/dimitardanailov/6acdd54ab67d5a25c0229b2fe5bbb42b
#https://apple.stackexchange.com/questions/82472/what-steps-are-needed-to-create-a-new-user-from-the-command-line/84039#84039

LOCAL_ADMIN_FULLNAME="Firstname Lastname"     # The local admin user's full name
LOCAL_ADMIN_SHORTNAME="flastname"     # The local admin user's shortname
LOCAL_ADMIN_PASSWORD="password"      # The local admin user's password

serial="$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')"

if [[ "$serial" == "myserial" ]]; then

    LastID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1)
    NextID=$((LastID + 1))
    
    if [ $LOCAL_ADMIN_SHORTNAME = "$(dscl . -list /Users UniqueID | awk '{print $1}' | grep -w $LOCAL_ADMIN_SHORTNAME)" ]; then
        echo "User already exists!"
        exit 0
    fi
    
    . /etc/rc.common
    dscl . create /Users/$LOCAL_ADMIN_SHORTNAME
    dscl . create /Users/$LOCAL_ADMIN_SHORTNAME RealName "$LOCAL_ADMIN_FULLNAME"
    dscl . create /Users/$LOCAL_ADMIN_SHORTNAME hint "Default Password"
    # dscl . create /Users/$LOCAL_ADMIN_SHORTNAME picture "/Path/To/Picture.png"
    dscl . passwd /Users/$LOCAL_ADMIN_SHORTNAME $LOCAL_ADMIN_PASSWORD
    dscl . create /Users/$LOCAL_ADMIN_SHORTNAME UniqueID $NextID
    dscl . create /Users/$LOCAL_ADMIN_SHORTNAME PrimaryGroupID 80
    dscl . create /Users/$LOCAL_ADMIN_SHORTNAME UserShell /bin/bash
    dscl . create /Users/$LOCAL_ADMIN_SHORTNAME NFSHomeDirectory /Users/$LOCAL_ADMIN_SHORTNAME
    # cp -R /System/Library/User\ Template/English.lproj /Users/$LOCAL_ADMIN_SHORTNAME
    # chown -R $LOCAL_ADMIN_SHORTNAME:staff /Users/$LOCAL_ADMIN_SHORTNAME
    createhomedir -u $LOCAL_ADMIN_SHORTNAME -c
    echo "New user $(dscl . -list /Users UniqueID | awk '{print $1}' | grep -w "$LOCAL_ADMIN_SHORTNAME") has been created with unique ID $(dscl . -list /Users UniqueID | grep -w "$LOCAL_ADMIN_SHORTNAME" | awk '{print $2}')"
    
fi

#create new admin user
# Typically used to create a teacher/admin account. 
# this is mostly made unneccessary by automated device enrollment + assigning the user to the device