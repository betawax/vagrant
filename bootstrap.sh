#!/bin/sh

# ==============================================================================
# Vagrant
# ==============================================================================

if [ "$1" != "Vagrant" ]; then
  echo "The provisioning script should not be called directly!"
  exit 1
fi

PROJECT_NAME=$2
PHP_VERSION=$3
WEB_SERVER=$4
DOCUMENT_ROOT=$5

# ==============================================================================
# System
# ==============================================================================

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y curl
apt-get install -y git-core
apt-get install -y vim

# Locales

locale-gen de_DE
locale-gen de_DE.UTF-8

# Aliases

echo "alias artisan='php artisan'" >> /home/vagrant/.bash_aliases

# ==============================================================================
# PHP
# ==============================================================================

apt-get install -y python-software-properties

if [ $PHP_VERSION = "5.6" ]; then
  add-apt-repository -y ppa:ondrej/php5-5.6
elif [ $PHP_VERSION = "5.5" ]; then
  add-apt-repository -y ppa:ondrej/php5
elif [ $PHP_VERSION = "5.4" ]; then
  add-apt-repository -y ppa:ondrej/php5-oldstable
fi

apt-get update
apt-get install -y php-apc
apt-get install -y php5-cli
apt-get install -y php5-curl
apt-get install -y php5-gd
apt-get install -y php5-imagick
apt-get install -y php5-mcrypt
apt-get install -y php5-mysqlnd
apt-get install -y php5-sqlite
apt-get install -y php5-tidy
apt-get install -y php5-xdebug
apt-get install -y php5-xsl

sed -i 's/;date.timezone =/date.timezone = UTC/' /etc/php5/cli/php.ini

# ==============================================================================
# Apache
# ==============================================================================

if [ $WEB_SERVER = "apache" ]; then

apt-get install -y apache2
apt-get install -y libapache2-mod-php5

echo "ServerName localhost" > /etc/apache2/httpd.conf

VHOST=$(cat <<EOF
<VirtualHost *:80>
    ServerName $PROJECT_NAME.dev
    DocumentRoot /var/www/$PROJECT_NAME/$DOCUMENT_ROOT
    <Directory "/var/www/$PROJECT_NAME/$DOCUMENT_ROOT">
        AllowOverride All
    </Directory>
</VirtualHost>
EOF
)

rm -f /etc/apache2/sites-available/*
rm -f /etc/apache2/sites-enabled/*
echo "$VHOST" > /etc/apache2/sites-available/default.conf
ln -fs /etc/apache2/sites-available/default.conf /etc/apache2/sites-enabled/default.conf

sed -i 's/;date.timezone =/date.timezone = UTC/' /etc/php5/apache2/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 32M/' /etc/php5/apache2/php.ini

rm -rf /var/www/html
rm -f /var/www/index.html

a2enmod rewrite
a2enmod headers
a2enmod expires

service apache2 restart

fi

# ==============================================================================
# nginx
# ==============================================================================

if [ $WEB_SERVER = "nginx" ]; then

apt-get install -y nginx
apt-get install -y php5-fpm

SERVER=$(cat <<EOF
server {
    
    listen 80;
    server_name $PROJECT_NAME.dev;
    root /var/www/$PROJECT_NAME/$DOCUMENT_ROOT;
    
    index index.html index.php;
    charset utf-8;
    
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    
    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }
    
    error_page 404 /index.php;
    
    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_intercept_errors on;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
    }
    
    location ~ /\.ht {
        deny all;
    }
    
}
EOF
)

echo "$SERVER" > /etc/nginx/sites-available/default

service nginx restart
service php5-fpm restart

fi

# ==============================================================================
# MySQL
# ==============================================================================

apt-get install -y mysql-server-5.5

sed -i 's/bind-address\t\t= 127.0.0.1/bind-address\t\t= 0.0.0.0/' /etc/mysql/my.cnf
service mysql restart

mysql -u root -e "CREATE DATABASE \`$PROJECT_NAME\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci;"

HOST=$(ifconfig eth1 | grep 'inet addr' | awk -F : '{print $2}' | awk '{print $1}' | sed 's/.[0-9]*$/.%/')

mysql -u root -e "GRANT ALL ON \`$PROJECT_NAME\`.* TO '$PROJECT_NAME'@'localhost' IDENTIFIED BY '$PROJECT_NAME';"
mysql -u root -e "GRANT ALL ON \`$PROJECT_NAME\`.* TO '$PROJECT_NAME'@'$HOST' IDENTIFIED BY '$PROJECT_NAME';"
mysql -u root -e "FLUSH PRIVILEGES;"

# ==============================================================================
# SQLite
# ==============================================================================

apt-get install -y sqlite

# ==============================================================================
# Postfix
# ==============================================================================

echo postfix postfix/mailname string $PROJECT_NAME.dev | debconf-set-selections
echo postfix postfix/main_mailer_type string 'Internet Site' | debconf-set-selections

apt-get install -y postfix

# ==============================================================================
# Tools
# ==============================================================================

# Composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Node
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
apt-get install -y nodejs

# Gulp
#npm install --global gulp

# PHPUnit
#curl -O https://phar.phpunit.de/phpunit.phar
#chmod 755 phpunit.phar
#mv phpunit.phar /usr/local/bin/phpunit

# PHP Coding Standards Fixer
#curl -O http://get.sensiolabs.org/php-cs-fixer.phar
#chmod 755 php-cs-fixer.phar
#mv php-cs-fixer.phar /usr/local/bin/php-cs-fixer

# WP-CLI
#curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#chmod 755 wp-cli.phar
#mv wp-cli.phar /usr/local/bin/wp

# Drush
#apt-get install -y drush
