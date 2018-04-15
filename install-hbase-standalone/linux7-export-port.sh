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

        echo "open HBase port"
        sudo firewall-cmd --permanent --add-port=16010/tcp
        sudo firewall-cmd --reload
    fi
fi