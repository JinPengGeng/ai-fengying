# 数据库设计进阶

## 数据库类型选择

### 关系型 vs NoSQL

| 特性 | 关系型 (MySQL/PostgreSQL) | NoSQL (MongoDB/Redis) |
|------|--------------------------|---------------------|
| **数据模型** | 表、行、列 | 文档/键值/图 |
| **事务** | ACID | BASE |
| **扩展性** | 垂直 | 水平 |
| **查询** | SQL | API/DSL |
| **场景** | 业务数据 | 海量数据、快速迭代 |

---

## MySQL 高级特性

### 1. 索引优化

```sql
-- B-Tree 索引（默认）
CREATE INDEX idx_user_email ON users(email);

-- 复合索引（最左前缀）
CREATE INDEX idx_order_user_date ON orders(user_id, created_at);

-- 覆盖索引
CREATE INDEX idx_user_cover ON users(id, email, name);

-- 全文索引
ALTER TABLE articles ADD FULLTEXT(content);

-- 使用
SELECT * FROM articles 
WHERE MATCH(content) AGAINST('database' IN NATURAL LANGUAGE MODE);
```

### 2. 查询优化

```sql
-- EXPLAIN 分析
EXPLAIN SELECT * FROM orders 
WHERE user_id = 1 AND created_at > '2024-01-01';

-- 优化技巧
-- 1. 避免 SELECT *
SELECT id, name FROM users WHERE id = 1;

-- 2. 使用 LIMIT
SELECT * FROM logs ORDER BY id DESC LIMIT 10;

-- 3. 批量操作
INSERT INTO users(name) VALUES ('a'), ('b'), ('c');

-- 4. 分页优化
-- 慢
SELECT * FROM orders LIMIT 100000, 10;
-- 快（使用 ID）
SELECT * FROM orders WHERE id > 100000 LIMIT 10;
```

### 3. 事务与锁

```sql
-- 事务
START TRANSACTION;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
-- 或回滚
ROLLBACK;

-- 行锁
SELECT * FROM orders WHERE id = 1 FOR UPDATE;

-- 死锁检测
SHOW ENGINE INNODB STATUS;
```

---

## Redis 深入

### 4. 数据结构

```python
import redis

r = redis.Redis()

# String
r.set("user:1", "{\"name\": \"John\"}")
r.get("user:1")
r.incr("counter")

# Hash
r.hset("user:1", "name", "John")
r.hset("user:1", "age", "25")
r.hgetall("user:1")

# List
r.lpush("queue", "task1")
r.rpop("queue")

# Set
r.sadd("tags", "python", "redis", "database")
r.smembers("tags")

# Sorted Set
r.zadd("leaderboard", {"john": 100, "jane": 200})
r.zrevrange("leaderboard", 0, 10, withscores=True)
```

### 5. 缓存策略

```python
# Cache-Aside
def get_user(user_id):
    # 1. 先查缓存
    cache_key = f"user:{user_id}"
    user = r.get(cache_key)
    if user:
        return json.loads(user)
    
    # 2. 缓存没有，查数据库
    user = db.query("SELECT * FROM users WHERE id = ?", user_id)
    
    # 3. 写入缓存
    r.setex(cache_key, 3600, json.dumps(user))
    
    return user
```

---

## MongoDB 应用

### 6. 聚合管道

```javascript
// 聚合查询
db.orders.aggregate([
    // 1. 筛选
    { $match: { status: "completed" } },
    
    // 2. 解构数组
    { $unwind: "$items" },
    
    // 3. 分组统计
    { $group: {
        _id: "$customer_id",
        total: { $sum: "$items.price" },
        count: { $sum: 1 }
    }},
    
    // 4. 排序
    { $sort: { total: -1 } },
    
    // 5. 限制
    { $limit: 10 }
])
```

### 7. 索引设计

```javascript
// 单字段索引
db.users.createIndex({ email: 1 })

// 复合索引
db.orders.createIndex({ customer_id: 1, created_at: -1 })

// 多键索引（数组）
db.products.createIndex({ tags: 1 })

// 文本索引
db.articles.createIndex({ title: "text", content: "text" })

// 查看索引
db.users.getIndexes()
```

---

## 数据库设计原则

### 8. 三范式

| 范式 | 要求 | 例子 |
|------|------|------|
| **1NF** | 原子性 | 地址拆成省市区 |
| **2NF** | 消除冗余 | 用 ID 关联 |
| **3NF** | 消除依赖 | 用外键关联 |

### 9. 反模式

| 反模式 | 问题 | 解决方案 |
|--------|------|----------|
| **EAV** | 查询复杂 | 固定字段 |
| **交叉表** | 扩展困难 | JSON 字段 |
| **分表** | 跨表查询 | 视图/搜索 |
| **过度索引** | 写入慢 | 按需创建 |

---

## 让我变强的数据库技能

1. **SQL 优化** - EXPLAIN 分析、索引设计
2. **NoSQL 选型** - 场景匹配
3. **缓存策略** - Redis 各种模式
4. **分库分表** - 水平扩展
5. **数据安全** - 备份、加密

---
