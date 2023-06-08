export PAGER=

DBSUBNETGRP=`aws rds describe-db-instances \
    --db-instance-identifier rds-pg-labs \
    --region $AWSREGION \
    --query 'DBInstances[*].DBSubnetGroup.DBSubnetGroupName' \
    --output text`

MONITORROLE=`aws rds describe-db-instances \
    --db-instance-identifier rds-pg-labs \
    --region $AWSREGION \
    --query 'DBInstances[*].MonitoringRoleArn' \
    --output text`

VPCSECGROUP=`aws rds describe-db-instances \
    --db-instance-identifier rds-pg-labs \
    --region $AWSREGION \
    --query 'DBInstances[*].VpcSecurityGroups[0].VpcSecurityGroupId' \
    --output text`

AZ=`aws rds describe-db-subnet-groups  --db-subnet-group-name ${DBSUBNETGRP} --query 'DBSubnetGroups[*].Subnets[0].SubnetAvailabilityZone' --output text`


for instance_name in  db-m5d-4xlarge db-m5-4xlarge db-r5d-4xlarge db-r5-4xlarge db-m6g-4xlarge db-m6gd-4xlarge db-r6g-4xlarge db-r6gd-4xlarge  
do
 
   instance_class=`echo ${instance_name} | tr '-' '.'`
   echo ${instance_name}
   echo ${instance_class}

    aws rds create-db-instance \
    --db-instance-identifier ${instance_name} \
    --db-instance-class ${instance_class} \
    --engine postgres \
    --master-username $PGUSER \
    --master-user-password $PGPASSWORD \
    --allocated-storage 2000 \
    --backup-retention-period 1 \
    --engine-version 15.2 \
    --iops 5000 \
    --storage-type io1 \
    --no-storage-encrypted \
    --monitoring-interval 1 \
    --monitoring-role-arn $MONITORROLE \
    --enable-performance-insights \
    --enable-cloudwatch-logs-exports \
    --db-name pglab \
    --db-subnet-group $DBSUBNETGRP \
    --vpc-security-group-ids $VPCSECGROUP \
    --no-deletion-protection \
    --availability-zone ${AZ} \
    --monitoring-interval 1 \
    --monitoring-role-arn $MONITORROLE \
    --enable-performance-insights \
    --performance-insights-retention-period 7

done
