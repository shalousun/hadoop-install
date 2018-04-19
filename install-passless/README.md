linux 服务器件的免密登录

# 修改hosts

首先需要设置host才方便设置免密登录
```
echo '
192.168.248.145   master
192.168.248.140   slave1
192.168.248.146   slave2
'>>/etc/hosts

```