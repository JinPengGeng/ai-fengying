# 计算机网络深入

## TCP/IP 协议栈

### 1. 各层协议

| 层 | 协议 | 作用 |
|----|------|------|
| 应用层 | HTTP, DNS, FTP, SMTP | 用户接口 |
| 传输层 | TCP, UDP | 端到端传输 |
| 网络层 | IP, ICMP, ARP | 路由选择 |
| 链路层 | Ethernet, WiFi | 帧传输 |
| 物理层 | 光纤, 双绞线 | 比特传输 |

### 2. TCP 三次握手

```
客户端                    服务器
  |                        |
  |-------- SYN ----------->|
  |                        |
  |<----- SYN-ACK ---------|
  |                        |
  |-------- ACK ----------->|
  |                        |
  |     连接建立完成       |
```

```python
# TCP 客户端示例
import socket

def tcp_client():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(('server.com', 80))
    
    # 发送数据
    sock.send(b'GET / HTTP/1.1\r\nHost: server.com\r\n\r\n')
    
    # 接收数据
    response = sock.recv(4096)
    
    sock.close()
    return response
```

---

## HTTP 深入

### 3. HTTP 请求/响应

```python
# HTTP 请求构建
request = """GET /api/users HTTP/1.1
Host: api.example.com
Accept: application/json
Authorization: Bearer token123
Content-Type: application/json

"""


# HTTP 响应
response = """HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 45
Cache-Control: no-cache

{"id": 1, "name": "John", "email": "john@example.com"}
"""
```

### 4. HTTP 方法与状态码

| 方法 | 说明 | 安全 | 幂等 |
|------|------|------|------|
| GET | 获取资源 | ✅ | ✅ |
| POST | 创建资源 | ❌ | ❌ |
| PUT | 替换资源 | ❌ | ✅ |
| PATCH | 部分更新 | ❌ | ❌ |
| DELETE | 删除资源 | ❌ | ✅ |

| 状态码 | 说明 |
|--------|------|
| 1xx | 信息 |
| 200 | 成功 |
| 201 | 创建成功 |
| 301/302 | 重定向 |
| 400 | 客户端错误 |
| 401/403 | 认证/授权错误 |
| 404 | 未找到 |
| 500 | 服务器错误 |

### 5. HTTP/2 与 HTTP/3

```python
# HTTP/2 特性
# 1. 多路复用 - 单连接多请求
# 2. 头部压缩 - HPACK
# 3. 服务器推送
# 4. 二进制分帧

# HTTP/3 特性
# 1. 基于 QUIC (UDP)
# 2. 0-RTT 连接
# 3. 连接迁移
# 4. 改进的拥塞控制
```

---

## 网络安全

### 6. TLS/SSL

```
明文 -> TLS 加密 -> 密文传输 -> TLS 解密 -> 明文
```

```python
# Python TLS 示例
import ssl
import socket

# 创建 SSL 上下文
context = ssl.create_default_context()

# 连接到 HTTPS 服务器
with socket.create_connection(("example.com", 443)) as sock:
    with context.wrap_socket(sock, server_hostname="example.com") as ssock:
        print(ssock.getpeercert())
        ssock.send(b"GET / HTTP/1.1\r\nHost: example.com\r\n\r\n")
```

### 7. 常见攻击与防御

| 攻击 | 防御 |
|------|------|
| XSS | 输入转义、CSP |
| CSRF | Token、同源策略 |
| SQL 注入 | 参数化查询 |
| DDoS | 限流、CDN |
| MITM | HTTPS、证书 pinning |

---

## DNS 系统

### 8. DNS 记录类型

| 类型 | 说明 | 例子 |
|------|------|------|
| A | IPv4 地址 | example.com -> 93.184.216.34 |
| AAAA | IPv6 地址 | example.com -> 2606:2800:220:1:: |
| CNAME | 别名 | www -> @ |
| MX | 邮件服务器 | @ -> mail.example.com |
| TXT | 文本记录 | SPF, DKIM |
| NS | 名称服务器 | @ -> ns1.example.com |

```python
# DNS 查询示例
import socket

# A 记录查询
ip = socket.gethostbyname("example.com")
print(ip)

# MX 记录查询
import dns.resolver
mx = dns.resolver.resolve("example.com", "MX")
for record in mx:
    print(record.exchange)
```

---

## 负载均衡

### 9. 负载均衡算法

| 算法 | 说明 |
|------|------|
| Round Robin | 轮询 |
| Least Connections | 最少连接 |
| IP Hash | 源 IP 固定 |
| Weighted | 加权轮询 |
| Least Response Time | 最快响应 |

### 10. L4 vs L7 负载均衡

| 层级 | 说明 | 例子 |
|------|------|------|
| L4 | 传输层，基于 IP+端口 | HAProxy, LVS |
| L7 | 应用层，基于 HTTP | Nginx, Envoy |

---

## 让我变强的网络技能

1. **协议理解** - TCP/IP、HTTP
2. **安全** - TLS、HTTPS
3. **性能** - 缓存、压缩、CDN
4. **架构** - 负载均衡、网关
5. **排查** - 抓包、诊断工具

---
