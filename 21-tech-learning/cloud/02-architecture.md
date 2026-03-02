# 云原生架构

## 微服务设计

### 服务拆分
- 按业务能力
- 按领域驱动设计 (DDD)
- 避免过度拆分

### 通信模式
| 模式 | 场景 |
|------|------|
| REST | 同步调用 |
| gRPC | 高性能 |
| 消息队列 | 异步 |
| GraphQL | 前端聚合 |

---

## 服务网格

### Istio 进阶

```yaml
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: my-service
spec:
  hosts:
    - my-service
  http:
    - match:
        - headers:
            x-canary:
              exact: "true"
      route:
        - destination:
            host: my-service
            subset: v2
          weight: 100
    - route:
        - destination:
            host: my-service
            subset: v1
          weight: 100
```

### 流量管理
- 金丝雀发布
- A/B 测试
- 镜像流量
- 超时/重试策略

---

## 可观测性

### 日志
- 结构化日志 (JSON)
- 集中收集 (ELK, Loki)
- 日志级别管理

### 指标
- RED 方法
  - Rate: 请求率
  - Errors: 错误率
  - Duration: 延迟
- USE 方法
  - Utilization: 利用率
  - Saturation: 饱和度
  - Errors: 错误

### 追踪
- OpenTelemetry
- Jaeger / Zipkin

---

## 基础设施即代码

### Terraform
```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"
  
  tags = {
    Name = "web-server"
  }
}
```

### Ansible
```yaml
- name: Setup Nginx
  yum:
    name: nginx
    state: present
  service:
    name: nginx
    enabled: true
```
