#!/bin/bash 
DB_USER='root';
DB_PASSWD='mysqlpass';
DB_NAME='sysinfo';
# write into log return log id
log_id=$(mysql --user=$DB_USER --password=$DB_PASSWD $DB_NAME -B -N -e "INSERT INTO log () VALUES (); select LAST_INSERT_ID();";);

function write_mysql()
{
	# write section
	mysql --user=$DB_USER --password=$DB_PASSWD $DB_NAME -B -N -e "INSERT INTO section (log_id,name,data) VALUES ($log_id,'$1','$2');";
}


write_mysql "CPU Load Average" "$(uptime | awk '{print substr($10,1,length($10)-1)}')";

write_mysql "Disk Load" "$(iostat -d | awk 'NR > 2 {print $0}')";

write_mysql "Disk Usage" "$(
 df --output=source,pcent,ipcent,target
 	|grep -v -E '% /dev|% /proc|% /sys'
 	|awk '{	p=int(substr($2,1,length($2)-1)); 
 					i=int(substr($3,1,length($3)-1)); 
 					if(i>p) p=i; 
 					if( p>=90) print "<span class=\"crit\">"$0"</span>"; 
 					else if(p>=80) print "<span class=\"warn\">"$0"</span>"; 
 					else print $0;}'
)";
