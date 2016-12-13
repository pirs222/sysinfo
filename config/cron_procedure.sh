#!/bin/bash -x
DB_USER='root';
DB_PASSWD='mysqlpass';

DB_NAME='sysinfo';
TABLE='log';


#Collect Data
day=$(date +"%m/%d/%y")
time=$(date +"%H:%M:%S")

# mysql

mysql --user=$DB_USER --password=$DB_PASSWD $DB_NAME << EOF
INSERT INTO $TABLE (id, day, time, rank) VALUES (NULL, "$day", "$time", "$rank");
EOF

id=$(mysql -u$DB_USER -pDB_PASSWD $DB_NAME -B -N -e "select LAST_INSERT_ID();";)