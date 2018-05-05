在Master节点上启动hbase服务

# hbase 1.3.x服务端口

服务 | 端口号
---|---
HBase's zookeeper | 2181
HBase Master|16000
HBase Master web UI | 16010
HRegionServer|16201
RegionServer web ui|16301

# API连接HBase
对于集群的HBase环境，服务启动后会将16000端口直接绑定到127.0.0.1上，因此通过外部是不能访问该端口的
因此需要配置宿主机的hostname
```
hostnamectl set-hostname master
```
映射ip的hostname的关系
```
ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1 -d '/'
//获取ip
ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | awk -F"/" '{print $1}'
```
设置host
```
vi /etc/hosts
192.168.248.145 master
```

配置windows的hosts映射到hbase master宿主机
```
192.168.248.145 master
```

# 启动集群
启动hbase集群只需要在master节点上执行启动命令，其他slave节点也会自动启动
```
start-hbase.sh
```
# 查看hbase集群状态
```aidl
http://master:16010
```