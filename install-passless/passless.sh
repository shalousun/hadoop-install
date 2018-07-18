#!/bin/bash
# execute on master

# ========================install expect==================
yum -y install expect

# ========================install expect==================

SERVERS="docker-server.com k8s-master k8s-slave"
PASSWORD=123456

# ========================generate key====================
cd /root/.ssh/
ssh-keygen -t rsa

chmod 0600 ~/.ssh/authorized_keys

# ========================auto copy ssh===================

auto_ssh_copy_id() {
    expect -c "set timeout -1;
        spawn ssh-copy-id $1;
        expect {
            *(yes/no)* {send -- yes\r;exp_continue;}
            *password:* {send -- $2\r;exp_continue;}
            eof        {exit 0;}
        }";
}

ssh_copy_id_to_all() {
    for SERVER in $SERVERS
    do
        auto_ssh_copy_id $SERVER $PASSWORD
    done
}

ssh_copy_id_to_all

