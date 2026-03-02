# Linux 系统调优

## 内核参数

### 网络参数
```bash
# 查看/修改
sysctl -a | grep net.ipv4
sysctl -w net.ipv4.tcp_fastopen=3

# 持久化
echo "net.ipv4.tcp_fastopen=3" >> /etc/sysctl.conf
```

### 文件描述符
```bash
# 当前限制
ulimit -n

# 永久修改
echo "* soft nofile 65535" >> /etc/security/limits.conf
echo "* hard nofile 65535" >> /etc/security/limits.conf
```

---

## 性能监控

### 常用命令
```bash
# CPU
top / htop
mpstat -P ALL 1

# 内存
free -h
vmstat 1

# IO
iostat -xz 1
iotop

# 网络
ss -s
netstat -i
```

### 性能分析工具
| 工具 | 用途 |
|------|------|
| perf | 性能分析 |
| strace | 系统调用 |
| ltrace | 库调用 |
| ebpf | 内核追踪 |
|火焰图| 可视化分析|

---

## 资源限制

### cgroups v2
```bash
# 创建控制组
mkdir -p /sys/fs/cgroup/limit

# 设置内存限制
echo 100M > /sys/fs/cgroup/limit/memory.max

# 添加进程
echo <pid> > /sys/fs/cgroup/limit/cgroup.procs
```

### systemd 限制
```ini
[Service]
MemoryMax=2G
CPUQuota=200%
TasksMax=100
```

---

## 磁盘优化

### I/O 调度器
```bash
# 查看
cat /sys/block/sda/queue/scheduler

# 修改
echo "mq-deadline" > /sys/block/sda/queue/scheduler
```

### 文件系统选择
| 文件系统 | 场景 |
|----------|------|
| ext4 | 通用 |
| xfs | 大文件 |
| btrfs | 快照 |
| zfs | 高可靠性 |
