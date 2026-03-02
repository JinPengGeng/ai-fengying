# Linux 系统管理

## 用户与权限

### 1. 用户管理

```bash
# 添加用户
useradd -m -s /bin/bash -G sudo username

# 修改密码
passwd username

# 删除用户
userdel -r username

# 查看用户
id username
cat /etc/passwd

# 用户组
groupadd developers
usermod -aG developers username
```

### 2. 权限管理

```bash
# 修改权限
chmod 755 file          # rwxr-xr-x
chmod +x script.sh      # 添加执行权限
chown user:group file   # 修改所有者

# 特殊权限
chmod u+s file          # SUID
chmod g+s file          # SGID
chmod +t directory/     # Sticky Bit

# ACL
setfacl -m u:john:r file
getfacl file
```

---

## 进程管理

### 3. 进程查看

```bash
# 查看进程
ps aux                    # 详细
ps -ef                    # 完整格式
top                       # 实时监控
htop                      # 交互式 (推荐)

# 按资源排序
ps aux --sort=-%cpu      # CPU 排序
ps aux --sort=-%mem      # 内存排序

# 查找进程
pgrep -f python
pkill -f python
```

### 4. 进程控制

```bash
# 信号
kill -l                   # 查看信号列表
kill -15 PID             # 正常终止 (SIGTERM)
kill -9 PID              # 强制终止 (SIGKILL)
kill -2 PID              # 中断 (Ctrl+C)

# 后台进程
nohup ./script.sh &      # 后台运行
jobs                     # 查看后台任务
fg %1                    # 调回前台
bg %1                    # 继续后台

# 进程树
pstree -p
```

---

## 网络管理

### 5. 网络命令

```bash
# 查看网络
ip addr                  # IP 地址
ip link                  # 网络接口
ip route                # 路由表
netstat -tulnp          # 监听端口
ss -tulnp               # 替代 netstat

# 连接测试
ping -c 4 example.com
traceroute example.com
mtr example.com          # ping + traceroute

# DNS
dig example.com
nslookup example.com
host example.com
```

### 6. 防火墙

```bash
# ufw (Ubuntu)
ufw status
ufw allow 22/tcp
ufw deny 80/tcp
ufw enable

# iptables
iptables -L -n
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -j DROP
```

---

## 软件管理

### 7. 包管理

```bash
# Ubuntu/Debian
apt update
apt upgrade
apt install package
apt remove package
apt search keyword
apt show package

# CentOS/RHEL
yum update
yum install package
yum remove package
dnf search keyword

# Python
pip install package
pip list
pip freeze > requirements.txt

# Node.js
npm install -g package
npm list -g
```

---

## 磁盘管理

### 8. 磁盘操作

```bash
# 查看磁盘
df -h                    # 使用情况
du -sh directory/        # 目录大小
lsblk                    # 块设备

# 挂载
mount /dev/sdb1 /mnt/usb
umount /mnt/usb

# 磁盘分区
fdisk -l
parted /dev/sdb
```

---

## 日志管理

### 9. 日志查看

```bash
# 系统日志
/var/log/syslog         # Ubuntu
/var/log/messages       # CentOS

# 查看日志
tail -f /var/log/syslog
journalctl -u service   # systemd 服务日志
less +G /var/log/syslog

# 日志轮转
logrotate -f /etc/logrotate.conf
```

---

## 性能监控

### 10. 监控命令

```bash
# CPU/内存
top
htop
vmstat 1
mpstat -P ALL 1

# 磁盘 I/O
iostat -x 1
iotop

# 网络
iftop
nethogs

# 综合监控
dstat -cdmry
glances
```

---

## 让我变强的 Linux 技能

1. **用户与权限** - useradd, chmod, ACL
2. **进程管理** - ps, top, kill
3. **网络管理** - ip, netstat, iptables
4. **软件管理** - apt, yum, pip
5. **性能监控** - top, htop, iostat

---
