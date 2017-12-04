#!/bin/bash
## Filename : YYYYMM.csv
## Ex) /root/kakeibo.sh YYYYMM.csv

SERVER="127.0.0.1"
PORT="2003"

#set -x 

FILE=$1
[ -d ./orig/ ] || mkdie ./.orig
mv ${FILE} ./orig/${FILE}.orig
cat ${FILE}.orig | nkf  > ${FILE}
FILE_DATE=$(echo ${FILE}| awk -F. '{print $1}' )
DATE=$(echo $FILE_DATE | awk '{print substr($1,1,4)"-"substr($1,5,2)"-01"}')
DATE_S=$(date  --date "$DATE" "+%s")
#echo $DATE
#echo $DATE_S

CLASS=($(cat $FILE  | grep "支出" | awk -F, '{print $3}'| sort |uniq | grep -v -E "Rollover|分類" | tr "\n" " "))

for class in  `echo ${CLASS[*]}` ;do
	#cat ${FILE} | grep "支出" | grep "$class" |awk -F, -v date="$DATE_S" '{m+=$6} END{print  "a."$3 " "m  " " date ; }'
	#cat ${FILE} | grep "支出" | grep "$class" |awk -F, -v date="$DATE_S" '{m+=$6} END{print  "a."$3 " "m  " " date ; }' | nc -q0 ${SERVER} ${PORT}
:
done

CLASS_B=($(cat $FILE  | grep "収入" | awk -F, '{print $3}'| sort |uniq | grep -v -E "Rollover|分類" | tr "\n" " "))

for class in  `echo ${CLASS_B[*]}` ;do
	#cat ${FILE} | grep "収入" | grep "$class" |awk -F, -v date="$DATE_S" '{m+=$6} END{print  "b."$3 " "m  " " date ; }'
	#cat ${FILE} | grep "収入" | grep "$class" |awk -F, -v date="$DATE_S" '{m+=$6} END{print  "b."$3 " "m  " " date ; }' | nc -q0 ${SERVER} ${PORT}
:
done

#all
#cat ${FILE} | grep "支出" | grep -v -E "Rollover|分類" | awk -F, -v date="$DATE_S" '{m+=$6} END{print  "c."$7 " "m  " " date ; }'
cat ${FILE} | grep "支出" | grep -v -E "Rollover|分類" | awk -F, -v date="$DATE_S" '{m+=$6} END{print  "c."$7 " "m  " " date ; }' | nc -q0 ${SERVER} ${PORT}
#cat ${FILE} | grep "収入" | grep -v -E "Rollover|分類" | awk -F, -v date="$DATE_S" '{m+=$6} END{print  "c."$7 " "m  " " date ; }'
cat ${FILE} | grep "収入" | grep -v -E "Rollover|分類" | awk -F, -v date="$DATE_S" '{m+=$6} END{print  "c."$7 " "m  " " date ; }' | nc -q0 ${SERVER} ${PORT}
