#!/bin/bash
#功能说明:
#定时解析log

help() {
  echo "usage: KettleJob [byhand|byday]" && exit 0
}

#必须传参,分辨是定时处理或是手工处理
[ "$1" != "byhand" ] &&  [ "$1" != "byday" ] && help
deal_type=$1

#-------声明变量---------
ymd=`date -d last-day +%y%m%d`   #取得昨天时间,格式:130924
y_m=`date -d last-day +20%y_%m`  #取得昨天年月,格式:2013_09
hms=`date +20%y%m%d_%H%M%S`      #取得昨天年月,格式:20130924_213700

##手工处理,使用时分秒
[ "${deal_type}" = "byhand" ] && ymd=${hms}

logpool="/mnt/work/etl/pool"  #待处理log所放位置
shpath="/mnt/work/etl/sh"     #脚本位置
arcpath="/mnt/work/etl/logs"  #log处理完归档

kettle_log="/mnt/work/etl/logs/dogday_deal_byday.log"                     #kettle处理时产生的log
kettle_job="/mnt/work/etl/jobs/DogDay_Deal_Oracle/DogDay_Deal_Oracle.kjb" #kettle job位置
kettle_sh="/mnt/work/etl/kettle/data-integration/kitchen.sh"              #kitchen.sh执行脚本

scpsh="${shpath}/dog_scp_log.sh"  #scp收集各服务器log
sedsh="${shpath}/dog_sed_log.sh"  #log每行内容追加自身文本名称
arcsh="${shpath}/dog_arc_log.sh"  #处理完毕后,归档log
#-----------------------

#错误处理函数
error() {
    echo "$1 not exist!" && exit 0
}

#-------判断文件&文件夹是否存在------
#不存在,即执行报错函数
[ -d "${logpool}" ] || error ${logpool}
[ -d "${shpath}"  ] || error ${shpath}
[ -e "${kettle_log}"  ] || error ${kettle_log}
[ -e "${kettle_job}"  ] || error ${kettle_job}
[ -e "${kettle_sh}"   ] || error ${kettle_sh}
[ -e "${scpsh}"  ] || error ${scpsh}
[ -e "${sedsh}"  ] || error ${sedsh}
[ -e "${arcsh}"  ] || error ${arcsh}
#------------------------------------

echo "deal-type: ${deal_type}, ymd=${ymd}"

##第一步: scp收集log(手工处理不需要此操作)
#----------------
declare -a mghosts
mghosts[0]="root@112.124.37.111"
mghosts[1]="root@199.101.118.2"
mghosts[2]="webmail@211.72.253.17"
mghosts[3]="root@112.124.56.173"
#mghosts[4]="root@199.101.118.98"

scpfile="/home/webmail/webmail_log/${ymd}/*"

if [ "${deal_type}" = "byday" ];
then
    for mghost in ${mghosts[@]}
    do
	echo "scp ${mghost}:${scpfile} ${logpool}"
	scp ${mghost}:${scpfile} ${logpool}
    done
fi

mghost="root@199.101.118.98"
su - webmail -c "scp ${mghost}:${scpfile} ${logpool}"
#----------------

#第二步: 文本每行内容追加自身文件名称
#pool文件夹下无log,给出提示并退出
#---------------------------------
[ $(ls ${logpool} | wc -l) -eq 0 ] && echo "WARNING: NO LOG IN POOL!" && exit 0

for log_name in $(ls ${logpool})
do
     log_file="${logpool}/${log_name}"
     if [ -s ${log_file} ]; 
     then
         $(sed -i 's/,/./g' ${log_file})             #replace , to . avoid csv format
         $(sed -i "s/$/&,${log_name}/g" ${log_file}) #每行内容追加自身文件名称
     fi
done 
#---------------------------------

#第三步: kettle操作
#-------------------------------------------------
#声明java环境变量
export JAVA_HOME=/usr/lib/jvm/java-7-sun  
export JRE_HOME=${JAVA_HOME}/jre  
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib  
export PATH=${JAVA_HOME}/bin:$PATH

log_ext="${ymd}"     #kettle处理log_ext后缀的文件
true > ${kettle_log} #清空kettle log

##手工处理,统一重命名log文本文件名
if [ "${deal_type}" = "byhand" ];
then
  for logfile in $(ls ${logpool})
  do
      filepath="${logpool}/${logfile}"
      mv ${filepath} "${filepath}.${log_ext}"
  done
  echo "rename log files over"
fi

#kitchen执行kettle job Rowlevel
${kettle_sh} -file=${kettle_job} -level=Basic -log=${kettle_log} -param:DATE_STR=${log_ext}
#-------------------------------------------------

#第四步: log归档
#----------------------------------
archive="${arcpath}/${deal_type}/${ymd}"
[ -d "${archive}" ] || $(mkdir ${archive})
$(mv ${logpool}/* ${archive})
#----------------------------------

#同步log数据至FocusMail
/mnt/work/etl/crond/ruby_oci.sh > /mnt/work/etl/logs/crond_ruby_oci.log 2>&1

chown -R webuser:webuser /mnt/work/etl/logs/byday/
#生成日志报告
export LANG=en_US.UTF-8
/usr/local/rvm/rubies/ruby-1.9.2-p320/bin/ruby /mnt/work/etl/crond/focusmail_log_report.rb
