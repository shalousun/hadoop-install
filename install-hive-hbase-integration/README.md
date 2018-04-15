hadoop 2.7.5、hive2.3.3和hbase1.3.2整合，整合的目的是为了可以使用hive的hiveSql来查询HBase中的数据。
同时也是为了方便使用像DBeaver这样的客户端工具直接通过hive查看hbase的数据。
关于hadoop 、hive和hbase整合过程中可能实存在版本冲突的，关于HBase 2.x的版本没有测试过。

# Hive和HBase整合
本例中已经将整个整合的过程做了配置和自动化脚本，只需运行integration.sh即可完成整合。
# 整合检验
整合完成后检验Hive和HBase是否连通
## 通过Hive查询HBase
1. 通过HBase创建表
```
hbase(main):001:0> create 'hivehbase', 'ratings'
```
2. 向表中添加数据
```
hbase(main):001:0> put 'hivehbase', 'row1', 'ratings:userid', 'user1'
hbase(main):001:0> put 'hivehbase', 'row1', 'ratings:bookid', 'book1'
hbase(main):001:0> put 'hivehbase', 'row1', 'ratings:rating', '1'

hbase(main):001:0> put 'hivehbase', 'row2', 'ratings:userid', 'user2'
hbase(main):001:0> put 'hivehbase', 'row2', 'ratings:bookid', 'book1'
hbase(main):001:0> put 'hivehbase', 'row2', 'ratings:rating', '3'

hbase(main):001:0> put 'hivehbase', 'row3', 'ratings:userid', 'user2'
hbase(main):001:0> put 'hivehbase', 'row3', 'ratings:bookid', 'book2'
hbase(main):001:0> put 'hivehbase', 'row3', 'ratings:rating', '3'

hbase(main):001:0> put 'hivehbase', 'row4', 'ratings:userid', 'user2'
hbase(main):001:0> put 'hivehbase', 'row4', 'ratings:bookid', 'book4'
hbase(main):001:0> put 'hivehbase', 'row4', 'ratings:rating', '1'
```
3. Hive和HBase表映射
创建一个hive表映射到一个已经存在HBase表，这种情况需要使用EXTERNAL来创建一个外部表
```
CREATE EXTERNAL TABLE hbasehive_table
(key string, userid string,bookid string,rating int)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES
("hbase.columns.mapping" = ":key,ratings:userid,ratings:bookid,ratings:rating")
TBLPROPERTIES ("hbase.table.name" = "hivehbase");
```
创建一个新的hive表直接映射到HBase表，这种就是HBase没有该表，从hive中创建表后能到HBase中查看,例子如下：
```
CREATE TABLE hbase_table_employee
  (
     empno       INT,
     ename       STRING,
     designation STRING,
     manager     INT,
     hire_date   STRING,
     sal         INT,
     deptno      INT
  )
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key,cf:ename,cf:designation,cf:manager,cf:hire_date,cf:sal,cf:deptno")
TBLPROPERTIES ("hbase.table.name" = "employee_hbase");
```
4. 通过hive查询hbase中的数据
```
hive> select * from hbasehive_table;
OK
row1    user1   book1   1
row2    user2   book1   3
row3    user2   book2   3
row4    user2   book4   1
```
在hive中查询到HBase表中添加的数据，说明整合就成功了
5. 将hive中数据导入到HBase
```
//将hive表pokes数据导入HBase
INSERT OVERWRITE TABLE hbase_table_1 SELECT * FROM pokes WHERE foo=98;
```

# 参考
1. https://cwiki.apache.org/confluence/display/Hive/HBaseIntegration
2. http://hadooptutorial.info/hbase-integration-with-hive/
3. https://acadgild.com/blog/hbase-write-using-hive/
4. http://bigdataprogrammers.com/data-migration-from-hive-to-hbase/