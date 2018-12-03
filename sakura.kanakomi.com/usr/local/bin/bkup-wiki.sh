#!/bin/bash
set -x 
DATE="$(date +%Y%m%d)"
BKUP_DIR="/data/bkup/pukiwiki"

[ -d "$BKUP_DIR" ] || mkdir -p $BKUP_DIR

cd /data/webdata/htdocs/ || exit 1
tar czvf ${BKUP_DIR}/pukiwiki_${DATE}.tar.gz pukiwiki
scp  ${BKUP_DIR}/pukiwiki_${DATE}.tar.gz  www.kanakomi.com:${BKUP_DIR}
