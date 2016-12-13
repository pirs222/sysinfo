sudo apt-get update
# sudo apt-get -y upgrade 
sudo apt-get -y install apache2 php 
sudo apt-get -y install libapache2-mod-php php-mysql
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password mysqlpass'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password mysqlpass'
sudo apt-get -y install mysql-server
sudo apt-get -y install php-mysql

sudo rm /etc/apache2/sites-enabled/*
sudo ln -s config/sysinfo /etc/apache2/sites-enabled/sysinfo

sudo rm /etc/apache2/ports.conf
sudo copy config/ports.conf /etc/apache2/ports.conf

sudo service apache2 restart
