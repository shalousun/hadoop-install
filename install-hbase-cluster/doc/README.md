HBase完全分布式安装

# 概述
对于HBase的完全分布式，安装后的服务包括HBase Master、RegionServers、ZooKeeper QuorumPeers、backup HMaster.

backup-masters一般不配置到master节点上。

# 部署规划



# 配置hbase-site.xml

```
<configuration>
  <property>
    <name>hbase.rootdir</name>
    <value>hdfs://namenode.example.org:8020/hbase</value>
  </property>
  <property>
    <name>hbase.cluster.distributed</name>
    <value>true</value>
  </property>
  <property>
    <name>hbase.zookeeper.quorum</name>
    <value>node-a.example.com,node-b.example.com,node-c.example.com</value>
  </property>
</configuration>

```
