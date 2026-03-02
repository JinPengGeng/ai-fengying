# API 设计最佳实践

## RESTful API

### 1. 资源命名

```
# 正确
GET    /users              # 资源集合
GET    /users/{id}         # 单个资源
POST   /users              # 创建
PUT    /users/{id}         # 完整更新
PATCH  /users/{id}         # 部分更新
DELETE /users/{id}         # 删除

# 嵌套资源
GET    /users/{id}/orders
GET    /users/{id}/orders/{order_id}

# 动作
POST   /users/{id}/activate
POST   /users/{id}/deactivate
POST   /orders/{id}/cancel
```

### 2. 响应格式

```json
// 成功响应 (200)
{
  "data": {
    "id": "123",
    "name": "John",
    "email": "john@example.com"
  },
  "meta": {
    "timestamp": "2024-01-01T00:00:00Z"
  }
}

// 列表响应 (200)
{
  "data": [
    {"id": "1", "name": "User 1"},
    {"id": "2", "name": "User 2"}
  ],
  "meta": {
    "total": 100,
    "page": 1,
    "per_page": 20
  },
  "links": {
    "self": "/users?page=1",
    "next": "/users?page=2"
  }
}

// 错误响应 (4xx/5xx)
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [
      {"field": "email", "message": "Invalid format"}
    ]
  }
}
```

---

## GraphQL

### 3. Schema 定义

```graphql
type User {
  id: ID!
  name: String!
  email: String!
  posts: [Post!]!
  createdAt: DateTime!
}

type Post {
  id: ID!
  title: String!
  content: String!
  author: User!
  comments: [Comment!]!
  createdAt: DateTime!
}

type Query {
  user(id: ID!): User
  users(first: Int, after: String): UserConnection!
  post(id: ID!): Post
}

type Mutation {
  createUser(input: CreateUserInput!): User!
  updateUser(id: ID!, input: UpdateUserInput!): User!
  deleteUser(id: ID!): Boolean!
}

input CreateUserInput {
  name: String!
  email: String!
}
```

### 4. Resolver

```python
import graphene

class Query(graphene.ObjectType):
    user = graphene.Field(User, id=graphene.ID())
    users = graphene.List(User)
    
    def resolve_user(self, info, id):
        return get_user(id)
    
    def resolve_users(self, info):
        return get_all_users()

class Mutation(graphene.ObjectType):
    create_user = graphene.Field(User, input=graphene.Argument(CreateUserInput))
    
    def resolve_create_user(self, info, input):
        return create_user(**input)

schema = graphene.Schema(query=Query, mutation=Mutation)
```

---

## API 版本管理

### 5. 版本控制策略

```yaml
# URL 路径
GET /v1/users
GET /v2/users

# Header
GET /users
Accept: application/vnd.myapp.v1+json

# Query 参数
GET /users?version=1
```

---

## 认证与授权

### 6. JWT

```python
import jwt
from datetime import datetime, timedelta

SECRET_KEY = "your-secret-key"

def create_token(user_id):
    payload = {
        "user_id": user_id,
        "exp": datetime.utcnow() + timedelta(hours=24)
    }
    return jwt.encode(payload, SECRET_KEY, algorithm="HS256")

def verify_token(token):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        return payload["user_id"]
    except jwt.ExpiredSignatureError:
        return None
```

### 7. OAuth 2.0

```yaml
# Authorization Code Flow
# 1. 用户访问授权端点
GET /oauth/authorize?
  client_id=CLIENT_ID&
  redirect_uri=REDIRECT_URI&
  response_type=code&
  scope=read write

# 2. 授权后重定向
REDIRECT_URI?code=AUTHORIZATION_CODE

# 3. 交换 Token
POST /oauth/token
  grant_type=authorization_code&
  code=AUTHORIZATION_CODE&
  client_id=CLIENT_ID&
  client_secret=CLIENT_SECRET

# 4. 响应
{
  "access_token": "...",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

---

## 限流

### 8. 限流算法

```python
# 令牌桶
class TokenBucket:
    def __init__(self, rate, capacity):
        self.rate = rate
        self.capacity = capacity
        self.tokens = capacity
        self.last_update = time.time()
    
    def allow_request(self):
        now = time.time()
        # 添加令牌
        elapsed = now - self.last_update
        self.tokens = min(
            self.capacity,
            self.tokens + elapsed * self.rate
        )
        self.last_update = now
        
        if self.tokens >= 1:
            self.tokens -= 1
            return True
        return False

# 滑动窗口
class SlidingWindow:
    def __init__(self, max_requests, window_size):
        self.max_requests = max_requests
        self.window_size = window_size
        self.requests = []
    
    def allow_request(self):
        now = time.time()
        # 清理过期请求
        self.requests = [t for t in self.requests 
                        if t > now - self.window_size]
        
        if len(self.requests) < self.max_requests:
            self.requests.append(now)
            return True
        return False
```

---

## 让我变强的 API 技能

1. **RESTful** - 资源设计、版本
2. **GraphQL** - Schema、Resolver
3. **认证** - JWT、OAuth
4. **限流** - 令牌桶、滑动窗口
5. **文档** - OpenAPI、Swagger

---
