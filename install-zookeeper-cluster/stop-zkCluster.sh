#!/bin/bash
# shell script to stop zookeeper cluster.

SERVERS=(
    master
    slave1
    slave2
)
echo "INFO: Stopping zookeeper cluster"
for server in ${SERVERS[@]}
do
    echo "INFO: stopping $server "
    ssh root@$server "$ZOOKEEPER_HOME/bin/zkServer.sh stop"
done