# DevOps 实践

## CI/CD 流水线

### 1. 完整流水线

```yaml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - npm ci
    - npm run build
  artifacts:
    paths:
      - dist/

test:
  stage: test
  script:
    - npm test
    - npm run lint
  coverage: '/Coverage: \d+\.\d+%/'

deploy:
  stage: deploy
  script:
    - ./deploy.sh
  only:
    - main
```

---

## 监控

### 2. Prometheus + Grafana

```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']
```

---

## 日志

### 3. ELK Stack

```
应用 → Filebeat → Logstash → Elasticsearch ← Kibana
```

---

## 让我变强的 DevOps 技能

1. **CI/CD** - GitLab CI, GitHub Actions
2. **监控** - Prometheus, Grafana
3. **日志** - ELK Stack
4. **容器** - Docker, Kubernetes
5. **基础设施** - Terraform

---
