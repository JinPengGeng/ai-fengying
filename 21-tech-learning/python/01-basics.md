# Python 基础速查

## 基础语法

### 变量与数据类型
```python
# 变量
name = "金鹏"           # 字符串
age = 25                # 整数
price = 19.99           # 浮点数
is_active = True        # 布尔值

# 数据结构
list = [1, 2, 3]        # 列表
dict = {"key": "value"} # 字典
tuple = (1, 2, 3)       # 元组
set = {1, 2, 3}        # 集合
```

### 条件与循环
```python
# 条件
if age >= 18:
    print("成年")
elif age >= 12:
    print("青少年")
else:
    print("未成年")

# 循环
for i in range(10):
    print(i)

while condition:
    print("循环中")
```

### 函数
```python
def greet(name):
    return f"你好，{name}!"

# 默认参数
def greet(name, greeting="你好"):
    return f"{greeting}，{name}!"
```

---

## 进阶特性

### 列表推导式
```python
# [表达式 for 变量 in 可迭代对象]
squares = [x**2 for x in range(10)]
```

### 字典操作
```python
dict = {"a": 1, "b": 2}

# 获取值
value = dict.get("a", 0)  # 不存在返回0

# 遍历
for key, value in dict.items():
    print(f"{key}: {value}")
```

### 函数式编程
```python
# map
result = map(lambda x: x*2, [1, 2, 3])

# filter
result = filter(lambda x: x > 0, [-1, 0, 1, 2])

# reduce
from functools import reduce
result = reduce(lambda x, y: x+y, [1, 2, 3])
```

---

## 常用库

| 库 | 用途 |
|----|------|
| **numpy** | 数值计算 |
| **pandas** | 数据分析 |
| **matplotlib** | 可视化 |
| **requests** | HTTP 请求 |
| **json** | JSON 处理 |
| **datetime** | 日期时间 |

---

## 让我变强的 Python 技能

1. **数据分析**: pandas + numpy
2. **可视化**: matplotlib + seaborn
3. **爬虫**: requests + beautifulsoup
4. **API**: FastAPI + Flask
5. **自动化**: 脚本 + 定时任务

---
