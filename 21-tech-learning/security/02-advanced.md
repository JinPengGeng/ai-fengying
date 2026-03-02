# 安全工程基础

## OWASP Top 10

### 1. 常见漏洞

| 漏洞 | 说明 | 防御 |
|------|------|------|
| A01:2023 | 访问控制失效 | 权限检查 |
| A02:2023 | 加密失败 | HTTPS, 加密存储 |
| A03:2023 | 注入 | 参数化查询 |
| A04:2023 | 不安全设计 | 安全架构 |
| A05:2023 | 安全配置错误 | 最小权限 |
| A06:2023 | 易受攻击组件 | 及时更新 |
| A07:2023 | 识别失败 | 审计日志 |
| A08:2023 | 软件完整性失败 | 签名验证 |
| A09:2023 | 安全日志不足 | 完整日志 |
| A10:2023 | 服务端请求伪造 | 限制 DNS |

### 2. SQL 注入

```python
# ❌ 危险
query = f"SELECT * FROM users WHERE id = {user_id}"
cursor.execute(query)

# ✅ 安全
query = "SELECT * FROM users WHERE id = %s"
cursor.execute(query, (user_id,))

# ✅ ORM
user = User.objects.get(id=user_id)
```

### 3. XSS 防御

```python
# ❌ 危险
html = f"<div>{user_input}</div>"

# ✅ 安全
import html
html = html.escape(user_input)

# ✅ Django
from django.utils.html import escape
html = escape(user_input)
```

---

## 身份认证

### 4. 密码存储

```python
import bcrypt

# 加密密码
def hash_password(password):
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt())

# 验证密码
def verify_password(password, hashed):
    return bcrypt.checkpw(password.encode(), hashed)

# 使用
hashed = hash_password("mypassword")
verify_password("mypassword", hashed)
```

### 5. Session 管理

```python
# Flask Session
app.secret_key = "secure-random-key"

# Django Session
SESSION_ENGINE = 'django.contrib.sessions.backends.db'

# 安全 Cookie
response.set_cookie(
    'sessionid',
    session_id,
    secure=True,      # HTTPS only
    httponly=True,    # No JS access
    samesite='Strict'
)
```

---

## 加密

### 6. 对称加密

```python
from cryptography.fernet import Fernet

# 生成密钥
key = Fernet.generate_key()

# 加密
cipher = Fernet(key)
encrypted = cipher.encrypt(b"secret data")

# 解密
decrypted = cipher.decrypt(encrypted)
```

### 7. 非对称加密

```python
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.backends import default_backend

# 生成密钥对
private_key = rsa.generate_private_key(
    public_exponent=65537,
    key_size=2048
)

# 导出公钥
public_key = private_key.public_key()
public_pem = public_key.public_bytes(
    encoding=serialization.Encoding.PEM,
    format=serialization.PublicFormat.SubjectPublicKeyInfo
)
```

---

## 渗透测试

### 8. 常用工具

| 工具 | 用途 |
|------|------|
| nmap | 端口扫描 |
| sqlmap | SQL 注入 |
| burp suite |
| nik | Web 代理to | Web 扫描 |
| hydra | 暴力破解 |

### 9. SQLMap 使用

```bash
# 检测注入
sqlmap -u "http://target.com/page?id=1"

# 获取数据库
sqlmap -u "http://target.com/page?id=1" --dbs

# 获取表
sqlmap -u "http://target.com/page?id=1" -D database --tables

# 获取数据
sqlmap -u "http://target.com/page?id=1" -D database -T users --dump
```

---

## 安全扫描

### 10. 代码扫描

```bash
# Bandit (Python)
pip install bandit
bandit -r ./project

# npm audit
npm audit

# 依赖检查
pip install safety
safety check
```

---

## 让我变强的安全技能

1. **OWASP** - 常见漏洞与防御
2. **身份认证** - Session、JWT
3. **加密** - 对称、非对称
4. **渗透测试** - nmap、sqlmap
5. **代码扫描** - Bandit、npm audit

---
