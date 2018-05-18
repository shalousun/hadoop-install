#!/bin/bash
# shell script to start zookeeper cluster.

SERVERS=(
    master
    slave1
    slave2
)

echo “Starting zk cluster ......”
for server in ${SERVERS[@]}
do
    echo "INFO: starting ${server}"
    ssh root@${server} "$ZOOKEEPER_HOME/bin/zkServer.sh start"
    ssh root@${server} "$ZOOKEEPER_HOME/bin/zkServer.sh status"
done