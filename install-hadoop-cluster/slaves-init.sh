#!/bin/bash

# =======================load config ===============================
source ./install.conf

node_ip_arr=$(cat slaves.conf)
# ===========================remove old log======================
rm -rf hadoop.log
# ===========================install nodes=======================
for node_ip in $node_ip_arr
do
  echo "[INFO] Copy /etc/profile to node ${node_ip}"
  scp /etc/profile ${node_ip}:/etc/

  echo "[INFO] Copy hadoop to node ${node_ip}"
  scp -r ${HADOOP_INSTALL_DIR}/hadoop ${node_ip}:${HADOOP_INSTALL_DIR}

  echo "[INFO] Init node ${node_ip}"
  ssh root@${node_ip} "systemctl stop firewalld.service"
  ssh root@${node_ip} "systemctl disable firewalld.service"
  echo "[INFO] Init node  ${node_ip}" >> hadoop.log
done