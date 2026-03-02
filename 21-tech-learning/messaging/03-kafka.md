# Kafka 深入指南

## 核心概念

### Topic & Partition
- Topic: 消息主题
- Partition: 分区，平行处理
- Replica: 副本，高可用

### 消息顺序
- Partition 内有序
- 跨分区可通过 Key 保证顺序

### 偏移量 (Offset)
- Consumer 维护消费位置
- 可重置偏移量实现重放

---

## 生产者机制

### acks 配置
| 值 | 语义 |
|----|------|
| 0 | 不等待确认 |
| 1 | Leader 确认 |
| all | ISR 全部确认 |

### 批量发送
- batch.size: 批量大小
- linger.ms: 等待时间
- 压缩: gzip, snappy, zstd

---

## 消费者机制

### 消费者组
- Group ID 标识组
- Partition 分配策略
- Rebalance 触发条件

### 至少一次 vs 正好一次
- 至少一次: 自动重试 + 手动提交
- 正好一次: 事务 API + 幂等性

---

## 高级特性

### Streams API
- 实时流处理
- 状态存储
- 窗口操作

### Connect API
- 源/Sink 连接器
- Debezium CDC 集成

---

## 性能调优

- 顺序写磁盘
- 零拷贝技术
- 页缓存利用
- 合理分区数
