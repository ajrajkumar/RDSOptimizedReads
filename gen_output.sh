#!/usr/bin/sh

dir=$1

cd $dir

for i in 1 2 4 8 12 16 
do
	type1=""
	val1=""
	for line in `ls -1 ${i}-*queries*.log`
	do
       instance_type=`echo ${line} | awk -F'-' '{printf("%s.%s.%s",$2,$3,$4)}' `
		 BEGIN=`cat ${line} | grep BEGIN | awk -F'BEGIN:' '{print $2}' | awk -F'.' '{print $1}'`
		 END=`cat ${line} | grep END | awk -F'END:' '{print $2}' | awk -F'.' '{print $1}'`
		 TOTAL=`expr ${END} - ${BEGIN}`
		 TOTAL=`expr ${TOTAL} / 60`
		 type1="${type1}      ${instance_type}"
		 val1="${val1}               ${TOTAL}"
		 #echo ${type1}
		 #echo ${val1}
       #echo ${i} ${instance_type} ${TOTAL}
	done
	#echo ${instance_type}
	if [ ${i} -eq 1 ]; then
      echo "   ${type1}"
	fi
	echo "${i}   ${val1}"
done


