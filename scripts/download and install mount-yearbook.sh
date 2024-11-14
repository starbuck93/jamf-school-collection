#!/bin/bash
####################################################################################################
#
#
#
# I'm not using this, either, since Jamf School packages works good enough 
#
####################################################################################################


filepath=/Users/Shared
filename="mount-yearbook.pkg"

MS="/Applications/mount-yearbook.app"
if [ -d "$MS"]; then
    echo "mount-yearbook is already installed on $(hostname)"
else
    echo "Running script to install mount-yearbook on $(hostname)"
    mkdir -p ${filepath}
    cd ${filepath} || exit
    echo "Downloading ${filename}"
    
    if test -f "${filepath:?}/${filename}"; then
        echo "${filename} exists."
    else
        curl "https://your-s3-implementation/mount-yearbook.pkg" -o "${filename}" && echo "Downloaded ${filename}"
    fi


    echo "Installing mount-yearbook"
    sudo installer -pkg ${filepath}/"${filename}" -target /Applications/
    

fi

#download and install mount-yearbook
