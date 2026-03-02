# GitHub Actions CI/CD

## 基础配置

### 1. 工作流文件

```yaml
name: CI Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run linter
      run: npm run lint
    
    - name: Run tests
      run: npm test
```

### 2. 构建 Job

```yaml
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Build
      run: npm run build
    
    - name: Upload artifact
      uses: actions/upload-artifact@v4
      with:
        name: build-output
        path: dist/
```

---

## 测试

### 3. 测试矩阵

```yaml
jobs:
  test:
    strategy:
      matrix:
        node-version: [18, 20, 22]
        os: [ubuntu-latest, windows-latest]
    
    runs-on: ${{ matrix.os }}
    
    steps:
    - uses: actions/checkout@v4
    - uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node-version }}
    - run: npm ci
    - run: npm test
```

### 4. 覆盖率

```yaml
    - name: Test with coverage
      run: npm test -- --coverage
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        token: ${{ secrets.CODECOV_TOKEN }}
```

---

## 部署

### 5. AWS 部署

```yaml
  deploy:
    needs: build
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v4
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-east-1
    
    - name: Deploy to S3
      run: |
        aws s3 sync dist/ s3://my-bucket --delete
```

### 6. Docker 部署

```yaml
  build-and-push:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3
    
    - name: Login to Docker Hub
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}
    
    - name: Build and push
      uses: docker/build-push-action@v5
      with:
        context: .
        push: true
        tags: user/app:latest
```

---

## 高级特性

### 7. 缓存

```yaml
    - name: Cache node modules
      uses: actions/cache@v4
      with:
        path: ~/.npm
        key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
        restore-keys: |
          ${{ runner.os }}-npm-
```

### 8. 环境

```yaml
deploy:
  needs: test
  runs-on: ubuntu-latest
  environment: production
  if: github.ref == 'refs/heads/main'
  
  steps:
  - name: Deploy
    run: echo "Deploying to production"
```

---

## 让我变强的 CI/CD 技能

1. **工作流** - GitHub Actions 语法
2. **测试** - 矩阵测试、覆盖率
3. **部署** - AWS、Docker
4. **缓存** - 依赖缓存
5. **环境** - 开发/测试/生产

---
