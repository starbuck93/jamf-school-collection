#!/bin/bash

# I attempted to use this, but I would recommend using the built-in tools in Jamf School now.

PRINTER="US_DML_DELL"
DESCRIPTION="DML Dell B&W"
IPADDR="10.64.0.172"
lpstat -p $PRINTER -v | grep "$PRINTER"
if [ $? = 1 ]; then
    lpadmin -p $PRINTER -D "$DESCRIPTION" -E -v ipp://$IPADDR/ipp/print -m everywhere
    lpstat -p $PRINTER -v | grep "$PRINTER"
else
    echo "$DESCRIPTION Already Installed"
fi

PRINTER="US_DML_CANON_COLOR"
DESCRIPTION="DML Canon Color"
IPADDR="10.64.12.120"
lpstat -p $PRINTER -v | grep "$PRINTER"
if [ $? = 1 ]; then
    lpadmin -p $PRINTER -D "$DESCRIPTION" -E -v ipp://$IPADDR/ipp/print -m everywhere
    lpstat -p $PRINTER -v | grep "$PRINTER"
else
    echo "$DESCRIPTION Already Installed"
fi

#DML Printers Install
#check if installed, then go ahead and install it
