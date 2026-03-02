# Docker 安全最佳实践

## 镜像安全

### 最小化镜像
- 使用 Alpine 基础镜像
- 多阶段构建
- 删除不必要的工具

```dockerfile
# 多阶段构建示例
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
USER node
```

### 安全扫描
- Trivy
- Clair
- Docker Scout

---

## 运行时安全

### 资源限制
```yaml
resources:
  limits:
    memory: "256Mi"
    cpu: "500m"
  requests:
    memory: "128Mi"
    cpu: "250m"
```

### 安全上下文
```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  readOnlyRootFilesystem: true
  capabilities:
    drop:
      - ALL
```

### 网络隔离
- 网络命名空间
- 禁用 host 网络模式
- 使用自定义网络

---

## 密钥管理

### Docker Secrets
```bash
# 创建密钥
docker secret create my_secret ./secret.txt

# 使用
services:
  app:
    secrets:
      - my_secret
```

### 外部密钥
- HashiCorp Vault
- AWS Secrets Manager
- Kubernetes Secrets

---

## 常见漏洞防御

| 威胁 | 防护措施 |
|------|----------|
| 权限提升 | 非 root 用户运行 |
| 敏感信息泄露 | 密钥管理、不打包 secrets |
| 镜像篡改 | 签名验证、只读挂载 |
| 容器逃逸 | 限制 capabilities、AppArmor |
