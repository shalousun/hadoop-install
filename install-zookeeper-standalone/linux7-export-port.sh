#!/bin/bash
# export zookeeper 2181 port on linux release 7+
user root

ZOOKEEPER_PORT=2181
# ==============EXPORT PORTS==============================
if grep "Linux release 7" /etc/redhat-release
then
    echo "Linux release 7"
    STS=`sudo firewall-cmd --state`
    # while firewall is running
    if [ "running" = "$STS" ]
    then
        if [ "no" == `sudo firewall-cmd --query-port=$ZOOKEEPER_PORT/tcp` ]
        then
            echo "open $ZOOKEEPER_PORT port"
            sudo firewall-cmd --permanent --add-port=$ZOOKEEPER_PORT/tcp
            sudo firewall-cmd --reload
        fi
    fi
fi