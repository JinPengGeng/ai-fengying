# 分布式事务

## CAP 定理

- **Consistency**: 一致性
- **Availability**: 可用性
- **Partition Tolerance**: 分区容错

**只能同时满足两个**:
- CP: 放弃可用性 (ZooKeeper, etcd)
- AP: 放弃一致性 (Cassandra, DynamoDB)
- CA: 单机环境 (MySQL)

---

## BASE 理论

- **Basically Available**: 软状态
- **Eventually Consistent**: 最终一致
- **Soft State**: 允许中间状态

---

## 事务模式

### 2PC (两阶段提交)

**阶段1**: 准备 (Prepare)
-Coordinator 询问所有节点

**阶段2**: 提交 (Commit)
- 所有节点提交/回滚

**问题**: 阻塞、单点故障

### 3PC (三阶段提交)

- CanCommit → PreCommit → DoCommit
- 减少阻塞风险

### TCC (Try-Confirm-Cancel)

```
Try: 预留资源
Confirm: 确认执行
Cancel: 取消预留
```

### Saga 模式

- 链式局部事务
- 正向补偿 / 反向补偿
- 适合长流程

---

## 消息事务

### 本地消息表
1. 业务表 + 消息表同一事务
2. 定时扫描发送消息
3. 消费端幂等处理

### 事务消息 (RocketMQ)
- 半消息机制
- 本地事务执行 + 消息发送
- 回查确保一致

---

## 分布式锁

### Redis 实现
- SETNX + Lua
- RedLock 算法
- 过期时间防死锁

### ZK 实现
- 临时顺序节点
- Watch 机制
- 高可靠性
