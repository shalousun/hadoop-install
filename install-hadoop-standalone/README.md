hadoop的单节点安装，本案例脚本安装是基于hadoop 2.7.5，本例安装jdk是使用的install-jdk中脚本自动安装的，
如果自己安装的jdk路径和install-jdk安装的路径不一样，则根据情况更改

# 环境需求
安装前请确保jdk已经安装ok

# 安装后的配置介绍
安装完成后hadoop的安装路径为/usr/local/hadoop

hadoop.tmp.dir的路径为/usr/local/hadoop/custom/tmp

namenode【dfs.name.dir】上存储hdfs名字空间元数据位置usr/local/hadoop/custom/hdfs/name

datanode【fs.data.dir】数据块的物理存储位置/usr/local/hadoop/custom/hdfs/data

hadoop-env.sh中的JAVA_HOME路径/usr/local/java/jdk8
yarn-env.sh中JAVA_HOME的路径/usr/local/java/jdk8

# 启动hadoop的服务
命令位于$HADOOP_HOME/sbin下

启动NameNode 和 DataNode 守护进程
```
sbin/start-dfs.sh
```
启动ResourceManager 和 NodeManager 守护进程
```
sbin/start-yarn.sh
```

# 检验服务状态

```
jps
```
# hadoop系统端口


实例 | 端口
---|---
HDFS	Namenode | 50070
HDFS Datanodes | 50075
HDFS Secondarynamenode | 50090
HDFS Backup/Checkpoint node*|50105
MR Jobracker|50030
MR Tasktrackers|50060