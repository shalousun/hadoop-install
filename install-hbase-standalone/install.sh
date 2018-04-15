#!/bin/bash
# shell script to install hbase

CUR_PATH=$(cd `dirname $0`;pwd)

HBASE_VERSION=1.3.2

HBASE_NAME=hbase-$HBASE_VERSION

HBASE_TAR=hbase-$HBASE_VERSION-bin.tar.gz

HBASE_HOME=/usr/local/hbase

# ==============INSTALL AND INIT==========================
cd /usr/local
# download HBase
if [ ! -f "$HBASE_TAR" ]
then
  echo "download HBase"
  wget http://mirrors.hust.edu.cn/apache/hbase/$HBASE_VERSION/hbase-$HBASE_VERSION-bin.tar.gz
fi

# extract HBase
tar -zxvf $HBASE_TAR

#rm -ri $HBASE_TAR
# rename HBase
mv $HBASE_NAME hbase

cd hbase
# create dir to store data
mkdir hbaseData

# ==============REPLACE CONFIG=============================
echo "Current work home is $CUR_PATH"
cp $CUR_PATH/conf/* $HBASE_HOME/conf
cp $CUR_PATH/bash/* $HBASE_HOME/conf

# ==============SET HBASE ENV==========================
if ! grep "HBASE_HOME=/usr/local/hbase" /etc/profile
then
    echo "  "
    echo "# set HBase environment" >> /etc/profile
    echo "export HBASE_HOME=/usr/local/hbase/" >> /etc/profile
    echo "export PATH=\$HBASE_HOME/bin:\$PATH" >> /etc/profile
    source /etc/profile
fi


# ==============EXPORT PORTS==============================
# echo "Finish install!!!"
