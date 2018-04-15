在hadoop的生态中，主要是使用zookeeper来做集群的，包括hbase也需要使用zookeeper,对于生产环境zookeeper是
需要集群，但是为了快速的实现基础环境，本例采用Standalone的方式安装。ps:本例只来redhad系列的CentOS中测试过。

# 安装脚本模块说明
1. install.sh是自动安装zookeeper的脚本。
2. linux7-export-port.sh是用于在linux 7+的系统自动开放2181端口的脚本，其他系统可以根据系统的防火墙工具
参照本例编写脚本。
3. conf是zookeeper的一些配置，java.env主要是用于配置zookeeper的jvm参数的，根据需求自己修改jvm参数，
zoo.cfg主要是zookeeper的基础配置

注意：安装时需要下在install-zookeeper-standalone整个模块到宿主机，否则安装脚本会执行错误，无法找到配置文件

# 启动zookeeper服务
```
# bin/zkServer.sh start
//配置了环境变量后可使用下列命令
# zkServer.sh start
```
# 启动CLI
 启动CLI检测客服端是否连通
```
$ bin/zkCli.sh
//配置了环境变量后可使用下列命令
# zkServer.sh stop
```

# 状态查看

```
# bin/zkServer.sh status
//配置了环境变量后可使用下列命令
# zkServer.sh status
```

查看后输出状态如下
```
JMX enabled by default
Using config: /usr/local/zookeeper/zookeeper/bin/../conf/zoo.cfg
Mode: standalone
```