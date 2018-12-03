#!/bin/bash
# 
set -x 


## mysqlの初期設定
DB_NAME="kusanagi"
DB_USER="root"
DB_PASS="パスワード"


TAR_CHECK=$(ls kusanagi_*.tar.gz)
SQL_CHECK=$(ls kusanagi_*.sql)

if ! $( echo $TAR_CHECK | grep -q kusanagi )  ;then
   set +x
   echo "Plese Runnnig to bkup-dir on kusanagi_*.tar.gz "
   echo "ex) cd /home/bkup/$(date +%Y%m%d)"
   exit 1
fi

if ! $( echo $SQL_CHECK | grep -q kusanagi )  ;then
   set +x
   echo "Plese Runnnig to bkup-dir on kusanagi_*.sql "
   echo "ex) cd /home/bkup/$(date +%Y%m%d)"
   exit 1
fi

## kusanagi　の初期設置

## wordpressの置き換え
tar zxvf $TAR_CHECK
mv -f kusanagi/DocumentRoot/wp-content /home/kusanagi/kusanagi/DocumentRoot


## DB drop
mysql -u$DB_USER -p$DB_PASS -e "drop database kusanagi;"
mysql -u$DB_USER -p$DB_PASS -e "create database kusanagi;"

## DB restore
mysql -u$DB_USER -p $DB_PASS < $SQL_CHECK 

