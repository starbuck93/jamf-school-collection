if [ -d "/opt/PrinterInstallerClient/" ] 
then
    echo "PrinterLogic probably already installed!" 
    HOMEURL="https://ourprintercloud.printercloud.com/"
    CURRENTHOMEURL=$(cat /opt/PrinterInstallerClient/log/HOMEURL)
    if [ -n "$CURRENTHOMEURL" ] && [ "$HOMEURL" != "$CURRENTHOMEURL" ]; then
        /opt/PrinterInstallerClient/bin/set_home_url.sh https ourprintercloud.printercloud.com/
    fi
    /opt/PrinterInstallerClient/bin/use_authorization_code.sh 1234abcd
    ls /opt/PrinterInstallerClient/tmp/requests/
    rm -r /opt/PrinterInstallerClient/tmp/requests/*
else
    echo "PrinterLogic probably not installed!"
    curl -o /tmp/PrinterInstallerClientSetup.pkg "https://ourprintercloud.printercloud.com/client/setup/PrinterInstallerClientSetup.pkg" 
    installer -allowUntrusted -pkg /tmp/PrinterInstallerClientSetup.pkg -target / 
    rm /tmp/PrinterInstallerClientSetup.pkg
    /opt/PrinterInstallerClient/bin/set_home_url.sh https ourprintercloud.printercloud.com/
    /opt/PrinterInstallerClient/bin/use_authorization_code.sh 1234abcd
    /opt/PrinterInstallerClient/bin/refresh.sh
fi

