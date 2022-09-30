#!/bin/zsh

# Install Rosetta 2
/usr/sbin/softwareupdate --install-rosetta --agree-to-license

# Wait
sleep 5

# List Updates so softwareupdate recognises Rosetta 2
# See: https://www.jamf.com/jamf-nation/discussions/37357/deploy-rosetta-on-m1-machines-before-everything-else
/usr/sbin/softwareupdate --list

exit 0