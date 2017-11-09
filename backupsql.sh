#!/bin/bash

USER="da_admin"
PASSWORD="`grep passwd= /usr/local/directadmin/conf/mysql.conf | cut -d\= -f2`"
#OUTPUT="/Users/rabino/DBs"

find /root/mysql-backups -name '*.gz' -type f -mtime -1 -exec rm -f {} \;

databases=`mysql -u $USER -p$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump -u $USER -p$PASSWORD --databases $db | gzip > `date +%Y%m%d`.$db.sql.gz
       # gzip $OUTPUT/`date +%Y%m%d`.$db.sql
    fi
done
