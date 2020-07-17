#!/bin/sh
#Author: Akash Mehta
#Email alert when disk space runs low shell script.

#Shell script to monitor  the disk space
#It will send an email to $ADMIN if the free available percentage of disk space is >=85%

#Set an email for $ADMIN
ADMIN="user@example.com"

#Set alert threshold to 85%
ALERT=85

#Exclude list of unwanted disks/partitions, if several partitions use "|" to separate the partitions.
#Example: EXCLUDE_LIST="/dev/hdd1|/dev/hdd2"
EXCLUDE_LIST="/dev/hdd2"

function main() {
while read output;
do
#echo $output
  usep=$(echo $output | awk '{print $1}' | cut -d'%' -f1)
  partition=$(echo $output | awk '{print $2}')
  if [ $usep -ge $ALERT ] ; then
    echo "Disk space running out for \"$partition ($usep%)\" on server $(hostname), $(date)" | \
    mail -s "Alert: Low disk space $usep%" $ADMIN
  fi
done
}
if [ "$EXCLUDE_LIST" != ""] ; then
  df -H | grep -vE "^Filesystem|tmpfs|cdrom|${EXCLUDE_LIST}" | awk '{print $5 " " $6}' | main
else
  df -H | grep -vE "^Filesystem|tmpfs|cdrom" | awk '{print $5 " " $6}' | main
fi
