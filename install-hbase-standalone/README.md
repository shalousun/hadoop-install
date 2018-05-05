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
HBase Master|16000
HBase Master web UI | 16010


# HBase的数据表基本操作
1. 创建表添加列族
```
# 新建一个 t_user表，添加两个列族 st1 和 st2
hbase(main):003:0> create 't_user','st1','st2'
```
2. 给表添加数据
```
添加 主键 、列 和值
hbase(main):003:0> put 't_user','1001','st1:age','18'
hbase(main):003:0> put 't_user','1001','st2:name','zhangsan'
```
3. 查询表数据
```
hbase(main):003:0> scan 't_user'
```
4. 查看表结构
```
hbase(main):003:0> describe 't_user'
```
5. 删除记录
```
hbase(main):003:0> delete't_user','1001','st1:age'
```
6. 删除表
```
# 先删除表首先要屏蔽该表
hbase(main):003:0> disable 't_user'
# 删除表
hbase(main):003:0> drop 't_user'
```
7. 扫描前几条
```
scan 't1',{LIMIT=>5}



8. 退出hbase命令
```
quit
```
9. hbase的数据导入导出

导出到本地
```
hbase org.apache.hadoop.hbase.mapreduce.Driver export xyz file:///home/hadoop/

```
导出到hdfs
```
hbase org.apache.hadoop.hbase.mapreduce.Export 'FJTv:DbRecommendResult'  /usr/local/DbRecommendResult
```
从本地如数据到hbase
```
hbase/bin/hbase org.apache.hadoop.hbase.mapreduce.Driver import zzz file:///home/hadoop/xyz/
```
导出指定行数的的数据
```
hbase org.apache.hadoop.hbase.mapreduce.Export -Dhbase.mapreduce.scan.row.start=0 
-Dhbase.mapreduce.scan.row.stop=6 
"mytable" /export/mytable
```

用scan导出数据
```
echo "scan 'shortUrl',{COLUMN=>['su:customerId','su:postId'], LIMIT=>10}" | ./hbase shell > myText
```
10. 统计表行数
```
hbase(main):003:0> count 'FJTv:DbRecommendResult'

```
# HBase的namespace操作

namespace相关请转移到doc目录

# 参考文档
1. http://hbase.apache.org/book.html