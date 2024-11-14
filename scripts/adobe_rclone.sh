#!/bin/bash

#BEGIN FUNCTIONS

service_acct () {
  SERVICE=/Users/Shared/service/neat-gasket-311520-efb0bad4c42d.json
  if test -f "$SERVICE"; then
        echo "Google service account json exists."
  else 
        echo "Creating Google service account json."
        mkdir -pv /Users/Shared/service
        tee -a /Users/Shared/service/neat-gasket-311520-efb0bad4c42d.json << 'END'
{
  "type": "service_account",
  "project_id": "neat-gasket-311520",
  "private_key_id": "here",
  "private_key": "here",
  "client_email": "rclone@asdf.iam.gserviceaccount.com",
  "client_id": "here",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "here"
}
END
  fi
}

rclone_conf () {
  CONF=/Users/Shared/.config/rclone/rclone.conf
  if test -f "$CONF"; then
      echo "rclone conf exists."
  else 
      echo "Creating rclone conf in Shared."
      mkdir -pv /Users/Shared/.config/rclone/
      tee -a /Users/Shared/.config/rclone/rclone.conf << 'END'
[rclone-macbooks]
type = drive
client_id = blah
client_secret = blahblah
scope = drive
service_account_file = /Users/Shared/service/neat-gasket-311520-efb0bad4c42d.json
team_drive =
END
    fi
}

