#!/bin/bash
## crontab -l
##    00 01 * * 1 bash /usr/local/bin/kusanagi-bkup.sh > /var/log/bkup.log 2>&1
### cronで定時実行し、そのログを/var/log/bkup.logに出す
### ログも含めてbackupは別途 lsyncでコピーする


echo -e "--------------------------------------------------------"
echo -e " TIMESTAMP  : $(date) "
echo -e "--------------------------------------------------------"

set -x 


## initial setting
DB_NAME="kusanagi"
DB_USER="root"
DB_PASS="パスワード"



DB_BKUP="${DB_NAME}_$(date +%Y%m%d).sql"

KUSANAGIROOT="/home/kusanagi/"
KUSANAGI_BKUP="kusanagi_$(date +%Y%m%d).tar.gz"

#DOCUMENTROOT="/home/kusanagi/kusanagi/DocumentRoot"
#CONTENT_BKUP="wp-content_$(date +%Y%m%d).tar.gz"

## mkdir 
#TMP_DIR=$(mktemp)
BKUP_DIR="/home/bkup/$(date +%Y%m%d)"
[ -d $BKUP_DIR ] || mkdir $BKUP_DIR

## bkup kusanagi
cd $KUSANAGIROOT
tar czf $KUSANAGI_BKUP kusanagi/
mv $KUSANAGI_BKUP ${BKUP_DIR}

## bkup contents
#cd $DOCUMENTROOT
#tar czf $CONTENT_BKUP wp-content/
#mv $CONTENT_BKUP ${BKUP_DIR}
#cp -p ../wp-config.php  ${BKUP_DIR}


## bkup db
cd ${BKUP_DIR}
mysqldump -u${DB_USER} -p${DB_PASS} $DB_NAME --single-transaction --quick > $DB_BKUP


cp -p /var/log/bkup.log $BKUP_DIR

