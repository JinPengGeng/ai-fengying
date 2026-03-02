# Git 版本控制

## 基础概念

### 什么是 Git？

**Git** = 分布式版本控制系统
- 跟踪文件变化
- 多人协作
- 分支管理

---

## 常用命令

### 初始化与配置

```bash
# 初始化仓库
git init

# 配置
git config --global user.name "Name"
git config --global user.email "email"
```

### 基本操作

```bash
# 查看状态
git status

# 查看差异
git diff
git diff --staged

# 添加文件
git add <file>
git add .

# 提交
git commit -m "message"

# 查看日志
git log
git log --oneline
```

### 分支操作

```bash
# 创建分支
git branch <name>

# 切换分支
git checkout <name>
git switch <name>

# 创建并切换
git checkout -b <name>
git switch -c <name>

# 合并分支
git merge <branch>

# 删除分支
git branch -d <branch>
```

### 远程操作

```bash
# 克隆
git clone <url>

# 添加远程
git remote add origin <url>

# 拉取
git pull

# 推送
git push origin <branch>

# 获取
git fetch
```

---

## 协作流程

### 1. Feature Branch 工作流

```
master → develop → feature-xxx → develop → master
```

### 2. GitFlow

```
master → develop → release → master + develop
        ↑              ↓
      hotfix → master + develop
        ↑
      feature → develop
```

### 3. Pull Request

1. 创建分支
2. 修改代码
3. 推送分支
4. 创建 PR
5. 代码审查
6. 合并

---

## 高级技巧

### 1. 撤销操作

```bash
# 撤销未提交的修改
git checkout -- <file>
git restore <file>

# 撤销暂存
git reset HEAD <file>

# 撤销提交（保留修改）
git reset --soft HEAD~1

# 撤销提交（不保留修改）
git reset --hard HEAD~1
```

### 2. 储藏

```bash
# 储藏修改
git stash

# 储藏列表
git stash list

# 恢复储藏
git stash pop

# 删除储藏
git stash drop
```

### 3. 标签

```bash
# 创建标签
git tag v1.0.0

# 推送标签
git push origin v1.0.0
```

---

## 让我变强的 Git 技能

1. **日常操作**: add, commit, push, pull
2. **分支管理**: branch, checkout, merge
3. **协作**: PR, code review
4. **高级**: rebase, cherry-pick, bisect
