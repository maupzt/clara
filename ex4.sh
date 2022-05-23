#!/bin/bash

display_usage() {
	echo "Usage: this script automates the setup of WordPress."
	echo ""
	echo "parameters: <siteName> <wp admin username> <wp admin password> <db host> <db user> <db password>"
	echo ""
}

# check if the user supplied -h or --help and then display usage
if [[ ( $@ == "--help") ||  $@ == "-h" ]]; then
	display_usage
	exit 0
fi

# check if the user supplied less arguments than required and then display usage
if [ $# -le 6 ]; then
	display_usage
	exit 0
fi

# website name
siteName=$1

# wordpress admin username
wpAdmin=$2
# wordpress admin password
wpPass=$3

# databse host
dbHost=$4
# databse user
dbUser=$5
# databse password
dbPassword=$6
# databse name
dbName=$7


# MySQL path
#MYSQL='/usr/bin/mysql'
#mysqlrootpass="YOUR ROOT PASSWORD HERE"

# Setup DB & DB User
#$MYSQL -uroot -p$mysqlrootpass -e "CREATE DATABASE IF NOT EXISTS $dbName; GRANT ALL ON $dbName.* TO '$dbUser'@'$dbHost' IDENTIFIED BY '$dbPassword'; FLUSH PRIVILEGES "

# create sitename folder
[ ! -d '/var/www/html/$sitename' ] && mkdir -p /var/www/html/$siteName

# Download latest WordPress and uncompress
wget http://wordpress.org/latest.tar.gz
tar zxf latest.tar.gz
#mv wordpress/* ./

# Build wp-config.php file
cd wordpress && sed -e "s/localhost/"$dbHost"/" -e "s/database_name_here/"$dbName"/" -e "s/username_here/"$dbUser"/" -e "s/password_here/"$dbPassword"/" wp-config-sample.php > wp-config.php

cd ../ && mv wordpress/* /var/www/html/$siteName/.

chown -R www-data:www-data /var/www/html

systemctl reload apache2

echo $siteName

# Run install
curl -d "weblog_title=$siteName&user_name=$wpAdmin&admin_password=$wpPass&admin_password2=$wpPass&admin_email=admin@example.org" http://$siteName/wp-admin/install.php?step=2

# Tidy up
rmdir wordpress
rm latest.tar.gz
rm wp-config-sample.php

clear

echo "================================================================="
echo "Installation is complete."
echo "================================================================="
