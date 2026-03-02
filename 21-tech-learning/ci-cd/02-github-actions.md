# GitHub Actions 进阶

## 工作流语法

```yaml
name: CI Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Build
        run: npm run build
      
      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: build
          path: dist/
```

---

## 矩阵构建

```yaml
jobs:
  test:
    strategy:
      matrix:
        node: [16, 18, 20]
        os: [ubuntu-latest, windows-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node }}
```

---

## 缓存策略

```yaml
- name: Cache npm
  uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-npm-
```

---

## 部署策略

### 手动审批
```yaml
deploy:
  needs: build
  runs-on: ubuntu-latest
  environment: production
  steps:
    - run: echo "Deploying..."
```

### 条件部署
```yaml
- name: Deploy
  if: github.ref == 'refs/heads/main'
  run: ./deploy.sh
```

---

## 自定义 Action

```yaml
# action.yml
name: 'My Action'
description: 'Does something useful'
inputs:
  my-input:
    description: 'Input description'
    required: true
outputs:
  my-output:
    description: 'Output description'
runs:
  using: composite
  steps:
    - shell: bash
      run: echo "Hello ${{ inputs.my-input }}"
```
