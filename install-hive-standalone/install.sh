#!/bin/bash
# shell script to install hive

CUR_PATH=$(cd `dirname $0`;pwd)

HIVE_VERSION=2.3.3

HIVE_NAME=apache-hive-$HIVE_VERSION-bin

HIVE_NAME_TAR=apache-hive-$HIVE_VERSION-bin.tar.gz

HIVE_HOME=/usr/local/hive

HADOOP_HOME=/usr/local/hadoop

MYSQL_DRIVER_VERSION=5.1.45
MYSQL_DRIVER=mysql-connector-java-$MYSQL_DRIVER_VERSION.jar

cd /usr/local
# ================================download hive======================================
if [ ! -f "$HIVE_NAME_TAR" ]
then
  echo "download hive"
  wget http://apache.mirror.globo.tech/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
fi

# ===============================install hive========================================
#extract hive
tar -zxvf $HIVE_NAME_TAR

#rm -rf $HIVE_NAME_TAR
# rename hive
mv $HIVE_NAME hive

# ===============================download mysql driver===============================
if [ ! -f "$MYSQL_DRIVER" ]
then
   echo "download mysql driver"
   wget http://central.maven.org/maven2/mysql/mysql-connector-java/$MYSQL_DRIVER_VERSION/$MYSQL_DRIVER
fi

# copy mysql driver to hive lib
cp $MYSQL_DRIVER $HIVE_HOME/lib

# ===============================set hive env======================================
if ! grep "HIVE_HOME=/usr/local/hive" /etc/profile
then
    echo "# set hive environment" >> /etc/profile
    echo "export HIVE_HOME=/usr/local/hive" >> /etc/profile
    echo "export PATH=\$PATH:\$HIVE_HOME/bin" >> /etc/profile
fi

source /etc/profile

# ===============================replace config====================================
echo "Current work home is $CUR_PATH"
# copy xml config
cp $CUR_PATH/conf/*.xml $HIVE_HOME/conf
# copy
cp $CUR_PATH/bash/*.sh $HIVE_HOME/conf

# ================================making directory for Hive metastore==============
echo "making directory for Hive metastore"
$HADOOP_HOME/bin/hadoop fs -mkdir -p /user/hive/warehouse
$HADOOP_HOME/bin/hadoop fs -mkdir -p /tmp/hive/
hadoop fs -chmod 777 /user/hive/warehouse
hadoop fs -chmod 777 /tmp/hive

# ===============================initializing metastore=============================
echo "initializing metastore"
./$HIVE_HOME/bin/schematool -dbType mysql -initSchema