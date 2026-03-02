# 数据库系统基础

## 关系型数据库

### 1. MySQL

```sql
-- 创建数据库
CREATE DATABASE myapp;

-- 创建表
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 索引
CREATE INDEX idx_email ON users(email);
CREATE INDEX idx_created ON users(created_at);

-- 查询
SELECT * FROM users WHERE email = 'test@example.com';

-- 联表查询
SELECT u.name, o.total
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;
```

### 2. PostgreSQL

```sql
-- JSON 类型
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    attributes JSONB
);

-- 数组类型
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)[],
    category TEXT[]
);

-- 全文搜索
SELECT * FROM articles
WHERE to_tsvector(content) @@ to_tsquery('python');
```

---

## NoSQL

### 3. MongoDB

```javascript
// 插入
db.users.insertOne({
    name: "John",
    email: "john@example.com",
    tags: ["admin", "user"]
})

// 查询
db.users.find({
    tags: "admin"
})

// 更新
db.users.updateOne(
    { _id: 1 },
    { $set: { name: "Jane" } }
)
```

### 4. Redis

```bash
SET user:1 "John"
GET user:1

HSET user:1 name "John" age 25
HGETALL user:1

LPUSH queue "task1"
RPOP queue
```

---

## 让我变强的数据库技能

1. **MySQL** - 索引、事务
2. **PostgreSQL** - JSONB、数组
3. **MongoDB** - 文档数据库
4. **Redis** - 缓存、队列
5. **设计** - 范式、反范式

---
