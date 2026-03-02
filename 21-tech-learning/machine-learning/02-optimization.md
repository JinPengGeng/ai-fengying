# 机器学习进阶

## 损失函数

### 分类损失
| 损失函数 | 公式 | 特点 |
|----------|------|------|
| Cross Entropy | -∑y log(ŷ) | 最常用 |
| Focal Loss | -(1-ŷ)^γ log(ŷ) | 难样本 |
| Label Smoothing | CE + 平滑 | 防过拟合 |

### 回归损失
| 损失函数 | 公式 | 特点 |
|----------|------|------|
| MSE | (y-ŷ)² | 敏感异常值 |
| MAE | |y-ŷ| | 鲁棒 |
| Huber | MSE/MAE混合 | 平衡 |
| Smooth L1 | 平滑MAE | 快速训练 |

---

## 优化器

### SGD 系列
```python
# SGD
optimizer = torch.optim.SGD(model.parameters(), lr=0.01, momentum=0.9)

# Adam (自适应)
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

# AdamW (权重衰减)
optimizer = torch.optim.AdamW(model.parameters(), lr=0.001, weight_decay=0.01)
```

### 学习率调度
```python
# Step LR
scheduler = StepLR(optimizer, step_size=10, gamma=0.1)

# Cosine Annealing
scheduler = CosineAnnealingLR(optimizer, T_max=50)

# Warmup + Cosine
scheduler = CosineAnnealingWarmRestarts(...)
```

---

## 正则化

### L1/L2
```python
# L2 (权重衰减)
optimizer = Adam(model.parameters(), weight_decay=0.01)

# L1
l1_loss = torch.abs(model.weight).sum()
loss = mse_loss + 0.01 * l1_loss
```

### Dropout
```python
# 训练时随机丢弃
model = nn.Sequential(
    nn.Linear(256, 128),
    nn.Dropout(0.5),
    nn.ReLU(),
    nn.Linear(128, 10)
)
```

### 早停 (Early Stopping)
- 验证集 loss 上升时停止
- 保存最佳模型

---

## 评估指标

### 分类
- Accuracy, Precision, Recall
- F1-Score
- AUC-ROC

### 回归
- RMSE, MAE
- R² Score
- MAPE
