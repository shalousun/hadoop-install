hadoop分布式完全分布式安装(hadoop 3.0+)

# 1.集群规划

192.168.248.128 master  hadoop	namenode ressourcemanager

192.168.248.130 slave1  hadoop	datanode secondnamenode

192.168.248.133 slave2  hadoop	datanade

# 环境配置

**修改各个主机的hosts**

已master为例：


```
[root@master ~]# vim /etc/hosts
```
添加相关主机的配置


```
192.168.188.111 master

192.168.188.112 slave1

192.168.188.113 slave2
```
**配置环境变量**

```
# vi /etc/profile


```

```
#JAVA env variables
export JAVA_HOME=/usr/local/java/jdk8
export JRE_HOME=/usr/local/java/jdk8/jre/
export CLASSPATH=.:$CLASSPATH:$JAVA_HOME/lib:$JRE_HOME/lib
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin

#set env variables
export HADOOP_HOME=/usr/local/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

```


**修改hostname**

修改各主机的主机名


```
[root@master ~]# vim /etc/hostname
//或者
[root@master ~]# hostnamectl set-hostname master
```
同样地，在slave1和slave2做相同的hostname操作，分别命名为slave1和slave2.然后分别把slave1和slave2的hosts文件更改为和master一样。

# 配免密登录
这里直接用root用户，注意将防火墙关掉

#关闭防火墙

```
sudo systemctl stop firewalld.service
```
#关闭开机启动

```
sudo systemctl disable firewalld.service
```

在master中生成秘钥，生成之前将.ssh下旧的删除


```
cd /root/.ssh/
ssh-keygen -t rsa
```
将公钥拷贝到其它机器上，实现免密码登录


```
ssh-copy-id master
ssh-copy-id slave1
ssh-copy-id slave2

//修改权限
chmod 0600 ~/.ssh/authorized_keys

```
完成这一步先使用ssh master看能否直接登录
# hadoop的安装配置

本次安装路径是/usr/local/hadoop

**master配置**

```
# cd /usr/local
# tar -zxvf hadoop-2.7.3
```
1. hadoop-env.sh配置

```
# cd /usr/local/hadoop/etc/hadoop
# vi hadoop-env.sh
```
修改JAVA_HOME值


```
# The java implementation to use.
export JAVA_HOME=/usr/local/java/jdk8
```
2. yarn-env.sh配置


```
# cd /usr/local/hadoop/etc/hadoop
# vi yarn-env.sh
```

```
# some Java parameters
export JAVA_HOME=/usr/local/java/jdk8
```

3. 修改slaves

```
# cd /usr/local/hadoop/etc/hadoop
# vi slaves
```
将内容修改为


```
slave1
slave2
```
4. 配置core-site.xml 
```
# vi core-site.xml
#Add the following inside the configuration tag
<property>
    <name>fs.default.name</name>
    <value>hdfs://master:9000/</value>
</property>
<property>
    <name>hadoop.tmp.dir</name>
    <!-- 指定hadoop运行时产生文件的存储路径 -->
    <value>/usr/local/hadoop/tmp</value>
    <description>had tmp file on namenode</description>
</property>
```
5. hdfs-site.xml


```
# vi hdfs-site.xml
#Add the following inside the configuration tag
<configuration>

    <!-- 设置namenode的http通讯地址 -->
    <property>
        <name>dfs.namenode.http-address</name>
        <value>master:50070</value>
    </property>

    <!-- 设置secondarynamenode的http通讯地址 -->
    <property>
        <name>dfs.namenode.secondary.http-address</name>
        <value>slave1:50090</value>
    </property>

    <!-- 设置namenode存放的路径 -->
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/usr/local/hadoop/name</value>
    </property>

    <!-- 设置hdfs副本数量 -->
    <property>
        <name>dfs.replication</name>
        <value>2</value>
    </property>
    <!-- 设置datanode存放的路径 -->
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/usr/local/hadoop/data</value>
    </property>
</configuration>
```
6. mapred-site.xml配置

```
# mv mapred-site.xml.template mapred-site.xml
# vi mapred-site.xml

#Add the following inside the configuration tag

<configuration>
    <!-- 通知框架MR使用YARN -->
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
```
7. yarn-site.xml配置


```
# vi yarn-site.xml
#Add the following inside the configuration tag

<configuration>
    <!-- 设置 resourcemanager 在哪个节点-->
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>master</value>
    </property>

    <!-- reducer取数据的方式是mapreduce_shuffle -->
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>

    <property>
         <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
         <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    </property>
</configuration>
```
8. 新建masters

新建一个masters的文件,这里指定的是secondary namenode 的主机

```
# vi masters

#Add the following content
slave1
```

9. 创建目录


```
# cd /usr/local/hadoop
# mkdir tmp name data
```
10. 配置workers文件
   
在workers文件中增加从节点地址（若配置了hosts，可直接使用主机名，亦可用IP地址）

```
slave1
slave2
```
11. 配置启动脚本，添加HDFS和Yarn权限
    
添加HDFS权限：编辑如下脚本，在第二行空白位置添加HDFS权限。编辑sbin/start-dfs.sh,sbin/stop-dfs.sh。
```
HDFS_DATANODE_USER=root
HDFS_DATANODE_SECURE_USER=hdfs
HDFS_NAMENODE_USER=root
HDFS_SECONDARYNAMENODE_USER=root
```

添加Yarn权限：编辑如下脚本，在第二行空白位置添加Yarn权限，编辑sbin/start-yarn.sh，sbin/stop-yarn.sh 
```
YARN_RESOURCEMANAGER_USER=root
HDFS_DATANODE_SECURE_USER=yarn
YARN_NODEMANAGER_USER=root
```
12. 复制到其他主机

复制/etc/hosts(因为少了这个导致secondarynamenode总是在slave1启动不起来)


```
scp /etc/hosts slave1:/etc/
scp /etc/hosts slave2:/etc/
```
复制/etc/profile (记得要刷新环境变量)

```
scp /etc/profile slave1:/etc/
scp /etc/profile slave2:/etc/
```
复制master下的hadoop到其他主机(slave1和slave2)


```
scp -r /usr/local/hadoop slave1:/usr/local
scp -r /usr/local/hadoop slave2:/usr/local
```
# 启动
启动操作在master上

**格式化namenode**

```
# hdfs namenode -format
```
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

分别到master、slave1、slave2中使用jps查看服务状态

**端口管理**

浏览之前需要开放端口号。在centos7采用如下命令：

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


**浏览访问hdfs**

http://192.168.248.128:50070

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
启动和停止单个hdfs相关的进程使用的是"hadoop-daemon.sh"脚本，而启动和停止yarn使用的是"yarn-daemon.sh"脚本。