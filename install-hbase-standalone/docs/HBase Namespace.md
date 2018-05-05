文本来自网络
# 1、介绍
在HBase中，namespace命名空间指对一组表的逻辑分组，类似RDBMS中的database，方便对表在业务上划分。Apache HBase从0.98.0, 0.95.2两个版本开始支持namespace级别的授权操作，HBase全局管理员可以创建、修改和回收namespace的授权。

# 2、namespace

HBase系统默认定义了两个缺省的namespace
hbase：系统内建表，包括namespace和meta表
default：用户建表时未指定namespace的表都创建在此

创建namespace

```
hbase>create_namespace 'ai_ns' 
```
 
删除namespace
```
hbase>drop_namespace 'ai_ns'  
```

查看namespace
```
hbase>describe_namespace 'ai_ns'  
```

列出所有namespace
```
hbase>list_namespace
```
  
在namespace下创建表
```
hbase>create 'ai_ns:testtable', 'fm1' 
```
 
查看namespace下的表
```
hbase>list_namespace_tables 'ai_ns'  
```


3、授权
具备Create权限的namespace Admin可以对表创建和删除、生成和恢复快照
具备Admin权限的namespace Admin可以对表splits或major compactions

授权tenant-A用户对ai_ns下的写权限

```
hbase>grant 'tenant-A' 'W' '@ai_ns' 
```
 
回收tenant-A用户对ai_ns的所有权限
```
hbase>revoke 'tenant-A''@ai_ns'  
```

当前用户：hbase
```aidl
hbase>namespace_create 'hbase_perf'  
hbase>grant 'mike', 'W', '@hbase_perf'  
```


当前用户：mike
```
hbase>create 'hbase_perf.table20', 'family1'  
hbase>create 'hbase_perf.table50', 'family1'  
```

mike创建了两张表table20和table50，同时成为这两张表的owner，意味着有'RWXCA'权限
此时，mike团队的另一名成员alice也需要获得hbase_perf下的权限，hbase管理员操作如下
当前用户：hbase
```
hbase>grant 'alice', 'W', '@hbase_perf'  
```


此时alice可以在hbase_perf下创建表，但是无法读、写、修改和删除hbase_perf下已存在的表
当前用户：alice
[ruby] view plain copy
```
hbase>scan 'hbase_perf:table20'
```
  
报错AccessDeniedException
如果希望alice可以访问已经存在的表，则hbase管理员操作如下
当前用户：hbase
```
hbase>grant 'alice', 'RW', 'hbase_perf.table20'  
hbase>grant 'alice', 'RW', 'hbase_perf.table50'
```

在HBase中启用授权机制
hbase-site.xml
```
<property>  
     <name>hbase.security.authorization</name>  
     <value>true</value>  
</property>  
<property>  
     <name>hbase.coprocessor.master.classes</name>  
     <value>org.apache.hadoop.hbase.security.access.AccessController</value>  
</property>  
<property>  
     <name>hbase.coprocessor.region.classes</name>  
     <value>org.apache.hadoop.hbase.security.token.TokenProvider,org.apache.hadoop.hbase.security.access.AccessController</value>  
</property> 
```
 
配置完成后需要重启HBase集群