rclone_install () {
  #does rclone exist?
  if ! /usr/local/bin/rclone --version > /dev/null; then
    echo "Rclone not installed..."
    # error codes
    # 0 - exited without problems
    # 1 - parameters not supported were used or some unexpected error occurred
    # 2 - OS not supported by this script
    # 3 - installed version of rclone is up to date
    # 4 - supported unzip tools are not available

    set -e

    #when adding a tool to the list make sure to also add its corresponding command further in the script
    unzip_tools_list=('unzip' '7z' 'busybox')

    usage() { echo "Usage: sudo -v ; curl https://rclone.org/install.sh | sudo bash [-s beta]" 1>&2; exit 1; }

    #check for beta flag
    if [ -n "$1" ] && [ "$1" != "beta" ]; then
        usage
    fi

    if [ -n "$1" ]; then
        install_beta="beta "
    fi


    #create tmp directory and move to it with macOS compatibility fallback
    tmp_dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'rclone-install.XXXXXXXXXX')
    cd "$tmp_dir"


    #make sure unzip tool is available and choose one to work with
    set +e
    for tool in ${unzip_tools_list[*]}; do
        trash=$(hash "$tool" 2>>errors)
        if [ "$?" -eq 0 ]; then
            unzip_tool="$tool"
            break
        fi
    done  
    set -e

    # exit if no unzip tools available
    if [ -z "$unzip_tool" ]; then
        printf "\nNone of the supported tools for extracting zip archives (${unzip_tools_list[*]}) were found. "
        printf "Please install one of them and try again.\n\n"
        exit 4
    fi

    # Make sure we don't create a root owned .config/rclone directory #2127
    export XDG_CONFIG_HOME=config

    #check installed version of rclone to determine if update is necessary
    version=$(rclone --version 2>>errors | head -n 1)
    if [ -z "$install_beta" ]; then
        current_version=$(curl -fsS https://downloads.rclone.org/version.txt)
    else
        current_version=$(curl -fsS https://beta.rclone.org/version.txt)
    fi

    if [ "$version" = "$current_version" ]; then
        printf "\nThe latest ${install_beta}version of rclone ${version} is already installed.\n\n"
        exit 3
    fi


    #detect the platform
    OS="$(uname)"
    case $OS in
      Linux)
        OS='linux'
        ;;
      FreeBSD)
        OS='freebsd'
        ;;
      NetBSD)
        OS='netbsd'
        ;;
      OpenBSD)
        OS='openbsd'
        ;;  
      Darwin)
        OS='osx'
        binTgtDir=/usr/local/bin
        man1TgtDir=/usr/local/share/man/man1
        ;;
      SunOS)
        OS='solaris'
        echo 'OS not supported'
        exit 2
        ;;
      *)
        echo 'OS not supported'
        exit 2
        ;;
    esac

    OS_type="$(uname -m)"
    case "$OS_type" in
      x86_64|amd64)
        OS_type='amd64'
        ;;
      i?86|x86)
        OS_type='386'
        ;;
      aarch64|arm64)
        OS_type='arm64'
        ;;
      arm*)
        OS_type='arm'
        ;;
      *)
        echo 'OS type not supported'
        exit 2
        ;;
    esac


    #download and unzip
    if [ -z "$install_beta" ]; then
        download_link="https://downloads.rclone.org/rclone-current-${OS}-${OS_type}.zip"
        rclone_zip="rclone-current-${OS}-${OS_type}.zip"
    else
        download_link="https://beta.rclone.org/rclone-beta-latest-${OS}-${OS_type}.zip"
        rclone_zip="rclone-beta-latest-${OS}-${OS_type}.zip"
    fi

    curl -OfsS "$download_link"
    unzip_dir="tmp_unzip_dir_for_rclone"
    # there should be an entry in this switch for each element of unzip_tools_list
    case "$unzip_tool" in
      'unzip')
        unzip -a "$rclone_zip" -d "$unzip_dir"
        ;;
      '7z')
        7z x "$rclone_zip" "-o$unzip_dir"
        ;;
      'busybox')
        mkdir -p "$unzip_dir"
        busybox unzip "$rclone_zip" -d "$unzip_dir"
        ;;
    esac

    cd $unzip_dir/*

    #mounting rclone to environment

    case "$OS" in
      'linux')
        #binary
        cp rclone /usr/bin/rclone.new
        chmod 755 /usr/bin/rclone.new
        chown root:root /usr/bin/rclone.new
        mv /usr/bin/rclone.new /usr/bin/rclone
        #manual
        if ! [ -x "$(command -v mandb)" ]; then
            echo 'mandb not found. The rclone man docs will not be installed.'
        else 
            mkdir -p /usr/local/share/man/man1
            cp rclone.1 /usr/local/share/man/man1/
            mandb
        fi
        ;;
      'freebsd'|'openbsd'|'netbsd')
        #binary
        cp rclone /usr/bin/rclone.new
        chown root:wheel /usr/bin/rclone.new
        mv /usr/bin/rclone.new /usr/bin/rclone
        #manual
        mkdir -p /usr/local/man/man1
        cp rclone.1 /usr/local/man/man1/
        makewhatis
        ;;
      'osx')
        #binary
        mkdir -m 0555 -p ${binTgtDir}
        cp rclone ${binTgtDir}/rclone.new
        mv ${binTgtDir}/rclone.new ${binTgtDir}/rclone
        chmod a=x ${binTgtDir}/rclone
        #manual
        mkdir -m 0555 -p ${man1TgtDir}
        cp rclone.1 ${man1TgtDir}    
        chmod a=r ${man1TgtDir}/rclone.1
        ;;
      *)
        echo 'OS not supported'
        exit 2
    esac


    #update version variable post install
    version=$(rclone --version 2>>errors | head -n 1)

    printf "\n${version} has successfully installed."
    printf '\nNow run "rclone config" for setup. Check https://rclone.org/docs/ for more details.\n\n'
    exit 0

  fi
}



# END FUNCTIONS

#does rclone exist?
rclone_install

#check if conf exists
service_acct

#check if conf exists
rclone_conf

    

#must be run as root
echo "Starting rclone copy/sync"
/usr/local/bin/rclone --config /Users/Shared/.config/rclone/rclone.conf copy rclone-macbooks: /Users/Shared/
echo "Finished rclone copy/sync"
echo ""
echo "--------------------------------------------"
echo "Starting installation"
echo "--------------------------------------------"
echo ""

filepath=/Users/Shared
filenamezip="AdobeCCJamfSchoolUniversal_Install.pkg.zip"
filename="AdobeCCJamfSchoolUniversal_Install.pkg"
APP="Adobe CC"

TEM="/Applications/Utilities/Adobe Creative Cloud/ACC/Creative Cloud.app"
if [ -d "$TEM" ]; then
    echo "$APP is already installed on $(hostname)"
elif [ ! -f "${filepath:?}/${filenamezip}" ]; then
    echo "Install file not found, not installing ${filepath:?}/${filenamezip}..."

else
    echo "Running script to install "$APP" on $(hostname)"
    mkdir -p ${filepath}
    cd ${filepath} || exit
    echo "Unzipping ${filenamezip}"
    unzip -qo "${filenamezip}"
    rm ${filepath:?}/${filenamezip}
    echo "Installing $APP"
    sudo installer -pkg ${filepath}/"${filename}" -target /Applications/
    rm -r ${filepath:?}/"${filename}"

fi


echo "Done"
