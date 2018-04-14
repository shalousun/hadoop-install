#!/bin/bash
# shell script to install hadoop

CUR_PATH=$(cd `dirname $0`;pwd)

HADOOP_NAME=hadoop-2.7.5

HADOOP_NAME_TAR=$HADOOP_NAME.tar.gz

HADOOP_HOME=/usr/local/hadoop

# passwordless ssh
ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

cd /usr/local
# download hadoop
if [ ! -f "$HADOOP_NAME_TAR" ]
then
  wget http://mirrors.hust.edu.cn/apache/hadoop/common/$HADOOP_NAME/$HADOOP_NAME.tar.gz
fi

#extract hadoop
tar -zxvf $HADOOP_NAME_TAR

#rm -rf $HADOOP_NAME
# rename hadoop
mv $HADOOP_NAME hadoop

# create customer data dir
echo "create customer data dir"
mkdir -p $HADOOP_HOME/custom/tmp
mkdir -p $HADOOP_HOME/custom/hdfs
mkdir -p $HADOOP_HOME/custom/hdfs/data
mkdir -p  $HADOOP_HOME/custom/hdfs/name

# set hadoop env
echo "# set hadoop environment" >> /etc/profile
echo "export HADOOP_HOME=/usr/local/hadoop" >> /etc/profile
echo "export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin" >> /etc/profile

source /etc/profile

echo "Current work home is $CUR_PATH"
# copy xml config
cp $CUR_PATH/conf/*.xml $HADOOP_HOME/etc/hadoop
# copy
cp $CUR_PATH/bash/*.sh $HADOOP_HOME/etc/hadoop

echo "Format Hadoop Namenode"

hdfs namenode -format

echo "Finish hadoop standalone install"

echo "You could start hadoop server in $HADOOP_HOME/sbin"


