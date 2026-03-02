# Git 高级技巧

## 变基 (Rebase) 精讲

### 基础变基
```bash
# 整理提交历史
git rebase -i HEAD~3

# 变基到主分支
git rebase main
```

### 交互式变基
```
pick a1b2c3d 添加功能A
pick e5f6g7h 修复Bug
pick i9j0k1l 优化代码

# 命令:
# p - 保留
# r - 修改提交信息
# e - 暂停修改
# s - 合并到前一个提交
# d - 删除提交
```

---

## 子模块与子树

### 子模块 (Submodule)
```bash
# 添加子模块
git submodule add https://github.com/user/repo path

# 克隆含子模块的仓库
git clone --recurse-submodules <repo>

# 更新子模块
git submodule update --remote
```

### 子树 (Subtree)
```bash
# 添加子树
git subtree add --prefix=path https://github.com/user/repo main

# 拉取更新
git subtree pull --prefix=path https://github.com/user/repo main
```

---

## 高级操作

### 恢复误删分支
```bash
# 查找 dangling commit
git reflog
git checkout -b <branch-name> <commit>
```

### 清理大文件
```bash
# 查找大文件
git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | sed -n 's/^blob //p' | sort -rnk2 | head

# 删除历史中的文件
git filter-branch --tree-filter 'rm -f large-file.zip' HEAD
# 或使用 BFG Repo-Cleaner
```

### Bisect 二分查找
```bash
git bisect start
git bisect bad  # 当前版本有问题
git bisect good v1.0  # 好的版本
# 自动二分查找问题提交
```

---

## 工作流

### Git Flow
- main: 生产环境
- develop: 开发分支
- feature/*: 功能分支
- release/*: 发布准备
- hotfix/*: 紧急修复

### Trunk-Based Development
- 主干开发
- 短生命周期分支
- 持续集成
