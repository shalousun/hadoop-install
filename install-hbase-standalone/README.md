HBase自动安装脚本,脚本适用hbase 1.3.x。

# 安装情况说明
本实例安装hbase的一些配置说明：
1. zookeeper是hbase自带的
2. JAVA_HOME的路径/usr/local/java/jdk8，配置在bash/hbase-env.sh中。
3. hbase.rootdir的路径配置的hdfs的地址，因此需要先安装hadoop
# 启动停止

启动
```
start-hbase.sh
```
停止
```
stop-hbase.sh
```
# HBase状态查看
```
hbase shell

hbase(main):001:0> status
```
# HBase建表测试
创建表
```
hbase(main):003:0> create 'test', 'cf'

hbase(main):004:0> list

base(main):005:0> put 'test', 'row1', 'cf:a', 'value1'
0 row(s) in 0.1110 seconds
hbase(main):005:0> put 'test', 'row2', 'cf:b', 'value2'
0 row(s) in 0.1110 seconds
hbase(main):005:0> put 'test', 'row3', 'cf:c', 'value3'
0 row(s) in 0.1110 seconds

hbase(main):010:0> scan 'test'

hbase(main):011:0> get 'test', 'row1'
```
如果hbase.rootdir配置的是本地路径，则到配置的本地路径的default目录下查看test test1，如果是配置的hadoop hdfs地址则查看,例如配置的地址是
hdfs://localhost:9000/hbase，那么在hdfs中查看的地址为http://xxx:50070/explorer.html#/hbase/data/default

# hbase 1.3.x服务端口

服务 | 端口号
---|---
HBase's zookeeper | 2181
HBase Master web UI | 160010
