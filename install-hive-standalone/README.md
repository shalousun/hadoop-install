hive2.3.3的单实例安装，由于hive依赖于hadoop，因此在安装本实例前，请先使用install-hadoop-standalone来
安装好hadoop 。本实例安装中使用mysql来作为hive matastore的元数据存储，mysql的连接的相关信息在conf/hive-site.xml中。
实际安装是可以根据自己安装的mysql去修改连接信息。


# 启动hive的服务

启动metastore
```
nohup hive --service metastore &
```
启动hive server2

```
nohup hiveserver2 &
```
关闭hive服务
```
ps -ef | grep hive //查找出hive的端口kill掉，重新使用上面的命令重启
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
新建student.txt 文件写入数据(id，name 按tab键分隔,不能用空格键)，vi student.txt，在student.txt中放入下面的数据
```
1001    zhangsan
1002    lisi
1003    wangwu
1004    zhaoli
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
```
## beeline测试
由于配置环境变量已经生效，因此直接输入beeline命令就可以了
```
beeline>!connect jdbc:hive2://localhost:10000/default
```
上面会提示输入用户名密码

# 编程测试
本例安装的hive是2.3.3，因此需要使用hive-jdbc的版本是2.3.3，如果驱动版本不兼容，则可能会出现
连接问题
```
public static void main(String... arg) {
    String driverName = "org.apache.hive.jdbc.HiveDriver";
    try {
        Class.forName(driverName);
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        System.exit(1);
    }

    try{
    Connection con = DriverManager.getConnection("jdbc:hive2://192.168.248.143:10000/db_hive_test", "", "");
    Statement stmt = con.createStatement();

    String sql = "select * from student";
    System.out.println("Running: " + sql);
    ResultSet res = stmt.executeQuery(sql);
    while (res.next()) {
        System.out.println(String.valueOf(res.getString(1)));
    }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
```