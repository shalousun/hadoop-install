#!/bin/bash

SERVERS="master slave1 slave2"

sh_copy_profile(){
    scp /etc/profile slave1:/etc/
    scp /etc/profile slave2:/etc/
}

sh_copy_profile

sh_copy_hadoop(){
    scp -r /usr/local/hadoop slave1:/usr/local
    scp -r /usr/local/hadoop slave2:/usr/local
}

sh_copy_hadoop