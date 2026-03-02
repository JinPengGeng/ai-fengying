# Redis 深入

## 数据结构

### 1. String

```bash
SET key value
GET key
INCR counter
DECR counter
APPEND key "suffix"
STRLEN key
```

### 2. Hash

```bash
HSET user:1 name "John"
HSET user:1 age 25
HGET user:1 name
HGETALL user:1
HDEL user:1 age
HKEYS user:1
HVALS user:1
```

### 3. List

```bash
LPUSH mylist "a"
RPUSH mylist "b"
LRANGE mylist 0 -1
LPOP mylist
RPOP mylist
LLEN mylist
```

### 4. Set

```bash
SADD tags "python"
SADD tags "redis"
SMEMBERS tags
SISMEMBER tags "python"
SREM tags "python"
SUNION tags1 tags2
```

### 5. Sorted Set

```bash
ZADD leaderboard 100 "player1"
ZADD leaderboard 200 "player2"
ZRANGE leaderboard 0 -1 WITHSCORES
ZINCRBY leaderboard 50 "player1"
ZRANK leaderboard "player1"
```

---

## 高级特性

### 6. 事务

```bash
MULTI
SET key1 value1
SET key2 value2
EXEC
```

### 7. 发布/订阅

```bash
SUBSCRIBE news
PUBLISH news "Breaking news!"
```

### 8. 管道

```bash
# 减少 RTT
redis-cli --pipe
```

---

## 让我变强的 Redis 技能

1. **数据结构** - String, Hash, List, Set, ZSet
2. **事务** - MULTI/EXEC
3. **发布订阅** - Pub/Sub
4. **管道** - 批量操作
5. **集群** - 主从、哨兵

---
