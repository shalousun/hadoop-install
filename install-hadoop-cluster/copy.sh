#!/bin/bash

SERVERS="master slave1 slave2"
PASSWORD=123456


sh_copy_id_to_all() {
    for SERVER in $SERVERS
    do
        auto_ssh_copy_id $SERVER $PASSWORD
    done
}

ssh_copy_id_to_all

sh_copy_profile(){
    scp /etc/profile slave1:/etc/
    scp /etc/profile slave2:/etc/
}

sh_copy_profile

sh_copy_hadoop(){
    scp -r /usr/local/hadoop slave1:/usr/local
    scp -r /usr/local/hadoop slave2:/usr/local
}