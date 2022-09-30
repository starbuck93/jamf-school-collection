#check if conf exists
FILE=/Users/admin/.config/rclone/rclone.conf
if test -f "$FILE"; then
    echo "$FILE exists."
else 
    mkdir -pv /Users/admin/.config/rclone/
    tee -a /Users/admin/.config/rclone/rclone.conf << 'END'
[DML01]
type = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
scope = drive
token = {this.stuff}
team_drive = 

[DML02]
type = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
scope = drive
token = {this.stuff}
team_drive = 

[DML03]
type = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
scope = drive
token = {this.stuff}
team_drive = 

[DML04]
type = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
scope = drive
token = {this.stuff}
team_drive = 

[DML05]
type = drive
scope = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
token = {this.stuff}
team_drive = 

[DML06]
type = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
scope = drive
token = {this.stuff}
team_drive = 

[DML07]
type = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
scope = drive
token = {this.stuff}
team_drive = 

[DML08]
type = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
scope = drive
token = {this.stuff}
team_drive = 

[DML09]
type = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
scope = drive
token = {this.stuff}
team_drive = 

[DML10]
type = drive
scope = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
token = {this.stuff}
team_drive = 

[DML11]
type = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
scope = drive
token = {this.stuff}
team_drive = 

[DML12]
type = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
scope = drive
token = {this.stuff}
team_drive = 

[DML13]
type = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
scope = drive
token = {this.stuff}
team_drive =

[DML14]
type = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
scope = drive
token = {this.stuff}
team_drive =

[DML15]
type = drive
client_id = asdfasdfasdf.apps.googleusercontent.com
client_secret = secretsecretsecret
scope = drive
token = {this.stuff}
team_drive = 
END
fi

#perform rclone syncing
HOSTNAME=$(hostname)
COMPUTER=${HOSTNAME%".local"} #remove suffix of .local to get "DML%%"
USER="dmlstudent"
#must be run as root

/usr/local/bin/rclone --config /Users/admin/.config/rclone/rclone.conf copy -u --max-age 3M --exclude .DS_Store /Users/"$USER"/Desktop/ "$COMPUTER":Desktop/ -v
/usr/local/bin/rclone --config /Users/admin/.config/rclone/rclone.conf copy -u --max-age 3M --exclude .DS_Store /Users/"$USER"/Documents/ "$COMPUTER":Documents/ -v
/usr/local/bin/rclone --config /Users/admin/.config/rclone/rclone.conf copy -u --max-age 3M --exclude .DS_Store /Users/"$USER"/Downloads/ "$COMPUTER":Downloads/ -v
/usr/local/bin/rclone --config /Users/admin/.config/rclone/rclone.conf copy -u --max-age 3M --exclude .DS_Store /Users/"$USER"/Pictures/ "$COMPUTER":Pictures/ -v
 





#DML sync to google drive
#use rclone to sync files to the respective Google Drives of the accounts DML1-DML15
# I don't necesarily recommend this.