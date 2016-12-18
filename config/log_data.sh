#!/bin/bash 
DB_USER='root';
DB_PASSWD='mysqlpass';
DB_NAME='sysinfo';
# capture tcpdump
DATE=$(date +%Y-%m-%d:%H:%M:%S);
filename=$PWD/tst$DATE.pcap
cup_s=$(nproc);
sudo tcpdump  -G 60 -W 1 -w $filename

# write into log return log id
log_id=$(mysql --user=$DB_USER --password=$DB_PASSWD $DB_NAME -B -N -e "INSERT INTO log () VALUES (); select LAST_INSERT_ID();";);

function write_mysql()
{
	# write section
	mysql --user=$DB_USER --password=$DB_PASSWD $DB_NAME -B -N -e "INSERT INTO section (log_id,name,data) VALUES ($log_id,'$1','$2');";
}


write_mysql "CPU Load Average" "$(uptime | awk '{print substr($8,1,length($8)-1)" "substr($9,1,length($9)-1)" "$10" cpu(s):"$cup_s}')";
write_mysql "tcpdump Top Talkers" "$(sudo tcpdump -nn -r $filename tcp or udp or arp or icmp | awk '{print $3 "\n" $5}' | cut -sd. -f 1-4 | sort | uniq -c | sort -nr | head -10)";
write_mysql "tcpdump Top Talkers w/o  local ip" "$(sudo tcpdump -nn -r $filename tcp or udp or arp or icmp | awk '{print $3 "\n" $5}' |grep -v -F "$(ip addr | awk '/global/ {print $2}' | cut -d/ -f1)" | cut -sd. -f 1-4 | sort | uniq -c | sort -nr | head -10)";
write_mysql "tcpdump Top Talkers by Packet Size" "$(sudo tcpdump -nn -r $filename| awk '{print int($NF)}'|sort | uniq -c | sort -nr | awk '{ a[++n,1] = $1; a[n,2] = $2; t += $1 } END { for (i = 1; i <= n; i++) printf("%-20s %-15d %d%% \n", a[i,1], a[i,2], 100 * a[i,1] / t)}'| head -10 |awk ' BEGIN{printf("%12s %12s %6s \n","packets","packet size","%")}{printf("%12d %12d %6s \n",$1,$2,$3)}')"
write_mysql "tcpdump by proto,size" "$(sudo tcpdump -nn -r $filename | awk '{print $2 "\t" int($NF)}'|gawk '{a[$1]+=$2; s+=$2} END {PROCINFO["sorted_in"] = "@val_num_desc";for(proto in a) printf( "%15s %15d %d%% \n",proto,a[proto],100*a[proto]/s) }')"
# delete old tcpdump files
rm -f $filename

write_mysql "Disk Usage" "$(df --output=source,pcent,ipcent,target|grep -v -E '% /dev|% /proc|% /sys'|awk '{	p=int(substr($2,1,length($2)-1));	i=int(substr($3,1,length($3)-1)); if(i>p) p=i; if( p>=90) print "<span class=\"crit\">"$0"</span>"; else if(p>=80) print "<span class=\"warn\">"$0"</span>"; else print $0;}')";
write_mysql "Disk Load" "$(iostat -x |awk 'NR > 6 {print $0}' |sed -e '$d'| awk 'BEGIN {printf("%10s %10s %10s %10s %10s %10s\n","device","r/s","w/s","rkB/s","wkB/s","%util")}{printf("%10s %10s %10s %10s %10s %10s \n",$1,$4,$5,$6,$7,$14)}')";
write_mysql "Network Load" "$(cat /proc/net/dev |awk ' NR > 2 {print $0}'| awk ' BEGIN {printf("%15s %15s %15s %15s %15s \n","inteface","bytes_recived","packet_recived","bytes_transmit","packet_transmit")} {printf("%15s %15d %15d %15d %15d \n",$1,$2,$3,$10,$11)}')";

