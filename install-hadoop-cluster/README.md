
hadoop完全分布式集群安装自动化脚本，手动安装的详细过程参考本模块doc中的文档。自动化安装的步骤如下。

# 安装步骤

## 环境准备
1. hadoop安装的机器安装好jdk(参考install-jdk)
2. 设置免密登录(参考install-passless)
3. 准备一个zookeeper集群

## 修改机器名
修改各台机器的主机名。机器名称可类似规划(hadoop-master,hadoop-node1,hadoop-node2)，
修改命令参考如下：
```
hostnamectl set-hostname master
```
## 修改hosts
如果你需要使用主机名作为hadoop的一些配置，那么需要在各台机器上修改hosts，采用ip地址则可以忽略该配置。
配置参考如下，例如：
```
echo '
192.168.248.145   master
192.168.248.140   slave1
192.168.248.146   slave2
'>>/etc/hosts
```
## 修改安装配置
1. 安装前需要修改`install.conf`文件，配置文件中一些安装集群的配置。
```

# 指定hadoop安装包的目录位置，脚本可以自行检查下载，但是由于网络原因通常安装的包需要自己下载
HADOOP_PACKAGE_HOME=/usr/local/packages

# 指定hadoop的版本，该脚本只支持3.x
HADOOP_VERSION=3.2.1

# 指定安装hadoop的路径
HADOOP_INSTALL_DIR=/usr/local

# 指定jdk的安装路径
JAVA_HOME=/usr/local/java/jdk8

# 指定zookeeper集群，hadoop高可用需要使用
ZK_ADDRESS=master:2181,slave1:2181,slave2:2181

# master的域名，如果没配置hosts，也可以使用ip地址
MASTER_DOMAIN=master

# had tmp file on namenode,in core-site.xml
HADOOP_TMP_DIR=/data/hadoop/custom/tmp

# set in hdfs-site.xml，namenode的数据存储路径
DFS_NAME_DIR=/data/hadoop/custom/hdfs/name

# set in hdfs-site.xml，datanode的数据存储路径
DFS_DATA_DIR=/data/hadoop/custom/hdfs/data

# secondarynamenode http address
# 配置第二个namenode的宿主机域名
SECONDARY_NAME_NODE=slave1

# 副本个数，配置默认是3,应小于datanode机器数量
DFS_REPLICATION=2
```
2. 修改`nodes.conf`,改文件用于存储nodes的ip地址或者是域名，一行配置一个node机器。
```
slave1
slave2
```

# 启动
启动操作在master上

**格式化namenode(默认已经自定执行)**

```
# hdfs namenode -format
```
一般只有初始化的时候才会执行`format`
**启动dfs**

启动NameNode 和 DataNode 守护进程

命令位于$HADOOP_HOME/sbin下

```
#  sbin/start-dfs.sh
```
**启动yarn**

启动ResourceManager 和 NodeManager 守护进程

```
$ sbin/start-yarn.sh
```
**各节点状态查看**

分别到master、slave1、slave2中使用jps查看服务状态，实例：

master机器
```
[root@master hadoop]# jps
3202 Jps
2875 ResourceManager
2428 NameNode
```
slave1机器
```
[root@slave1 ~]# jps
2259 Jps
2166 NodeManager
1981 DataNode
2077 SecondaryNameNode
```
slave2机器
```
[root@slave2 ~]# jps
2181 Jps
2088 NodeManager
1982 DataNode
```

**端口管理**

脚本在默认安装过程中关闭的了防火墙，如果需要开启防火墙，则浏览之前需要开放端口号。在centos7采用如下命令：

```
// //YARN的ResourceManager,在master节点 
# sudo firewall-cmd --permanent --add-port=8088/tcp

# sudo firewall-cmd --permanent --add-port=8042/tcp

//查看主namenode服务
# sudo firewall-cmd --permanent --add-port=50070/tcp

//第二个namenode http port，位于slave1上
# sudo firewall-cmd --permanent --add-port=50090/tcp

# sudo firewall-cmd --reload
```


**浏览访问hdfs和yarn**

hdfs: http://{master ip}:50070

yarn: http://{master ip}:8088

**启动单个进程**

在某一些时候可能只需要启动一个进程


```
[root@master ~]# sbin/hadoop-daemon.sh start namenode
[root@slave1 ~]# sbin/hadoop-daemon.sh start namenode
[root@slave2 ~]# sbin/hadoop-daemon.sh start namenode
```
**停止单个进程**


```
[root@master ~]# sbin/hadoop-daemon.sh stop namenode
[root@slave1 ~]# sbin/hadoop-daemon.sh stop namenode
[root@slave2 ~]# sbin/hadoop-daemon.sh stop namenode
```


# Hadoop集群的停止
1. 停止hdfs集群


```
# sbin/stop-dfs.sh

```
2. 停止yarn集群


```
# sbin/stop-yarn.sh
```
**注意：**
启动和停止单个hdfs相关的进程使用的是`hadoop-daemon.sh`脚本，而启动和停止yarn使用的是`yarn-daemon.sh`脚本。