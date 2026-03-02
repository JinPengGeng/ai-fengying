# 前端工程化

## 构建工具

### 1. Vite

```bash
# 创建项目
npm create vite@latest my-app -- --template react

# 开发
npm run dev

# 构建
npm run build
```

### 2. 配置

```javascript
// vite.config.js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  },
  build: {
    outDir: 'dist',
    sourcemap: true
  }
})
```

---

## 代码规范

### 3. ESLint

```json
{
  "extends": ["eslint:recommended"],
  "rules": {
    "no-unused-vars": "error",
    "no-console": "warn"
  }
}
```

### 4. Prettier

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5"
}
```

---

## 让我变强的前端工程化技能

1. **Vite** - 快速构建
2. **ESLint** - 代码检查
3. **Prettier** - 代码格式化
4. **模块化** - ES Modules
5. **打包** - 构建优化

---
