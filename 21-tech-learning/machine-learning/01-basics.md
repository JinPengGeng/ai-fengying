# 机器学习基础

## 监督学习

### 1. 线性回归

```python
import numpy as np
from sklearn.linear_model import LinearRegression

X = np.array([[1], [2], [3], [4], [5]])
y = np.array([2, 4, 6, 8, 10])

model = LinearRegression()
model.fit(X, y)

print(model.coef_)  # [2.]
print(model.intercept_)  # 0.
print(model.predict([[6]]))  # [12.]
```

### 2. 逻辑回归

```python
from sklearn.linear_model import LogisticRegression

X = np.array([[0], [1], [2], [3], [4]])
y = np.array([0, 0, 0, 1, 1])

model = LogisticRegression()
model.fit(X, y)

print(model.predict([[2.5]]))  # [0]
```

---

## 无监督学习

### 3. K-Means

```python
from sklearn.cluster import KMeans

X = np.array([[1, 2], [1, 4], [1, 0],
              [10, 2], [10, 4], [10, 0]])

model = KMeans(n_clusters=2)
model.fit(X)

print(model.labels_)  # [0, 0, 0, 1, 1, 1]
print(model.cluster_centers_)
```

---

## 模型评估

### 4. 指标

```python
from sklearn.metrics import (
    accuracy_score,
    precision_score,
    recall_score,
    f1_score,
    confusion_matrix
)

y_true = [0, 1, 0, 1]
y_pred = [0, 0, 1, 1]

print(accuracy_score(y_true, y_pred))
print(precision_score(y_true, y_pred))
print(recall_score(y_true, y_pred))
print(f1_score(y_true, y_pred))
print(confusion_matrix(y_true, y_pred))
```

---

## 让我变强的 ML 技能

1. **监督学习** - 回归、分类
2. **无监督学习** - 聚类
3. **评估** - 准确率、精确率、召回率
4. **特征工程** - 标准化、编码
5. **scikit-learn** - 常用算法库

---
