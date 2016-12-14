#!/bin/bash
#Filename: install.sh
#Description: Install sysinfo
DB_USER='root';
DB_PASSWD='mysqlpass';

sudo apt-get update
sudo apt-get -y upgrade 

# sudo apt-get -y install git mc 
# git clone https://github.com/mcdba/sysinfo.git




sudo apt-get -y install apache2 php 
sudo apt-get -y install libapache2-mod-php
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password $DB_PASSWD'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $DB_PASSWD'
sudo apt-get -y install mysql-server
sudo apt-get -y install php-mysql

sudo rm /etc/apache2/sites-enabled/*
sudo ln -s  $PWD/config/sysinfo_apache /etc/apache2/sites-enabled/sysinfo_apache

sudo rm /etc/apache2/ports.conf
sudo cp $PWD/config/ports.conf /etc/apache2/ports.conf
sudo ln -s $PWD/config/index.php /var/www/html/index.php
sudo wget -O /var/www/html/adminer.php https://github.com/vrana/adminer/releases/download/v4.2.5/adminer-4.2.5-en.php 


sudo service apache2 restart

sudo apt-get -y install nginx
sudo rm /etc/nginx/sites-enabled/*
sudo ln -s $PWD/config/sysinfo_nginx /etc/nginx/sites-enabled/sysinfo_nginx

sudo service nginx restart

# create database
mysql --user=$DB_USER --password=$DB_PASSWD  < config/database.sql
# copy sysinfo.php
sudo ln -s $PWD/config/sysinfo.php /var/www/html/sysinfo.php
sudo ln -s $PWD/config/style.css /var/www/html/style.css


# cron
chmod +x $PWD/config/cron_procedure.sh

crontab -l > $PWD/mycron.sh
#commented now !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#echo "0-59 * * * * $PWD/config/cron_procedure.sh" >> $PWD/mycron.sh
crontab $PWD/mycron.sh
