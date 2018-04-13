hive的单实例安装，由于hive依赖于hadoop，因此在安装本实例前，请先使用install-hadoop-standalone来
安装好hadoop.


# 启动hive的服务

启动metastore
```
nohup hive --service metastore &
```
启动hive server2

```
nohup hiveserver2 &
```

hive命令模式，由于环境变量配置了hive,所以可直接输入
```
hive
```
# hive测试

注意下面示例命令行hive前缀表示使用hive命令输入的。

## 创建数据库

```
hive> create database db_hive_test;
```
## 切换数据库
```
hive> use db_hive_test;
```
## 创建表
```
hive> create table student(id int,name string) row format delimited fields terminated by '\t';
```
## 加载数据到表中
新建student.txt 文件写入数据(id，name 按tab键分隔)，vi student.txt，在student.txt中放入下面的数据
```
1001 zhangsan
1002 lisi
1003 wangwu
1004 zhaoli
```
加载数据到表中,注意要自己的student.txt的路径
```
hive> load data local inpath '/usr/local/hadoop/student.txt' into table  db_hive_test.student;
```
## 查询数据

```
hive> select * from student;
```

## 查看表的详细信息
```
hive> desc formatted student;
```
通过ui页面查看创建的数据位置
http://xxx:50070/explorer.html#/user/hive/warehouse/db_hive_test.db
## 通过Mysql查看创建的表
```
mysql> use hive;
mysql> select * from TBLS;
``