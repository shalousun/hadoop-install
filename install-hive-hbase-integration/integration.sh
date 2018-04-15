#!/bin/bash
# Used to auto integration hive and HBase

CUR_PATH=$(cd `dirname $0`;pwd)

HIVE_HOME=/usr/local/hive

# ============REPLACE CONFIG==========================
echo "Current work home is $CUR_PATH"
# copy xml config
cp $CUR_PATH/conf/*.xml $HIVE_HOME/conf
# copy
cp $CUR_PATH/bash/*.sh $HIVE_HOME/conf

# =============COPY JARS TO LIB=======================
cp $CUR_PATH/lib/*.jar $HIVE_HOME/lib

echo "Finish Hive and HBase"

