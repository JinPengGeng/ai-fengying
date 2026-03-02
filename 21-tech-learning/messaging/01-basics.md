# 消息队列深入

## RabbitMQ

### 1. 基本概念

| 概念 | 说明 |
|------|------|
| Exchange | 交换机 |
| Queue | 队列 |
| Binding | 绑定 |
| Message | 消息 |

### 2. 交换机类型

```python
import pika

connection = pika.BlockingConnection(
    pika.ConnectionParameters('localhost')
)
channel = connection.channel()

# 声明交换机
channel.exchange_declare(
    exchange='my_exchange',
    exchange_type='direct'  # direct, topic, fanout, headers
)

# 声明队列
channel.queue_declare(queue='my_queue', durable=True)

# 绑定
channel.queue_bind(
    exchange='my_exchange',
    queue='my_queue',
    routing_key='my_key'
)
```

---

## Kafka

### 3. 生产者

```python
from kafka import KafkaProducer
import json

producer = KafkaProducer(
    bootstrap_servers=['localhost:9092'],
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

producer.send(
    'my-topic',
    {'key': 'value'}
)
producer.flush()
```

### 4. 消费者

```python
from kafka import KafkaConsumer

consumer = KafkaConsumer(
    'my-topic',
    bootstrap_servers=['localhost:9092'],
    group_id='my-group',
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

for message in consumer:
    print(message.value)
```

---

## Redis 消息队列

### 5. List 实现

```python
import redis

r = redis.Redis()

# 生产者
r.lpush('queue', 'message1')
r.lpush('queue', 'message2')

# 消费者
while True:
    message = r.brpop('queue', timeout=5)
    if message:
        print(message)
```

---

## 消息模式

### 6. 工作队列

```python
# 公平分发
channel.basic_qos(prefetch_count=1)

def callback(ch, method, properties, body):
    process_message(body)
    ch.basic_ack(delivery_tag=method.delivery_tag)

channel.basic_consume(queue='task_queue', on_message_callback=callback)
```

### 7. 发布/订阅

```python
# 发布者
channel.basic_publish(
    exchange='',
    routing_key='logs',
    body='log message'
)

# 订阅者
def callback(ch, method, properties, body):
    print(body)

channel.basic_consume(
    queue='logs',
    on_message_callback=callback
)
```

---

## 让我变强的消息队列技能

1. **RabbitMQ** - 交换机、队列
2. **Kafka** - 分区、偏移量
3. **Redis** - List 实现
4. **模式** - 工作队列、Pub/Sub
5. **可靠性** - 确认、持久化

---
