# 网络安全基础

## 加密算法

### 对称加密
| 算法 | 密钥长度 | 速度 | 场景 |
|------|----------|------|------|
| AES | 128/192/256 | 快 | 数据加密 |
| ChaCha20 | 256 | 快 | 移动端 |
| SM4 | 128 | 快 | 国密 |

### 非对称加密
| 算法 | 密钥长度 | 速度 | 场景 |
|------|----------|------|------|
| RSA | 2048+ | 慢 | 密钥交换 |
| ECC | 256 | 快 | 移动端 |
| SM2 | 256 | 中 | 国密 |

### 哈希算法
- **MD5**: 128位，已不安全
- **SHA-1**: 160位，不推荐
- **SHA-256**: 256位，推荐
- **SM3**: 256位，国密

---

## 数字签名

### RSA 签名
```
签名: s = H(m)^d mod n
验证: s^e mod n == H(m)
```

### ECDSA
- 椭圆曲线数字签名
- 比 RSA 更短密钥
- Bitcoin 使用

---

## TLS/SSL

### 握手流程
1. ClientHello → 支持的密码套件
2. ServerHello → 选定密码套件 + 证书
3. 证书验证 + 密钥交换
4. Finished → 验证加密通道

### 密码套件示例
```
TLS_AES_256_GCM_SHA384
TLS_CHACHA20_POLY1305_SHA256
ECDHE-RSA-AES256-GCM-SHA384
```

### 安全配置
```nginx
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:...;
ssl_prefer_server_ciphers on;
ssl_session_timeout 1d;
```

---

## 常见攻击

| 攻击 | 防御 |
|------|------|
| MITM | 证书校验 |
| XSS | 输出编码 |
| CSRF | Token |
| SQL注入 | 参数化查询 |
| DDoS | 限流/CDN |
