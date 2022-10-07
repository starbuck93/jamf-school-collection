if [ -d "/opt/PrinterInstallerClient/service_interface/PrinterInstallerClient.app" ] 
then
    echo "PrinterLogic probably already installed!" 
    HOMEURL="https://hiddenurl.printercloud.com/"
    CURRENTHOMEURL=$(cat /opt/PrinterInstallerClient/log/HOMEURL)
    if [ -n "$CURRENTHOMEURL" ] && [ "$HOMEURL" != "$CURRENTHOMEURL" ]; then
        /opt/PrinterInstallerClient/bin/set_home_url.sh https hiddenurl.printercloud.com/
    fi
    /opt/PrinterInstallerClient/bin/use_authorization_code.sh 1234abcd
    ls /opt/PrinterInstallerClient/tmp/requests/
    rm -r /opt/PrinterInstallerClient/tmp/requests/*
else
    echo "PrinterLogic probably not installed!" #this should not happen since we're using the Apps feature of Jamf School to install PrinterLogic
    # curl -o /tmp/PrinterInstallerClientSetup.pkg "https://hiddenurl.printercloud.com/client/setup/PrinterInstallerClientSetup.pkg" 
    # installer -allowUntrusted -pkg /tmp/PrinterInstallerClientSetup.pkg -target / 
    # rm /tmp/PrinterInstallerClientSetup.pkg
    # /opt/PrinterInstallerClient/bin/set_home_url.sh https hiddenurl.printercloud.com/
    # /opt/PrinterInstallerClient/bin/use_authorization_code.sh 1234abcd
    # /opt/PrinterInstallerClient/bin/refresh.sh
fi

