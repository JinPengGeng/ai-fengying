# Linux 基础

## 常用命令

### 文件操作

```bash
# 目录
ls -la          # 列出
cd <dir>        # 进入
pwd             # 当前目录
mkdir <dir>     # 创建目录
rm -rf <dir>   # 删除

# 文件
touch <file>    # 创建
cat <file>      # 查看
head <file>     # 头部
tail <file>     # 尾部
cp <src> <dst>  # 复制
mv <src> <dst>  # 移动
rm <file>       # 删除
```

### 文本处理

```bash
# 查看
cat, less, more, head, tail

# 搜索
grep "pattern" <file>
grep -r "pattern" <dir>

# 统计
wc -l <file>   # 行数
wc -w <file>   # 词数

# 编辑
sed -i 's/old/new/g' <file>
awk '{print $1}' <file>
```

### 系统操作

```bash
# 进程
ps aux          # 查看进程
top             # 实时监控
kill <pid>      # 杀死进程

# 网络
ping <host>     # 测试连接
curl <url>      # 请求
wget <url>      # 下载
netstat -tulpn  # 端口

# 磁盘
df -h           # 磁盘使用
du -sh <dir>    # 目录大小
```

---

## 权限

### 权限表示

```
rwx r-x r-x
[所有者][组][其他]
```

| 权限 | 数字 | 含义 |
|------|------|------|
| r | 4 | 读 |
| w | 2 | 写 |
| x | 1 | 执行 |

### 修改权限

```bash
chmod 755 <file>    # 数字
chmod +x <file>     # 添加执行
chown user:group <file>  # 所有者
```

---

## 软件安装

### 包管理器

| 系统 | 命令 |
|------|------|
| Debian/Ubuntu | apt install |
| CentOS/RHEL | yum install |
| macOS | brew install |

---

## Shell 脚本

### 基础

```bash
#!/bin/bash

# 变量
name="World"
echo "Hello $name"

# 条件
if [ $age -gt 18 ]; then
    echo "成年"
fi

# 循环
for i in {1..5}; do
    echo $i
done
```

---

## 让我变强的 Linux 技能

1. **命令行**: 文件、进程、网络
2. **权限**: chmod, chown
3. **脚本**: Bash 编程
4. **软件**: 包管理、安装
