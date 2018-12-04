#!/bin/bash
## required : sysstat,

#set -x
LANG=c
CMDNAME=$(basename "$0")
CMDOPT=$*

PRINT_USAGE () {
    echo "usage: bash $CMDNAME [-u] [-c] [-m] [-p]
      -l | --list   : System Infomation
      -u | --uptime : Uptime Check
      -c | --cpu    : Cpu Resource Check
      -m | --memory : Memory Resource Check
      -p | --proccess : Proccess Check
      -i | --iops : IOPS Resource Check
      -t | --traffic : Netwowk Resource Check
      -h | --help : "
    exit 1
}

HELP(){
echo "
- cpu
-- mpstat -P ALL
  %usr    :	アプリケーション（ユーザーレベル）
  %nice   :	アプリケーション（ナイス値による優先指定）
  %sys    :	カーネル（システムレベル）
  %iowait :	アイドル状態（ディスクI/Oリクエスト待ち）
  %irq    :	ハードウェア割り込み処理
  %soft   :	ソフトウェア割り込み処理
  %steal  :	他の仮想CPU向けのハイパーバイザ処理
  %quest  :	仮想CPUの処理
  %gnice  :	仮想CPUの処理（ナイス値による優先指定）
  %idle   :	アイドル状態（ディスクI/Oリクエスト待ち以外

-- sar -u

- memory
-- sar -r   :	メモリの使用量を表示します。
  kbmemfree :	物理メモリの空き容量
  kbmemused :	使用中の物理メモリ
  memused   :	物理メモリ使用率
  kbbuffers :	カーネル内のバッファとして使用されている物理メモリの容量
  kbcached  :	カーネル内でキャッシュ（ページキャッシュ）用メモリとして使用されている物理メモリの容量
  kbswpfree :	スワップ領域の空き容量
  kbswpused :	使用中のスワップ領域の容量

-- sar -W   :	SWAPの発生状況を表示します。
  pswpin/s  :	1秒間にスワップインしているページ数
  pswpout/s :	1秒間にスワップアウトしているページ数

- iops
-- iostat -d -k
  tps       :	1秒当たりのI/Oリクエスト数（transfers per second）
  kB_read/s :	1秒当たりの読み出し量（KB単位）
  kB_wrtn/s :	1秒当たりの書き込み量（KB単位）
  kB_read   :	読み出し量の合計（KB単位）
  kB_wrtn   :	書き込み量の合計（KB単位）

-- iostat -d -k -x
  rrqm/s  :	マージされた1秒当たりの読み出し要求
  wrqm/s  :	マージされた1秒当たりの書き込み要求
  r/s     :	1秒当たりに完了できた読み出し要求（マージ後）
  w/s     :	1秒当たりに完了できた書き込み要求（マージ後）
  rkB/s   :	1秒当たりの読み出しセクタ数
  wkB/s   :	1秒当たりの書き込みセクタ数
  avgrq-sz:	1回で要求（ReQuest）された平均セクタサイズ
  avgqu-sz:	I/Oキュー（QUeue）の長さの平均
  await   :	作成された要求が完了するまでの平均時間
  r_await :	作成された読み出し要求が完了するまでの平均時間
  w_await :	作成された書き込み要求が完了するまでの平均時間
  svctm   :	デバイスに発行されたI/O要求の平均サービス時間（廃止予定）
  ％util  :	デバイスの帯域幅使用率

- traffic
-- sar -n DEV 1 3
  rxpck/s  :	1秒間あたりの受信パケット数
  txpck/s  :	1秒間あたりの送信パケット数
  rxbyt/s  :	1秒間あたりの受信バイト数
  txbyt/s  :	1秒間あたりの送信バイト数
  rxcmp/s  :	1秒間あたりの圧縮受信パケット数 (for cslip etc.)
  txcmp/s  :	1秒間あたりの圧縮送信パケット数
  rxmcst/s :	1秒間あたりのマルチキャスト受信パケット数


-- sar -n EDEV
  rxerr/s  :	1秒あたり総受信不良パケット数
  txerr/s  :	パケット送信時に発生した1秒あたりエラー発生数
  coll/s   :	パケット送信時に発生した1秒あたりパケット衝突数
  rxdrop/s :	Linuxバッファ上の領域不足によって発生した、1秒あたりの受信パケットのドロップ数
  txdrop/s :	Linuxバッファ上の領域不足によって発生した、1秒あたりの送信パケットのドロップ数
  txcarr/s :	パケット送信時に発生した1秒あたりのキャリアエラー数
  rxfram/s :	パケット受信時に発生した、1秒あたりフレーム・アラインメント・エラー数
  rxfifo/s :...	1秒あたりの受信パケットのFIFOオーバーラン・エラー数
  txfifo/s :	1秒あたりの送信パケットのFIFOオーバーラン・エラー数
"
}


