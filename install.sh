#!/bin/bash
#Filename: install.sh
#Description: Install sysinfo
DB_USER='root';
DB_PASSWD='mysqlpass';

sudo apt-get update
# sudo apt-get -y upgrade 

# sudo apt-get -y install git mc 
# git clone https://github.com/mcdba/sysinfo.git




sudo apt-get -y install apache2 php 
sudo apt-get -y install libapache2-mod-php php-mysql
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password $DB_PASSWD'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $DB_PASSWD'
sudo apt-get -y install mysql-server
sudo apt-get -y install php-mysql

sudo rm /etc/apache2/sites-enabled/*
sudo cp  config/sysinfo /etc/apache2/sites-enabled/sysinfo

sudo rm /etc/apache2/ports.conf
sudo cp config/ports.conf /etc/apache2/ports.conf
sudo cp config/index.php /var/www/html/index.php

sudo service apache2 restart

sudo apt-get -y install nginx
sudo rm /etc/nginx/sites-enabled/*
sudo cp config/sysinfo_nginx /etc/nginx/sites-enabled/sysinfo_nginx

sudo service nginx restart

# create database
mysql --user=$DB_USER --password=$DB_PASSWD  < config/database.sql
# copy sysinfo.php
sudo cp config/sysinfo.php /var/www/html/sysinfo.php


# cron
chmod +x $PWD/config/cron_procedure.sh

crontab -l > $PWD/mycron.sh
#commented now
#echo "0-59 * * * * $PWD/config/cron_procedure.sh" >> $PWD/mycron.sh
crontab $PWD/mycron.sh
