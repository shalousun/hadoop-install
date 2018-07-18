#!/bin/bash
# execute on master

SERVERS="docker-server.com k8s-master k8s-slave"
PASSWORD=123456

# ssh
cd /root/.ssh/
ssh-keygen -t rsa

chmod 0600 ~/.ssh/authorized_keys

ssh_copy_id_to_all() {
    for SERVER in $SERVERS
    do
        auto_ssh_copy_id $SERVER $PASSWORD
    done
}

ssh_copy_id_to_all

