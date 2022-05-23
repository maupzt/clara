#!/bin/bash

display_usage() {
	echo "Usage: this script automates the setup of WordPress."
	echo ""
	echo "parameters: <sitename> <website url> <wp admin username> <wp admin password> <db host> <db user> <db password>"
	echo ""
}

# website name
sitename = $1
# website url
siteurl = $2

# wordpress admin username
wpAdmin = $2
# wordpress admin password
wpPass = $3

# databse host
dbHost = $4
# databse user
dbUser = $5
# databse password
dbPassword = $6
# databse name
dbName = $7

# MySQL path
MYSQL='/usr/bin/mysql'
mysqlrootpass = "YOUR ROOT PASSWORD HERE"

# Setup DB & DB User
$MYSQL -uroot -p$mysqlrootpass -e "CREATE DATABASE IF NOT EXISTS $dbName; GRANT ALL ON $dbName.* TO '$dbUser'@'$dbHost' IDENTIFIED BY '$dbPassword'; FLUSH PRIVILEGES "


# Download latest WordPress and uncompress
wget http://wordpress.org/latest.tar.gz
tar zxf latest.tar.gz
mv wordpress/* ./

# Build wp-config.php file
sed -e "s/localhost/"$dbHost"/" -e "s/database_name_here/"$dbName"/" -e "s/username_here/"$dbUser"/" -e "s/password_here/"$dbPassword"/" wp-config-sample.php > wp-config.php

# Run install
curl -d "weblog_title=$sitename&user_name=$wpAdmin&admin_password=$wpPass&admin_password2=$wpPass&admin_email=admin@example.org" http://$siteurl/wp-admin/install.php?step=2

# Tidy up
rmdir wordpress
rm latest.tar.gz
rm wp-config-sample.php

clear

echo "================================================================="
echo "Installation is complete."
echo "================================================================="
