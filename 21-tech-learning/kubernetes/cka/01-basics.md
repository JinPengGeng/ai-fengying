# CKA 认证指南

## Kubernetes 核心概念

### 1. Pod 生命周期

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: main
    image: nginx
    ports:
    - containerPort: 80
    livenessProbe:
      httpGet:
        path: /healthz
        port: 80
      initialDelaySeconds: 10
      periodSeconds: 5
    readinessProbe:
      httpGet:
        path: /ready
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 3
```

### 2. Deployment 策略

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
```

---

## 网络

### 3. NetworkPolicy

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

---

## 存储

### 4. PersistentVolume

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
```

---

## 调度

### 5. 资源限制

```yaml
resources:
  requests:
    memory: "64Mi"
    cpu: "250m"
  limits:
    memory: "128Mi"
    cpu: "500m"
```

---

## 安全

### 6. RBAC

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
```

---

## 故障排查

### 7. 常用命令

```bash
# Pod 排查
kubectl describe pod <name>
kubectl logs <pod>
kubectl exec -it <pod> -- /bin/sh

# 节点排查
kubectl get nodes
kubectl describe node <node>

# 事件排查
kubectl get events --sort-by='.lastTimestamp'

# 资源状态
kubectl get all
kubectl api-resources
```

---

## 让我变强的 K8s 技能

1. **Pod** - 生命周期、健康检查
2. **Deployment** - 滚动更新
3. **网络** - NetworkPolicy
4. **存储** - PV/PVC
5. **安全** - RBAC

---
