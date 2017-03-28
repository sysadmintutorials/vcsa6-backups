#!/bin/bash
#Purpose = Backup VMware VCSA vPostgress Database to cifs share
#Created on 28-3-2017
#Author = David Rodriguez

#Create Results File
date &> /backups/backup_results.txt

#Create Backup File
python /backups/backup_lin.py -f /backups/vcsa_backup_VCDB.bak >> backup_results.txt 2>&1

#Rename Files
mv /backups/backup_results.txt /backups/backup_results_$(date +"%d-%m-%y").txt
mv /backups/vcsa_backup_VCDB.bak /backups/vcsa_backup_VCDB_$(date +"%d-%m-%y").bak >> backup_results_$(date +"%d-%m-%y").txt 2>&1

#Mount cifs share
mkdir /mnt/cifs-backups >> backup_results_$(date +"%d-%m-%y").txt 2>&1
mount -t cifs -o username=vcloud8backup,password='p@ssw0rd' //192.168.1.4/vcloud8vcenter-backups /mnt/cifs-backups >> backup_results_$(date +"%d-%m-%y").txt 2>&1

#Copy Files
cp -v /backups/backup_results_$(date +"%d-%m-%y").txt /mnt/cifs-backups >> backup_results_$(date +"%d-%m-%y").txt 2>&1
cp -v /backups/vcsa_backup_VCDB_$(date +"%d-%m-%y").bak /mnt/cifs-backups >> backup_results_$(date +"%d-%m-%y").txt 2>&1

#Unmount Cifs Share
umount /mnt/cifs-backups
rm -rf /mnt/cifs-backups

#Remove Backup Files older than 3 days
find /backups/ -name '*.txt' -mtime +3 -exec rm {} \;
find /backups/ -name '*.bak' -mtime +3 -exec rm {} \;
