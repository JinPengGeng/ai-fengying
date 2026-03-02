# WebSocket 深度指南

## 协议基础

### 握手流程
1. Client 发送 HTTP Upgrade 请求
2. Server 响应 101 Switching Protocols
3. 建立 WebSocket 连接

### 帧格式
- FIN: 消息是否完整
- Opcode: 操作码 (0x0=continuation, 0x1=text, 0x2=binary, 0x8=close, 0x9=ping, 0xA=pong)
- Mask: 是否掩码
- Payload: 负载数据

---

## 消息模式

### 发布/订阅
```javascript
// Redis Pub/Sub
pub/sub 模式实现实时消息推送
```

### 广播
- 房间/频道概念
- 在线用户管理

### 点对点
- 用户身份识别
- 消息确认机制

---

## 性能优化

| 技术 | 作用 |
|------|------|
| 连接复用 | 减少 TCP 握手开销 |
| 心跳保活 | 检测连接存活 |
| 压缩 | 减少传输数据 |
| 二进制协议 | 提高解析效率 |

---

## 安全考虑

- Origin 验证
- 消息大小限制
- DDoS 防护
- TLS/SSL 加密
