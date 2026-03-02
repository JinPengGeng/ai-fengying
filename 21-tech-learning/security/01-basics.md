# 信息安全基础

## 常见攻击类型

### 1. 网络攻击

| 攻击 | 说明 | 防御 |
|------|------|------|
| DDoS | 分布式拒绝服务 | CDN、限流 |
| MITM | 中间人攻击 | HTTPS、证书 |
| DNS 欺骗 | DNS 劫持 | DNSSEC |
| ARP 欺骗 | ARP 伪装 | 静态 ARP |
| 端口扫描 | 信息收集 | 防火墙 |

### 2. 应用攻击

| 攻击 | 说明 | 防御 |
|------|------|------|
| SQL 注入 | 数据库渗透 | 参数化查询 |
| XSS | 跨站脚本 | 输入转义 |
| CSRF | 跨站请求伪造 | CSRF Token |
| 文件上传 | 恶意文件 | 文件类型限制 |
| 命令注入 | 系统命令 | 输入验证 |

---

## 加密技术

### 3. 对称加密

```python
from cryptography.fernet import Fernet

# 生成密钥
key = Fernet.generate_key()

# 加密
cipher = Fernet(key)
ciphertext = cipher.encrypt(b"Secret message")

# 解密
plaintext = cipher.decrypt(ciphertext)
```

### 4. 非对称加密

```python
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding

# 生成密钥对
private_key = rsa.generate_private_key(
    public_exponent=65537,
    key_size=2048
)
public_key = private_key.public_key()

# 签名
message = b"Message to sign"
signature = private_key.sign(
    message,
    padding.PSS(
        mgf=padding.MGF1(hashes.SHA256()),
        salt_length=padding.PSS.MAX_LENGTH
    ),
    hashes.SHA256()
)

# 验证
public_key.verify(
    signature,
    message,
    padding.PSS(
        mgf=padding.MGF1(hashes.SHA256()),
        salt_length=padding.PSS.MAX_LENGTH
    ),
    hashes.SHA256()
)
```

---

## 身份验证

### 5. 多因素认证

```python
# TOTP (时间同步 OTP)
import pyotp

# 生成密钥
secret = pyotp.random_base32()
totp = pyotp.TOTP(secret)

# 验证
code = input("Enter OTP: ")
print(totp.verify(code))  # True/False

# 生成 QR 码 URI
uri = totp.provisioning_uri("user@example.com", issuer_name="MyApp")
```

### 6. JWT

```python
import jwt
import datetime

# 创建 Token
payload = {
    "user_id": 123,
    "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=24)
}
token = jwt.encode(payload, "secret", algorithm="HS256")

# 验证 Token
try:
    decoded = jwt.decode(token, "secret", algorithms=["HS256"])
    print(decoded["user_id"])
except jwt.ExpiredSignatureError:
    print("Token expired")
```

---

## 防火墙

### 7. iptables

```bash
# 允许 SSH
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# 允许 HTTP/HTTPS
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# 允许已建立连接
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 默认拒绝
iptables -P INPUT DROP

# 保存
iptables-save > /etc/iptables/rules.v4
```

---

## 入侵检测

### 8. 日志分析

```bash
# 查找失败登录
grep "Failed password" /var/log/auth.log

# 查找可疑进程
ps aux | grep -v grep | awk '{print $11}' | sort | uniq -c | sort -rn

# 查找最近修改的文件
find /var/www -mtime -1

# 网络连接
netstat -antp | grep ESTABLISHED
```

---

## 应急响应

### 9. 响应流程

```
1. 识别 - 发现异常
2. 遏制 - 隔离受影响系统
3. 根除 - 移除恶意软件/后门
4. 恢复 - 恢复系统正常
5. 复盘 - 分析原因，改进防御
```

### 10. 取证

```bash
# 保存内存镜像
dd if=/dev/mem of=memory.img

# 保存磁盘镜像
dd if=/dev/sda of=disk.img bs=4M

# 网络流量捕获
tcpdump -i eth0 -w capture.pcap
```

---

## 让我变强的安全技能

1. **攻击类型** - 网络、应用攻击
2. **加密** - 对称、非对称
3. **身份验证** - MFA、JWT
4. **防火墙** - iptables
5. **应急响应** - 取证、修复

---
