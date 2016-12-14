#!/bin/bash -x
DB_USER='root';
DB_PASSWD='mysqlpass';
DB_NAME='sysinfo';
# log
log_id=$(mysql --user=$DB_USER --password=$DB_PASSWD $DB_NAME -B -N -e "INSERT INTO log () VALUES (); select LAST_INSERT_ID();";);

function write_mysql()
{
	# write section
	section_id=$(mysql --user=$DB_USER --password=$DB_PASSWD $DB_NAME -B -N -e "INSERT INTO section (log_id,name) VALUES ($log_id,'$1'); select LAST_INSERT_ID();";);
	# write datarow
	mysql --user=$DB_USER --password=$DB_PASSWD $DB_NAME -B -N -e "INSERT INTO data (section_id,datarow) VALUES ($section_id,'$2');";
}


write_mysql "CPU Load Average" "$(uptime | awk '{print substr($10,1,length($10)-1)}')";
write_mysql "Disk Load" "$(iostat -d | awk 'NR > 2 {print $0}')";
write_mysql "Disk Usage" "$(df -h --output=source,ipcent,pcent,target)";