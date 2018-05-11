#!/bin/bash
# shell script to install zookeeper

CUR_PATH=$(cd `dirname $0`;pwd)

ZOOKEEPER_VERSION=3.4.6

ZOOKEEPER_NAME=zookeeper-$ZOOKEEPER_VERSION

ZOOKEEPER_TAR=zookeeper-$ZOOKEEPER_VERSION.tar.gz

ZOOKEEPER_HOME=/usr/local/zookeeper

# ==============INSTALL AND INIT==========================
cd /usr/local
# download zookeeper
if [ ! -f "$ZOOKEEPER_TAR" ]
then
  echo "INFO：download zookeeper"
  wget https://archive.apache.org/dist/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz
fi

# extract zookeeper
tar -zxvf $ZOOKEEPER_TAR

#rm -ri $ZOOKEEPER_TAR
# rename zookeeper
mv $ZOOKEEPER_NAME zookeeper

cd zookeeper
# create dir to store data
mkdir data

# ==============REPLACE CONFIG=============================
echo "INFO: Current work home is $CUR_PATH"
cp $CUR_PATH/conf/* $ZOOKEEPER_HOME/conf

# ==============SET ZOOKEEPER ENV==========================
if ! grep "ZOOKEEPER_HOME=/usr/local/zookeeper" /etc/profile
then
    echo "  "
    echo "# set zookeeper environment" >> /etc/profile
    echo "export ZOOKEEPER_HOME=/usr/local/zookeeper/" >> /etc/profile
    echo "export PATH=\$ZOOKEEPER_HOME/bin:\$PATH" >> /etc/profile
    source /etc/profile
fi



# ==============EXPORT PORTS==============================
# echo "INFO: Finish install !!!"
