# 安全指南

## Git 敏感信息保护配置

本项目已配置以下安全措施来保护敏感信息：

### 1. Pre-commit Hook - 提交前检查

位置：[.git/hooks/pre-commit](.git/hooks/pre-commit)

功能：
- 在每次提交前自动扫描代码中的敏感信息
- 检测 API 密钥、密码、数据库连接字符串等
- 如果发现敏感信息，阻止提交并提示

检查内容：
- API Keys 和 Secrets
- 密码和认证令牌
- 数据库连接字符串 (MongoDB, PostgreSQL, MySQL, Redis)
- AWS 访问密钥
- GitHub 令牌
- 私钥文件
- 信用卡号

### 2. Git 过滤器 - 自动隐藏敏感信息

配置位置：[.git/config](.git/config)

功能：
- 提交时自动隐藏敏感信息值
- 检出时恢复原始内容

支持的文件类型：
- `.env` 文件
- `.env.*` 文件
- `*.secret` 文件
- `secrets/` 目录
- `credentials.json`
- `config.local.*` 文件

### 3. Git 忽略配置

位置：[.gitignore](.gitignore)

已配置的忽略规则：
```
.env
.env.*
*.pem
*.key
id_rsa*
id_ed25519*
credentials.json
secrets/
```

### 4. Git 属性配置

位置：[.gitattributes](.gitattributes)

配置：
- 敏感文件使用 `hide-secrets` 过滤器
- 密钥文件标记为二进制
- 脚本文件使用 LF 行尾

## 使用方法

### 设置环境变量

1. 复制模板文件：
   ```bash
   cp .env.example .env
   ```

2. 编辑 `.env` 文件，填入实际值：
   ```bash
   nano .env
   ```

3. `.env` 文件不会被提交到 Git

### 提交代码

正常提交即可，pre-commit hook 会自动检查：
```bash
git add .
git commit -m "your message"
```

如果检测到敏感信息，提交会被阻止，并显示详细信息。

### 强制提交（不推荐）

如果确定要提交（例如误报）：
```bash
git commit --no-verify
```

## 最佳实践

1. **永远不要提交敏感信息**
   - 使用 `.env` 文件存储敏感信息
   - 使用环境变量
   - 使用密钥管理服务

2. **定期审查**
   - 使用 `git-secrets` 等工具进行额外检查
   - 定期审查提交历史

3. **如果意外提交了敏感信息**
   - 立即撤销密钥/密码
   - 使用 `git filter-branch` 或 BFG Repo-Cleaner 清理历史
   - 轮换所有暴露的凭证

## 扩展配置

### 安装 git-secrets（可选）

```bash
# macOS
brew install git-secrets

# 初始化
git secrets --install
git secrets --register-aws
```

### 添加自定义模式

编辑 `.git/hooks/pre-commit`，在 `PATTERNS` 数组中添加新的正则表达式。

## 注意事项

- Pre-commit hook 是本地配置，需要每个开发者都配置
- 考虑在 CI/CD 中添加额外的敏感信息扫描
- 定期更新敏感信息模式以应对新的威胁
