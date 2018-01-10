#!/usr/bin/env bash

# ==============================================================================
# Vagrant
# ==============================================================================

# Sanity Check 👊
if [ "$1" != "Vagrant" ]; then
  echo "The provisioning script should not be called directly!"
  exit 1
fi

# Passed Properties
PROJECT_SLUG=$2
DOCUMENT_ROOT=$3

# ==============================================================================
# System
# ==============================================================================

# Locales
apt-get install -y language-pack-de

# Common Tools
apt-get install -y git

# Aliases
echo "alias artisan=\"php artisan\"" >> /home/vagrant/.bash_aliases

# We are no humans
export DEBIAN_FRONTEND=noninteractive

# ==============================================================================
# PHP
# ==============================================================================

# PHP 7+ PPA Repository
add-apt-repository -y ppa:ondrej/php
apt-get update

# PHP 7.1 common extensions
apt-get install -y php7.1-cli
apt-get install -y php7.1-curl
apt-get install -y php7.1-gd
apt-get install -y php7.1-imagick
apt-get install -y php7.1-json
apt-get install -y php7.1-mbstring
apt-get install -y php7.1-mcrypt
apt-get install -y php7.1-mysql
apt-get install -y php7.1-tidy
apt-get install -y php7.1-xdebug
apt-get install -y php7.1-xml

# Set the default timezone to UTC
sed -i "s/;date.timezone =/date.timezone = UTC/" /etc/php/7.1/cli/php.ini

# ==============================================================================
# Apache
# ==============================================================================

# Default VHost
VHOST=$(cat <<EOF
<VirtualHost *:80>
    ServerName $PROJECT_SLUG.local
    DocumentRoot /var/www/$PROJECT_SLUG/$DOCUMENT_ROOT
    <Directory "/var/www/$PROJECT_SLUG/$DOCUMENT_ROOT">
        AllowOverride All
    </Directory>
</VirtualHost>
EOF
)

# Apache 2 & Mod PHP
apt-get install -y apache2
apt-get install -y libapache2-mod-php7.1

# Common Mods
a2enmod rewrite
a2enmod headers
a2enmod expires

# Clean up
rm -f /etc/apache2/sites-available/*
rm -f /etc/apache2/sites-enabled/*
rm -rf /var/www/html

# Create and enable a default VHost
echo "$VHOST" > /etc/apache2/sites-available/default.conf
ln -fs /etc/apache2/sites-available/default.conf /etc/apache2/sites-enabled/default.conf

# Set the default timezone to UTC and increase upload_max_filesize
sed -i "s/;date.timezone =/date.timezone = UTC/" /etc/php/7.1/apache2/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 32M/" /etc/php/7.1/apache2/php.ini

# Please Apache 🙄
printf "\n\nServerName $PROJECT_SLUG" >> /etc/apache2/apache2.conf

# Restart Apache
service apache2 restart

# ==============================================================================
# MySQL
# ==============================================================================

# MySQL 5.6
apt-get install -y mysql-server-5.6

# Allow remote database connections
sed -i "s/bind-address\t\t= 127.0.0.1/bind-address\t\t= 0.0.0.0/" /etc/mysql/my.cnf
service mysql restart

# Get the host address to grant access to
HOST=$(ifconfig eth1 | grep "inet addr" | awk -F : '{print $2}' | awk '{print $1}' | sed "s/.[0-9]*$/.%/")

# Create a UTF8 database
mysql -u root -e "CREATE DATABASE $PROJECT_SLUG DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci;"

# Create a database user
mysql -u root -e "GRANT ALL ON $PROJECT_SLUG.* TO '$PROJECT_SLUG'@'localhost' IDENTIFIED BY '$PROJECT_SLUG';"
mysql -u root -e "GRANT ALL ON $PROJECT_SLUG.* TO '$PROJECT_SLUG'@'$HOST' IDENTIFIED BY '$PROJECT_SLUG';"
mysql -u root -e "FLUSH PRIVILEGES;"

# ==============================================================================
# Postfix
# ==============================================================================

# Pre-configure Postfix for mail delivery
echo postfix postfix/mailname string $PROJECT_SLUG.local | debconf-set-selections
echo postfix postfix/main_mailer_type string 'Internet Site' | debconf-set-selections

# Postfix
apt-get install -y postfix
