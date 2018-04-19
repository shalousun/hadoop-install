在hadoop的生态中，主要是使用zookeeper来做集群的，包括hbase也需要使用zookeeper,对于生产环境zookeeper是
需要集群，但是为了快速的实现基础环境，本例采用Standalone的方式安装。ps:本例只来redhad系列的CentOS中测试过。



# 集群安装


zookeeper完全分布式安装。

## 集群网络拓扑
192.168.248.128 zookeeper node1

192.168.248.130 zookeeper node2

192.168.248.133 zookeeper node2

## 安装
分别在两台主机上安装zookeeper，操作步骤参考上面。

## 配置zoo.cfg

脚本在自动安装zookeeper的时候已经将在zoo.cfg加了server配置，因此可以节点的情况设置


```
$ vi conf/zoo.cfg
```
在zoo.cfg中加入下面的内容

```
server.1=master:2888:3888
server.2=slave1:2888:3888
server.3=slave2:2888:3888
```
## 创建myid

脚本在自动安装集群环境是已经创建了myid，并且每个节点上的myid中的值都是1，因此安装完成后需要手动调整myid 中的值
对于zookeeper的集群安装，必须在各个节点的data目录在创建一个myid的文件，然后在myid文件中添加zoo.cfg中设置的各服务器的id

例如：
```
//修改echo中的值即可
[root@master data]# echo 2 >/usr/local/zookeeper/data/myid
```

## 启动服务
在各个节点上启动zookeeper的服务，注意在启动前需要查看防火墙情况，如果防火墙未关闭，需要将2181、2888、3888端口开放


```
# zkServer.sh start
```
查看状态


```
# zkServer.sh status
//输出如下内容
JMX enabled by default
Using config: /usr/local/services/zookeeper/zookeeper-3.3.6/bin/../conf/zoo.cfg
Mode: leader

```
一般会显示：leader或者flower