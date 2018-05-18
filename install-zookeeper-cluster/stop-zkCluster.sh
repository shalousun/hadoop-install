#!/bin/bash
# shell script to stop zookeeper cluster.

SERVERS=(
    master
    slave1
    slave2
)
echo "INFO: Stopping zookeeper cluster"
for server in $SERVERS
do
    echo "INFO: stopping $server "
    ssh $server "zkServer.sh start"
done