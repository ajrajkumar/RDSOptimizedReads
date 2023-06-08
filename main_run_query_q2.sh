#!/bin/bash

export BMDB=$1
exec >$LOG/main-EBSvsLocal-Queries-q2-"$(date +"%d-%m-%Y-%H%M%S")".log 2>&1
echo "++++++++++++++++++++++++++++++++"
echo "BEGIN TIME"
echo "++++++++++++++++++++++++++++++++"
date
for i in 1 2 4 8 12 16; do
	for PGHOST in $PGHOSTS; do
		echo "Running on with concurrency $i on $PGHOST"
		nohup $BASE/run_sb_query_q2.sh $i $BMDB $PGHOST &
	done
	wait
done
wait
echo "++++++++++++++++++++++++++++++++"
echo "END TIME"
echo "++++++++++++++++++++++++++++++++"
date
