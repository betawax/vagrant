#!/bin/sh

apt-get update

apt-get install -y vim

# Apache

apt-get install -y apache2

echo "ServerName localhost" > /etc/apache2/httpd.conf

VHOST=$(cat <<EOF
<VirtualHost *:80>
    ServerName $1.dev
    DocumentRoot /var/www/$1/public
    <Directory "/var/www/$1/public">
        AllowOverride All
    </Directory>
</VirtualHost>
EOF
)

echo "$VHOST" > /etc/apache2/sites-available/default

a2enmod rewrite
service apache2 restart

# PHP

apt-get install -y libapache2-mod-php5

if [ $2 = "5.5" ]; then
	apt-get install -y python-software-properties
	add-apt-repository -y ppa:ondrej/php5
elif [ $2 = "5.4" ]; then
	apt-get install -y python-software-properties
	add-apt-repository -y ppa:ondrej/php5-oldstable
fi

apt-get update
apt-get install -y php5
apt-get install -y php5-mysql
apt-get install -y php5-mcrypt

service apache2 restart

rm -f /var/www/index.html

# MySQL

export DEBIAN_FRONTEND=noninteractive
apt-get install -y mysql-server-5.5

sed -i 's/bind-address\t\t= 127.0.0.1/bind-address\t\t= 0.0.0.0/' /etc/mysql/my.cnf
service mysql restart

mysql -u root -e "CREATE DATABASE $1 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci;"

HOST=$(ifconfig eth1 | grep 'inet addr' | awk -F : '{print $2}' | awk '{print $1}' | sed 's/.[0-9]*$/.%/')

mysql -u root -e "GRANT ALL ON $1.* TO '$1'@'$HOST' IDENTIFIED BY '$1';"
mysql -u root -e "FLUSH PRIVILEGES;"
