# Docker 进阶与最佳实践

## Dockerfile 优化

### 1. 多阶段构建

```dockerfile
# 构建阶段
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

# 运行阶段
FROM node:18-alpine

WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

EXPOSE 3000
CMD ["node", "dist/index.js"]
```

### 2. 镜像优化技巧

```dockerfile
# ❌ 避免
RUN apt-get update
RUN apt-get install -y git
RUN apt-get clean

# ✅ 优化
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ❌ 避免 - 每层都复制
COPY . .
RUN npm install

# ✅ 优化 - 利用缓存
COPY package*.json ./
RUN npm ci
COPY . .
```

---

## Docker Compose

### 3. 编排多个服务

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgres://user:pass@db:5432/myapp
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis
    volumes:
      - ./src:/app/src
    networks:
      - backend

  db:
    image: postgres:15
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=myapp
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - backend

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    networks:
      - backend

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    depends_on:
      - app
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    networks:
      - backend

volumes:
  postgres_data:
  redis_data:

networks:
  backend:
    driver: bridge
```

---

## 网络配置

### 4. Docker 网络模式

```yaml
services:
  # 桥接网络（默认）
  app_bridge:
    networks:
      - my_network

  # 主机网络
  app_host:
    network_mode: host

  # 无网络
  app_none:
    network_mode: none
```

### 5. DNS 与服务发现

```yaml
services:
  web:
    hostname: my-web
    domainname: example.com
    dns:
      - 8.8.8.8
      - 8.8.4.4
```

---

## 存储管理

### 6. 持久化存储

```yaml
services:
  db:
    volumes:
      # 命名卷
      - db_data:/var/lib/postgresql/data
      
      # 绑定挂载（主机目录）
      - ./data:/app/data
      
      # 只读挂载
      - ./config:/app/config:ro
      
      # tmpfs（内存）
      - type: tmpfs
        target: /tmp

volumes:
  db_data:
    driver: local
```

---

## 安全最佳实践

### 7. 安全配置

```dockerfile
# 使用非 root 用户
FROM node:18-alpine

# 创建用户
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# 设置权限
COPY --chown=nextjs:nodejs . .

# 切换用户
USER nextjs

# 只读文件系统
security_opt:
  - no-new-privileges:true

# 资源限制
deploy:
  resources:
    limits:
      cpus: '0.5'
      memory: 512M
    reservations:
      cpus: '0.25'
      memory: 256M
```

### 8. Secrets 管理

```yaml
services:
  db:
    image: postgres:15
    secrets:
      - db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
# 或
#   external: true
```

---

## 健康检查

### 9. 健康检查配置

```yaml
services:
  web:
    image: nginx:alpine
    healthcheck:
      test: ["CMD", "wget", "-q", "--spider", "http://localhost/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  api:
    build: .
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 5s
      retries: 3
```

---

## 监控与日志

### 10. 日志配置

```yaml
services:
  app:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    
    # 或使用日志驱动
    # logging:
    #   driver: "syslog"
    #   options:
    #     syslog-address: "tcp://localhost:514"
```

---

## 让我变强的 Docker 技能

1. **镜像优化** - 多阶段构建、层缓存
2. **编排** - Docker Compose
3. **网络** - 隔离、服务发现
4. **存储** - 卷、绑定挂载
5. **安全** - 用户、Secrets、资源限制
6. **监控** - 健康检查、日志

---
