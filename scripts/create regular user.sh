#!/bin/bash

#https://gist.github.com/dimitardanailov/6acdd54ab67d5a25c0229b2fe5bbb42b
#https://apple.stackexchange.com/questions/82472/what-steps-are-needed-to-create-a-new-user-from-the-command-line/84039#84039

LOCAL_USER_FULLNAME="Some Full Name"     # The local user's full name
LOCAL_USER_SHORTNAME="someusername"     # The local user's shortname
LOCAL_USER_PASSWORD=""      # The local user's password ... maybe the blank password works?
LOCAL_USER_HINT="blank password"           # The local user's password

LastID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1)
NextID=$((LastID + 1))

if [ $LOCAL_USER_SHORTNAME = "$(dscl . -list /Users UniqueID | awk '{print $1}' | grep -w $LOCAL_USER_SHORTNAME)" ]; then
    echo "User already exists!"
    exit 0
fi

. /etc/rc.commond
dscl . create /Users/$LOCAL_USER_SHORTNAME
dscl . create /Users/$LOCAL_USER_SHORTNAME RealName "$LOCAL_USER_FULLNAME"
dscl . create /Users/$LOCAL_USER_SHORTNAME hint "$LOCAL_USER_HINT"
curl https://i.ibb.co/Bc8GkLw/some_pic.png --output /tmp/img.png
dscl . create /Users/$LOCAL_USER_SHORTNAME picture "/tmp/img.png"
dscl . passwd /Users/$LOCAL_USER_SHORTNAME $LOCAL_USER_PASSWORD
dscl . create /Users/$LOCAL_USER_SHORTNAME UniqueID $NextID
dscl . create /Users/$LOCAL_USER_SHORTNAME PrimaryGroupID 20
dscl . create /Users/$LOCAL_USER_SHORTNAME UserShell /bin/bash
dscl . create /Users/$LOCAL_USER_SHORTNAME NFSHomeDirectory /Users/$LOCAL_USER_SHORTNAME

createhomedir -u $LOCAL_USER_SHORTNAME -c

echo "New user $(dscl . -list /Users UniqueID | awk '{print $1}' | grep -w "$LOCAL_USER_SHORTNAME") has been created with unique ID $(dscl . -list /Users UniqueID | grep -w "$LOCAL_USER_SHORTNAME" | awk '{print $2}')"



#create new regular user