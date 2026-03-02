# 高性能 MySQL

## 索引优化

### B+Tree 索引
- 叶子节点链表
- 范围查询高效
- 适合排序

### 索引原则
- 区分度高的列
- 覆盖索引 (Covering Index)
- 最左前缀原则
- 避免冗余索引

### 索引失效场景
- LIKE '%xx'
- 函数运算
- 类型转换
- OR 连接
- 最左前缀不满足

---

## SQL 优化

### 
```sql
慢查询分析-- 开启慢查询日志
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;

-- 分析执行计划
EXPLAIN FORMAT=JSON SELECT ...
```

### 优化技巧
- 避免 SELECT *
- 分页优化: 延迟关联 / 游标分页
- 批量操作
- 分解大 JOIN

---

## 分库分表

### 水平拆分
- 按某个字段哈希取模
- 范围分片 (时间、ID)
- 一致性哈希

### 垂直拆分
- 按业务拆分
- 冷热分离
- 字段优化

### 分布式 ID
- UUID
- Snowflake
- 数据库号段
- Leaf 算法

---

## 主从复制

### 复制原理
1. Master 写 Binlog
2. Slave IO 线程拉取
3. Slave SQL 线程重放

### 复制模式
- 异步复制
- 半同步复制
- 并行复制

### 读写分离
- 客户端代理 (ShardingSphere)
- 中间件 (MyCat, Vitess)
- 代理层 (ProxySQL)

---

## 性能配置

| 参数 | 推荐值 | 说明 |
|------|--------|------|
| innodb_buffer_pool_size | 70-80% 内存 | 缓冲池大小 |
| max_connections | 1000-2000 | 最大连接 |
| innodb_log_file_size | 1-2GB | 日志文件 |
| query_cache_size | 禁用 | MySQL 8.0 已移除 |
