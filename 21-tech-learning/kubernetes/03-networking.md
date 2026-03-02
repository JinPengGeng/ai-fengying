# Kubernetes 网络进阶

## CNI 插件

| 插件 | 特点 |
|------|------|
| Calico | BGP 路由、网络策略 |
| Flannel | 简单、UDP/VXLAN |
| Cilium | eBPF、高性能 |
| Weave | 自动拓扑发现 |

---

## 网络模型

### Pod 网络
- 每个 Pod 唯一 IP
- 同节点 Pod 通过网桥通信
- 跨节点通过 CNI 路由

### Service
- ClusterIP: 集群内部访问
- NodePort: 节点端口
- LoadBalancer: 外部负载均衡
- ExternalName: DNS 别名

### Ingress
- HTTP/HTTPS 路由
- 基于路径/Host 转发
- TLS 终止
- 流量分割

---

## 网络策略

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-allow
spec:
  podSelector:
    matchLabels:
      app: api
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - protocol: TCP
          port: 8080
```

---

## Service Mesh

### Istio 架构
- Control Plane: Istiod
- Data Plane: Envoy Sidecar
- 流量管理、可观测性、安全

### 核心功能
- 智能路由 (金丝雀、镜像)
- mTLS 双向认证
- 流量监控
- 故障注入

---

## 网络调试

### 常用命令
```bash
# 查看 Pod 网络
kubectl exec -it <pod> -- sh

# 查看 Service 端点
kubectl get endpoints

# 检查 DNS
kubectl exec <pod> -- nslookup <service>

# 网络策略检查
kubectl get networkpolicies
```

### 常见问题
- DNS 解析失败
- 网络策略阻止
- CNI 配置错误
- 端口冲突
