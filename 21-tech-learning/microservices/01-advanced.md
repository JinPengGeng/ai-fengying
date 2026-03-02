# 微服务架构深入

## 服务拆分

### 1. 拆分策略

| 策略 | 说明 | 适用场景 |
|------|------|----------|
| **业务功能** | 按业务能力拆分 | 业务清晰 |
| **领域驱动** | 按领域模型拆分 | 复杂业务 |
| **BFF** | 前端适配层 | 多端服务 |
| **事件驱动** | 按事件流拆分 | 实时系统 |

### 2. 拆分原则

```
高内聚低耦合
    ↓
单一职责
    ↓
边界清晰
    ↓
数据私有
    ↓
API 优先
```

---

## 服务通信

### 3. 同步通信 (REST/gRPC)

```python
# REST 客户端
import requests

class UserServiceClient:
    def __init__(self, base_url):
        self.base_url = base_url
    
    def get_user(self, user_id):
        response = requests.get(f"{self.base_url}/users/{user_id}")
        return response.json()
    
    def create_user(self, user_data):
        response = requests.post(
            f"{self.base_url}/users",
            json=user_data
        )
        return response.json()

# gRPC（概念）
# proto 文件
syntax = "proto3";

service UserService {
    rpc GetUser (UserRequest) returns (User);
    rpc CreateUser (User) returns (User);
}

message UserRequest {
    string user_id = 1;
}
```

### 4. 异步通信 (消息队列)

```python
# RabbitMQ 生产者
import pika

connection = pika.BlockingConnection(
    pika.ConnectionParameters('localhost')
)
channel = connection.channel()

channel.queue_declare(queue='orders', durable=True)

def publish_order(order_data):
    channel.basic_publish(
        exchange='',
        routing_key='orders',
        body=json.dumps(order_data),
        properties=pika.BasicProperties(
            delivery_mode=2  # 持久化
        )
    )

# 消费者
def callback(ch, method, properties, body):
    order = json.loads(body)
    process_order(order)
    ch.basic_ack(delivery_tag=method.delivery_tag)

channel.basic_qos(prefetch_count=1)
channel.basic_consume(queue='orders', on_message_callback=callback)
```

---

## 服务治理

### 5. 负载均衡

```yaml
# Kubernetes Service
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 8080
```

| 策略 | 说明 |
|------|------|
| **Round Robin** | 轮询 |
| **Least Connections** | 最少连接 |
| **Weighted** | 加权 |
| **IP Hash** | 来源IP固定 |

### 6. 熔断器

```python
from pybreaker import CircuitBreaker

# 配置熔断器
breaker = CircuitBreaker(
    fail_max=5,        # 失败5次后熔断
    reset_timeout=60    # 60秒后恢复
)

@breaker
def call_service(service_func):
    return service_func()

# 使用
for i in range(10):
    try:
        result = call_service(lambda: external_api())
    except CircuitBreakerError:
        print("服务熔断，等待恢复...")
        time.sleep(10)
```

### 7. 限流

```python
from time import time
from collections import deque

class RateLimiter:
    def __init__(self, max_requests, window_seconds):
        self.max_requests = max_requests
        self.window_seconds = window_seconds
        self.requests = deque()
    
    def is_allowed(self):
        now = time()
        # 清理过期请求
        while self.requests and self.requests[0] < now - self.window_seconds:
            self.requests.popleft()
        
        if len(self.requests) < self.max_requests:
            self.requests.append(now)
            return True
        return False

# 令牌桶算法
class TokenBucket:
    def __init__(self, rate, capacity):
        self.rate = rate
        self.capacity = capacity
        self.tokens = capacity
        self.last_time = time()
    
    def allow(self):
        now = time()
        # 添加令牌
        self.tokens = min(
            self.capacity,
            self.tokens + (now - self.last_time) * self.rate
        )
        self.last_time = now
        
        if self.tokens >= 1:
            self.tokens -= 1
            return True
        return False
```

---

## 服务发现

### 8. Consul/Etcd

```python
import etcd3

# 服务注册
client = etcd3.client()
client.put('/services/my-app/192.168.1.1:8080', '{"port": 8080}')

# 服务发现
events, cancel = client.watch('/services/my-app/')
for event in events:
    print(event.value)

# 获取所有服务
_, servers = client.get_prefix('/services/my-app/')
for server in servers:
    print(server.key, server.value)
```

---

## 分布式事务

### 9. Saga 模式

```python
# 编排式 Saga
class OrderSaga:
    def __init__(self):
        self.steps = [
            self.create_order,
            self.reserve_inventory,
            self.process_payment,
            self.ship_order
        ]
    
    async def execute(self, order_data):
        completed_steps = []
        
        for step in self.steps:
            try:
                await step(order_data)
                completed_steps.append(step)
            except Exception as e:
                # 补偿已完成的步骤
                await self.compensate(completed_steps, order_data)
                raise e
    
    async def compensate(self, steps, order_data):
        # 逆序补偿
        for step in reversed(steps):
            compensate_fn = getattr(self, f"compensate_{step.__name__}")
            await compensate_fn(order_data)
```

---

## 让我变强的微服务技能

1. **服务拆分** - 领域驱动设计
2. **通信模式** - 同步/异步
3. **服务治理** - 熔断、限流、降级
4. **分布式事务** - Saga、Seata
5. **可观测性** - 链路追踪、日志聚合

---