UPTIME_CHECK () {
  uptime
}


CPU_CHECK () {
  PHYSICAL=$(grep physical.id /proc/cpuinfo | sort -u | wc -l)
  CORE_PER_CPU=$(grep cpu.cores /proc/cpuinfo | sort -u | awk -F: '{print $2}'| tr -d " " )
  PROC_NUM=$(grep processor /proc/cpuinfo | wc -l )

  echo -e "\e[1;31m##### CPU STATUS\e[0m"
  echo -e "----------------------------------- "
  echo -e "Physical_CPU :\t $PHYSICAL "
  echo -e "Core-per-CPU :\t $CORE_PER_CPU"
  echo -e "ProcceserNum :\t $PROC_NUM"
  echo -e "----------------------------------- "
  echo -e

  echo -e "\e[1;31m##### CPU USAGES (mpstat -P ALL)  \e[0m"
  mpstat -P ALL
  echo -e
  echo -e "\e[1;31m##### cat /proc/loadavg\e[0m"
  echo -e "-----------------------------------------------------------------------------------------"
  cat /proc/loadavg
  echo -e
  echo -e "\e[1;31m##### sar -u | tail -20\e[0m"
  echo -e "-----------------------------------------------------------------------------------------"
  sar -u | grep "00:00:"
  sar -u | tail -20
  echo -e
  PROCCESS_CHECK CPU

}

MEMORY_CHECK (){
  echo -e "\e[1;31m##### free -h\e[0m"
  echo -e "-----------------------------------------------------------------------------------------"
  free -h
  echo -e
  echo -e "\e[1;31m#### sar -r |tail -20\e[0m"
  echo -e "-----------------------------------------------------------------------------------------"
  sar -r | grep "00:00:"
  sar -r | tail -20
  echo -e
  echo -e "\e[1;31m#### sar -W |tail -20\e[0m"
  echo -e "-----------------------------------------------------------------------------------------"
  sar -W | grep "00:00:"
  sar -W | tail -20
  echo -e
  PROCCESS_CHECK MEMORY
}

PROCCESS_CHECK () {

  STATUS=$1
  if [ "$STATUS" == "ALL" ] ;then
    PROCCESS_CHECK ZONBIE
    PROCCESS_CHECK CPU
    PROCCESS_CHECK MEMORY
  elif [ "$STATUS" == "CPU" ] ;then
    echo -e "\e[1;31m##### CPU USED TOP 20(ps aux | sort -rk 3 | head -n 20)\e[0m"
    echo -e "-----------------------------------------------------------------------------------------"
    ps aux | sort -n -rk 3 | tail -n 1
    ps aux | sort -n -rk 3 | head -n 20
    echo -e ""
  elif [ "$STATUS" == "MEMORY" ] ;then
    echo -e "\e[1;31m##### MAMORY USED TOP 20(ps aux | sort -rk 4 | head -n 20)\e[0m"
    echo -e "-----------------------------------------------------------------------------------------"
    ps aux | sort -n -rk 4 | tail -n 1
    ps aux | sort -n -rk 4 | head -n 20
    echo -e ""
  elif [ "$STATUS" == "ZONBIE" ] ;then
    echo -e "\e[1;31m##### Zonbi Proccess (ps aux |awk '{if($8 == "Z") print}')\e[0m"
    echo -e "-----------------------------------------------------------------------------------------"
    ps aux |awk '{if($8 == "Z") print}'
    echo -e ""
  fi
}

#echo -e "\e[1;31m##### \e[0m"

IOPS_CHECK(){
  echo -e "\e[1;31m##### fdisk -l \e[0m"
  fdisk -l
  echo -e "\e[1;31m##### iostat -d -k -p \e[0m"
  iostat -d -k
  echo -e "\e[1;31m##### iostat -d -k -x -p \e[0m"
  iostat -d -k -x
  echo -e
  echo -e
}

TRAFFIC_CHECK(){
  echo -e "\e[1;31m##### ip a s \e[0m"
  ip a s
  echo -e "\e[1;31m##### sar -n DEV 1 3\e[0m"
  sar -n DEV 1 3
  echo -e "\e[1;31m##### sar -n EDEV 1 3\e[0m"
  sar -n EDEV 1 3


}

### main

[ "$#" -ge 1 ] || PRINT_USAGE

while getopts :ucmpith OPT
do
	case ${OPT} in
		"u" ) UPTIME_CHECK ;;
		"c" ) CPU_CHECK ;;
		"m" ) MEMORY_CHECK ;;
		"p" ) PROCCESS_CHECK ALL ;;
		"i" ) IOPS_CHECK ;;
		"t" ) TRAFFIC_CHECK ;;
		"h" ) HELP;;
		\? ) PRINT_USAGE ;;
	esac
done


exit 0 
