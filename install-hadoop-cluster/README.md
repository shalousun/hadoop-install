
hadoop集群安装，手动安装的详细过程参考本模块doc中的文档，为了快速搭建一个master、两个slave的小规模完全分布式环境，
目前只需要将规划三台机器修改为master、slave1、slave2，然后根据ip地址修改hosts，修改完后再master主机上执行install.sh
安装脚本就能完成hadoop的安装，完成安装后使用scp将hadoop复制到slave1和slave2主机上即可。如果自己主机名的命名和
本模块中的设置不一致也不想修改原主机名，则安装doc目录下的手动安装文档修改conf和bash中的对应文件后再执行安装脚本。

# 环境要求
1. jdk(参考install-jdk)
2. 设置免密登录(参考install-passless)
3. 安装zookeeper集群

# 修改hosts

例如：
```
echo '
192.168.248.145   master
192.168.248.140   slave1
192.168.248.146   slave2
'>>/etc/hosts

```
# 安装配置
安装前需要修改`install.conf`文件。
```

# hadoop package home
HADOOP_PACKAGE_HOME=/usr/local/packages

# hadoop version
HADOOP_VERSION=3.2.1

# hadoop install dir
HADOOP_INSTALL_DIR=/usr/local

# java home
JAVA_HOME=/usr/local/java/jdk8

# zookeeper address
ZK_ADDRESS=master:2181,slave1:2181,slave2:2181

# hadoop master domain
MASTER_DOMAIN=master

# had tmp file on namenode,in core-site.xml
HADOOP_TMP_DIR=/usr/local/hadoop/custom/tmp

# set in hdfs-site.xml
DFS_NAME_DIR=/usr/local/hadoop/custom/hdfs/name

# set in hdfs-site.xml
DFS_DATA_DIR=/usr/local/hadoop/custom/hdfs/data

# 副本个数，配置默认是3,应小于datanode机器数量
DFS_REPLICATION=2
```