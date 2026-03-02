# 数据结构与算法

## 核心概念

### 时间复杂度

| 复杂度 | 名称 | 例子 |
|--------|------|------|
| O(1) | 常数 | 数组访问 |
| O(log n) | 对数 | 二分查找 |
| O(n) | 线性 | 遍历 |
| O(n log n) | 线性对数 | 快速排序 |
| O(n²) | 平方 | 冒泡排序 |
| O(2ⁿ) | 指数 | 递归斐波那契 |

### 空间复杂度

- 额外空间使用
- 递归栈空间
- 原地操作 vs 需要额外空间

---

## 常见数据结构

### 1. 数组/列表

| 操作 | 复杂度 |
|------|--------|
| 访问 | O(1) |
| 查找 | O(n) |
| 插入 | O(n) |
| 删除 | O(n) |

### 2. 哈希表

| 操作 | 复杂度 |
|------|--------|
| 访问 | - |
| 查找 | O(1) |
| 插入 | O(1) |
| 删除 | O(1) |

### 3. 栈/队列

| 操作 | 复杂度 |
|------|--------|
| push | O(1) |
| pop | O(1) |
| peek | O(1) |

### 4. 树

| 操作 | BST | 平衡树 |
|------|-----|--------|
| 查找 | O(n) | O(log n) |
| 插入 | O(n) | O(log n) |
| 删除 | O(n) | O(log n) |

### 5. 图

| 表示 | 空间 | 查找 |
|------|------|------|
| 邻接矩阵 | O(V²) | O(1) |
| 邻接表 | O(V+E) | O(V) |

---

## 常见算法

### 排序

| 算法 | 时间 | 空间 | 稳定 |
|------|------|------|------|
| 冒泡 | O(n²) | O(1) | ✅ |
| 选择 | O(n²) | O(1) | ❌ |
| 插入 | O(n²) | O(1) | ✅ |
| 快速 | O(n log n) | O(log n) | ❌ |
| 归并 | O(n log n) | O(n) | ✅ |
| 堆 | O(n log n) | O(1) | ❌ |

### 查找

| 算法 | 时间 | 条件 |
|------|------|------|
| 线性 | O(n) | 无序 |
| 二分 | O(log n) | 有序 |
| 哈希 | O(1) | 哈希表 |

### 搜索

| 算法 | 时间 | 空间 |
|------|------|------|
| BFS | O(V+E) | O(V) |
| DFS | O(V+E) | O(V) |

---

## 算法技巧

### 1. 双指针

```python
# 有序数组去重
def remove_duplicates(nums):
    slow = 0
    for fast in range(1, len(nums)):
        if nums[fast] != nums[slow]:
            slow += 1
            nums[slow] = nums[fast]
    return slow + 1
```

### 2. 滑动窗口

```python
# 最大子数组和
def max_subarray(nums, k):
    window = sum(nums[:k])
    max_sum = window
    for i in range(k, len(nums)):
        window += nums[i] - nums[i-k]
        max_sum = max(max_sum, window)
    return max_sum
```

### 3. 递归+记忆

```python
# 斐波那契（优化）
def fib(n, memo={}):
    if n in memo:
        return memo[n]
    if n <= 1:
        return n
    memo[n] = fib(n-1) + fib(n-2)
    return memo[n]
```

### 4. 分治

```python
# 归并排序
def merge_sort(arr):
    if len(arr) <= 1:
        return arr
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    return merge(left, right)
```

---

## 让我变强的算法练习

### 入门路径

1. 数组 → 字符串
2. 链表 → 树
3. 动态规划
4. 图算法

### 练习平台

| 平台 | 特点 |
|------|------|
| LeetCode | 最全 |
| 牛客网 | 面试 |
| Codeforces | 竞赛 |

---
