# 云计算基础

## IaaS

### 1. 计算实例

```bash
# AWS EC2
aws ec2 run-instances \
    --image-id ami-0c55b159cbfafe1f0 \
    --instance-type t3.micro \
    --key-name my-key

# GCP
gcloud compute instances create my-instance \
    --machine-type=e2-micro \
    --image-family=debian-11

# Azure
az vm create \
    --resource-group mygroup \
    --name myvm \
    --image UbuntuLTS
```

---

## PaaS

### 2. 容器服务

```yaml
# Kubernetes Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: myapp:latest
        ports:
        - containerPort: 80
```

---

## Serverless

### 3. Lambda

```javascript
// AWS Lambda
exports.handler = async (event) => {
    return {
        statusCode: 200,
        body: JSON.stringify({
            message: 'Hello from Lambda!'
        })
    };
};
```

---

## 让我变强的云计算技能

1. **IaaS** - EC2, GCP, Azure
2. **PaaS** - Kubernetes, Cloud Run
3. **Serverless** - Lambda, Cloud Functions
4. **存储** - S3, Blob
5. **数据库** - RDS, Cloud SQL

---
