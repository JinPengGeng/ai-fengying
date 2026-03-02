# Docker 容器化

## 核心概念

### 什么是 Docker？

**Docker** = 容器化平台
- 轻量级虚拟化
- 快速部署
- 环境一致性

---

## 基础命令

### 镜像操作

```bash
# 搜索镜像
docker search nginx

# 拉取镜像
docker pull nginx:latest

# 列出镜像
docker images

# 删除镜像
docker rmi nginx
```

### 容器操作

```bash
# 运行容器
docker run -d -p 80:80 nginx

# 列出容器
docker ps
docker ps -a

# 停止/启动
docker stop <id>
docker start <id>

# 删除容器
docker rm <id>

# 查看日志
docker logs <id>

# 进入容器
docker exec -it <id> bash
```

---

## Dockerfile

### 基础结构

```dockerfile
# 基础镜像
FROM python:3.9

# 工作目录
WORKDIR /app

# 复制文件
COPY requirements.txt .

# 安装依赖
RUN pip install -r requirements.txt

# 复制代码
COPY . .

# 暴露端口
EXPOSE 8080

# 启动命令
CMD ["python", "main.py"]
```

### 常用指令

| 指令 | 说明 |
|------|------|
| FROM | 基础镜像 |
| RUN | 执行命令 |
| COPY | 复制文件 |
| WORKDIR | 工作目录 |
| EXPOSE | 暴露端口 |
| CMD | 启动命令 |
| ENV | 环境变量 |

---

## Docker Compose

### 编排多容器

```yaml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "80:80"
    depends_on:
      - db
  db:
    image: postgres
    volumes:
      - db-data:/var/lib/postgresql/data
volumes:
  db-data:
```

### 命令

```bash
# 启动
docker-compose up -d

# 停止
docker-compose down

# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

---

## 让我变强的 Docker 技能

### 基础
- [x] 镜像操作
- [x] 容器管理
- [x] Dockerfile

### 进阶
- [ ] Docker Compose
- [ ] 网络配置
- [ ] 数据卷
- [ ] 集群编排

---

## 使用场景

| 场景 | 用途 |
|------|------|
| 开发环境 | 一键启动 |
| 测试环境 | 隔离测试 |
| 生产部署 | 快速部署 |
| 微服务 | 服务编排 |
