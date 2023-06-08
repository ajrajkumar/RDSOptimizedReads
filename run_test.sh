export BASE=/home/ec2-user/environment/RDSOptimizedReads
export PGPORT=5432
export PGDATABASE=postgres
export CONN=".cysflcdb2ije.us-east-1.rds.amazonaws.com"

for instance_name in  db-m5d-4xlarge#db-m5-4xlarge db-r5d-4xlarge#db-r5-4xlarge db-m6g-4xlarge#db-m6gd-4xlarge db-r6g-4xlarge#db-r6gd-4xlarge
do
    HOST1=`echo $instance_name | awk -F'#' '{print $1}'`
    HOST2=`echo $instance_name | awk -F'#' '{print $2}'`
    export PGHOSTS="${HOST1}${CONN} ${HOST2}${CONN}"
    #export PGHOSTS="db-m5-4xlarge.cysflcdb2ije.us-east-1.rds.amazonaws.com db-m5d-4xlarge.cysflcdb2ije.us-east-1.rds.amazonaws.com"
    echo ${PGHOSTS}
    export LOG=${BASE}/logs-${instance_name}
    mkdir -p ${LOG}

    ./LoadData.sh 16 100000000 sbtest
    ./main.sh sbtest
    wait
done
