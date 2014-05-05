#!/usr/bin/env bash

# Author: Michael Curry (Kernelcurry)
# Website: http://www.kernelcurry.com
# Github: http://github.com/michaelcurry && http://github.com/kernelcurry
# Twitter: @kernelcurry

# Variables for colored output
COLOR_INFO='\e[1;34m'
COLOR_COMMENT='\e[0;33m'
COLOR_NOTICE='\e[1;37m'
COLOR_NONE='\e[0m' # No Color

# Intro
echo -e "${COLOR_INFO}"
echo "=============================="
echo "=        HHVM && HACK        ="
echo "=      Nginx && Laravel      ="
echo "=============================="
echo "= This script is to be used  ="
echo "= to install HHVM and HACK   ="
echo "= on ubuntu 12.0.4           ="
echo "=============================="
echo -e "${COLOR_NONE}"

# Basic Packages
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= Baic Packages              ="
echo "=============================="
echo -e "${COLOR_NONE}"
sudo apt-get update
sudo apt-get install -y unzip vim git-core curl wget build-essential python-software-properties

# PPA && Repositories
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= PPA && Repositories        ="
echo "=============================="
echo -e "${COLOR_NONE}"
sudo add-apt-repository -y ppa:nginx/stable
sudo add-apt-repository -y ppa:mapnik/boost
wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
echo deb http://dl.hhvm.com/ubuntu precise main | sudo tee /etc/apt/sources.list.d/hhvm.list
sudo apt-get update

# Nginx
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= Installing Nginx           ="
echo "=============================="
echo -e "${COLOR_NONE}"
sudo apt-get install -y nginx

# HHVM
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= Installing HHVM            ="
echo "=============================="
echo -e "${COLOR_NONE}"
sudo apt-get install -y hhvm
sudo /usr/share/hhvm/install_fastcgi.sh
sudo /etc/init.d/hhvm restart
sudo /usr/bin/update-alternatives --install /usr/bin/php php /usr/bin/hhvm 60

# Nginx Config
echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= Nginx Config               ="
echo "=============================="
echo -e "${COLOR_NONE}"
cat << EOF | sudo tee -a /etc/nginx/sites-available/laravel
server {
    listen 80 default_server;

    root /vagrant/public;
    index index.html index.htm index.php index.hh;

    # serve static files directly    
    location ~* \.(jpg|jpeg|gif|css|png|js|ico|html|svg|ttf|woff)$ {
        access_log off;
        expires max;
    }
    
    server_name localhost;

    access_log /var/log/nginx/access.log;
    error_log  /var/log/nginx/error.log error;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt  { log_not_found off; access_log off; }

    error_page 404 /index.php;

    include hhvm.conf;  # The HHVM Magic Here

    # Deny .htaccess file access
    location ~ /\.ht {
        deny all;
    }
}
EOF
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/laravel
sudo service nginx reload

echo -e "${COLOR_COMMENT}"
echo "=============================="
echo "= Installing Composer        ="
echo "=============================="
echo -e "${COLOR_NONE}"
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo -e "${COLOR_INFO}"
echo "=============================="
echo "= Script Complete            ="
echo "=============================="
echo -e "${COLOR_NONE}"
