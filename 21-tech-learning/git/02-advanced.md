# Git 进阶与团队协作

## 分支管理策略

### 1. Git Flow

```
main (生产)
  ↑
  release/*
    ↑
  develop (开发)
    ↑
  feature/* (功能)
  hotfix/* (紧急修复)
```

```bash
# Git Flow 命令
# 初始化
git flow init

# 功能分支
git flow feature start login
git flow feature finish login

# 发布分支
git flow release start v1.0.0
git flow release finish v1.0.0

# 热修复
git flow hotfix start fix-login
git flow hotfix finish fix-login
```

### 2. Trunk-Based Development

```bash
# 特性开关
git checkout -b feature/new-login

# 开发完成后直接合并到 main
git checkout main
git merge --no-ff feature/new-login

# 短生命周期分支
git checkout -b feature/user-api
# 每天合并到 main
git merge main
# 完成后删除分支
git branch -d feature/user-api
```

---

## 高级命令

### 3. Rebase 与合并

```bash
# 变基 - 保持线性历史
git rebase main

# 交互式变基
git rebase -i HEAD~5

# 压缩合并
git merge --squash feature/login
git commit -m "Add login feature"

# 合并保留分支历史
git merge --no-ff feature/login
```

### 4. 储藏与清理

```bash
# 储藏
git stash push -m "WIP: login feature"
git stash list
git stash pop
git stash apply stash@{0}

# 清理
git clean -fd          # 未跟踪文件
git clean -n          # 预览
git reset --hard      # 放弃本地修改
```

---

## 高级技巧

### 5. 查找问题

```bash
# 二分查找 bug
git bisect start
git bisect bad
git bisect good v1.0.0
# 自动查找问题提交

# 查找修改
git log -p --all -S "function_name"
git log --oneline --graph --all

# 差异比较
git diff main..feature
git diff --stat
```

### 6. 子模块与子树

```bash
# 子模块
git submodule add https://github.com/user/repo.git libs/repo
git submodule update --init --recursive
git submodule foreach 'git status'

# 子树
git subtree add --prefix=libs/repo https://github.com/user/repo.git main --squash
git subtree pull --prefix=libs/repo https://github.com/user/repo.git main --squash
```

---

## 团队协作

### 7. 工作流

```bash
# Fork 工作流
# 1. Fork 仓库
# 2. Clone 自己 fork 的仓库
git clone https://github.com/your/repo.git
git remote add upstream https://github.com/original/repo.git

# 3. 创建功能分支
git checkout -b feature/new-feature

# 4. 保持与上游同步
git fetch upstream
git rebase upstream/main

# 5. Push 并创建 PR
git push origin feature/new-feature
```

### 8. Pull Request 最佳实践

```bash
# 保持提交整洁
git rebase -i HEAD~n

# 创建 PR
git push -u origin feature/new-feature

# 使用 GitHub CLI
gh pr create --title "Add login" --body "## Description"
gh pr review --approve
gh pr merge --squash
```

---

## 钩子与自动化

### 9. Git 钩子

```bash
# .git/hooks/pre-commit
#!/bin/sh

# 检查代码格式
npm run lint

# 检查测试
npm test

# 禁止提交 secret
git diff --cached -i | grep -q "API_KEY" && \
    echo "No API keys allowed" && exit 1
```

```bash
# commit-msg 钩子
#!/bin/sh
COMMIT_MSG=$(cat "$1")
PATTERN="^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+"

if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
    echo "Invalid commit message format"
    exit 1
fi
```

---

## 高级配置

### 10.  Alias 与配置

```bash
# ~/.gitconfig
[alias]
    # 日志
    lg = log --graph --oneline --decorate --all
    co = checkout
    br = branch
    st = status
    ci = commit
    
    # 高级
    undo = reset --soft HEAD~1
    amend = commit --amend --no-edit
    visual = log --graph --oneline --decorate
    
[core]
    autocrlf = input
    editor = vim
    
[pull]
    rebase = true
    
[push]
    default = current
```

---

## 让我变强的 Git 技能

1. **分支策略** - Git Flow、Trunk-Based
2. **历史管理** - Rebase、压缩合并
3. **问题查找** - Bisect、二分定位
4. **团队协作** - Fork、PR 工作流
5. **自动化** - 钩子、CI/CD 集成

---
