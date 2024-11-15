#!/bin/bash

loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )
my_link=/Users/"$loggedInUser"/Desktop/Saved\ From\ dmlstudent\ Acct

if [ -L ${my_link} ] && [ -e ${my_link} ]; then
    echo "Already exists & good link"
else
    echo "Move files"
    mkdir -vp /Users/Shared/Saved\ From\ dmlstudent\ Acct/ /Users/Shared/Saved\ From\ dmlstudent\ Acct/Desktop /Users/Shared/Saved\ From\ dmlstudent\ Acct/Documents /Users/Shared/Saved\ From\ dmlstudent\ Acct/Pictures
    mv -v /Users/dmlstudent/Desktop/* /Users/Shared/Saved\ From\ dmlstudent\ Acct/Desktop
    mv -v /Users/dmlstudent/Downloads/* /Users/Shared/Saved\ From\ dmlstudent\ Acct/Downloads
    mv -v /Users/dmlstudent/Documents/* /Users/Shared/Saved\ From\ dmlstudent\ Acct/Documents
    mv -v /Users/dmlstudent/Pictures/* /Users/Shared/Saved\ From\ dmlstudent\ Acct/Pictures

    echo "create link"
    ln -s /Users/Shared/Saved\ From\ dmlstudent\ Acct/ /Users/"$loggedInUser"/Desktop/Saved\ From\ dmlstudent\ Acct

fi
