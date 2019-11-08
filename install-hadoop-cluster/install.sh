#!/bin/bash
# shell script to install hadoop

# =======================load config ===============================
source ./install.conf

# =======================set variables==============================

CUR_PATH=$(cd `dirname $0`;pwd)

HADOOP_VERSION=${HADOOP_VERSION}

HADOOP_NAME=hadoop-${HADOOP_VERSION}

HADOOP_NAME_TAR=$HADOOP_NAME.tar.gz

HADOOP_INSTALL_DIR=${HADOOP_INSTALL_DIR}

HADOOP_HOME=${HADOOP_INSTALL_DIR}/hadoop

JAVA_HOME=${JAVA_HOME}

JAVA_HOME_SED=$(echo ${JAVA_HOME} |sed -e 's/\//\\\//g' )

ZK_ADDR=${ZK_ADDRESS}

PACKAGE_HOME=${HADOOP_PACKAGE_HOME}

# ========================make packages dir=========================
if [ ! -d "$PACKAGE_HOME" ]
then
    echo "INFO: mkdir $PACKAGE_HOME"
    mkdir $PACKAGE_HOME
fi
# ========================download hadoop===========================
cd $PACKAGE_HOME
if [ ! -f "$HADOOP_NAME_TAR" ]
then
  wget https://archive.apache.org/dist/hadoop/common/$HADOOP_NAME/$HADOOP_NAME.tar.gz
fi

# ========================extract hadoop===========================
tar -zxvf $HADOOP_NAME_TAR -C $HADOOP_INSTALL_DIR

cd $HADOOP_INSTALL_DIR
# rename hadoop
mv $HADOOP_NAME hadoop
# delete tar
# rm -rf $HADOOP_NAME_TAR
# ========================create customer data dir==================
echo "INFO: create customer data dir"
mkdir -p $HADOOP_HOME/custom/tmp
mkdir -p $HADOOP_HOME/custom/hdfs
mkdir -p $HADOOP_HOME/custom/hdfs/data
mkdir -p  $HADOOP_HOME/custom/hdfs/name

# ========================set hadoop env============================
if ! grep "set hadoop environment" /etc/profile
then
    echo "# set hadoop environment" >> /etc/profile
    echo "export HADOOP_HOME=$HADOOP_HOME" >> /etc/profile
    echo "export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin" >> /etc/profile
    source /etc/profile
fi

# ========================replace xml config========================
sed "s/{master_domain}/${MASTER_DOMAIN}/g" $CUR_PATH/conf/core-site.xml
sed "s/{HADOOP_TMP_DIR}/${HADOOP_TMP_DIR}/g" $CUR_PATH/conf/core-site.xml
sed "s/{master_domain}/${MASTER_DOMAIN}/g" $CUR_PATH/conf/hdfs-site.xml
sed "s/{DFS_NAME_DIR}/${DFS_NAME_DIR}/g" $CUR_PATH/conf/hdfs-site.xml
sed "s/{DFS_DATA_DIR}/${DFS_DATA_DIR}/g" $CUR_PATH/conf/hdfs-site.xml
sed "s/{DFS_REPLICATION}/${DFS_REPLICATION}/g" $CUR_PATH/conf/hdfs-site.xml
sed "s/{master_domain}/${MASTER_DOMAIN}/g" $CUR_PATH/conf/yarn-site.xml
sed "s/{ZK_ADDRESS}/${ZK_ADDRESS}/g" $CUR_PATH/conf/yarn-site.xml

# ========================replace config============================
echo "INFO: Current work home is $CUR_PATH"
# copy config files
cp $CUR_PATH/conf/* $HADOOP_HOME/etc/hadoop
# copy
cp $CUR_PATH/bash/*.sh $HADOOP_HOME/etc/hadoop

# ========================Set java env==============================
# export java env in hadoop-env.sh and yarn-env.sh
sed -i "s/# export JAVA_HOME=.*/export JAVA_HOME=$JAVA_HOME_SED/g" $HADOOP_HOME/etc/hadoop/hadoop-env.sh
sed -i "s/# export JAVA_HOME=.*/export JAVA_HOME=$JAVA_HOME_SED/g" $HADOOP_HOME/etc/hadoop/yarn-env.sh
# ========================Format Hadoop Namenode====================
echo "INFO: Format Hadoop Namenode"

#hdfs namenode -format

# =========================Finish install===========================
echo "INFO: Finish hadoop standalone install"
echo "INFO: You could start hadoop server in $HADOOP_HOME/sbin"


