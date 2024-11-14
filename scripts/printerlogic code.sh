#!/bin/bash

#
# This script checks if PrinterLogic is installed on a system, updates its home URL and authorization code if necessary, or installs it if not already present.
#


# Check if PrinterLogic client is already installed
if [ -d "/opt/PrinterInstallerClient/service_interface/PrinterInstallerClient.app" ]; then
    echo "PrinterLogic probably already installed!" 
    
    # Set the home URL for the client
    HOMEURL="https://standrewsepiscopalschool.printercloud.com/"
    CURRENTHOMEURL=$(cat /opt/PrinterInstallerClient/log/HOMEURL)
    if [ -n "$CURRENTHOMEURL" ] && [ "$HOMEURL" != "$CURRENTHOMEURL" ]; then
        /opt/PrinterInstallerClient/bin/set_home_url.sh https standrewsepiscopalschool.printercloud.com/
    fi
    
    # Use the authorization code for the client
    /opt/PrinterInstallerClient/bin/use_authorization_code.sh MYCODEGOESHERE
    
    # List the contents of the requests directory and remove them
    ls /opt/PrinterInstallerClient/tmp/requests/
    rm -r /opt/PrinterInstallerClient/tmp/requests/*

# Check if the preinstall directory is present
elif [ -d "/opt/pl_preinstall" ]; then
    echo "PrinterLogic not installed fully - attempting to run installer"
    
    # Change permissions for the installer service and run it
    chmod u+x /opt/pl_preinstall/PrinterInstallerClient/service_interface/PrinterInstallerClientService
    if /opt/pl_preinstall/PrinterInstallerClient/service_interface/./PrinterInstallerClientService install; then
        /opt/PrinterInstallerClient/bin/set_home_url.sh https standrewsepiscopalschool.printercloud.com/
        /opt/PrinterInstallerClient/bin/use_authorization_code.sh MYCODEGOESHERE
        /opt/PrinterInstallerClient/bin/refresh.sh
    fi

# If neither of the above conditions are met, download and install PrinterLogic client
else
    echo "PrinterLogic probably not installed!"
    
    # Download the installer package from the specified URL
    curl -o /tmp/PrinterInstallerClientSetup.pkg "https://standrewsepiscopalschool.printercloud.com/client/setup/PrinterInstallerClientSetup.pkg" 
    
    # Install the downloaded package using the system's installer tool
    installer -allowUntrusted -pkg /tmp/PrinterInstallerClientSetup.pkg -target / 
    
    # Remove the downloaded package file
    rm /tmp/PrinterInstallerClientSetup.pkg
    
    # Set the home URL for the client and use the authorization code
    /opt/PrinterInstallerClient/bin/set_home_url.sh https standrewsepiscopalschool.printercloud.com/
    /opt/PrinterInstallerClient/bin/use_authorization_code.sh MYCODEGOESHERE
    
    # Refresh the client to complete the installation
    /opt/PrinterInstallerClient/bin/refresh.sh
fi
