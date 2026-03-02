# LLM 微调技术

## 全参数微调

### LoRA (Low-Rank Adaptation)

**核心思想**: 在预训练权重旁边添加低秩矩阵

```
W' = W + ΔW = W + BA
B ∈ R^(d×r), A ∈ R^(r×k), r << min(d,k)
```

**优势**:
- 参数量减少 90%+
- 训练速度快 2-4x
- 可与原模型合并

**配置参数**:
- r (rank): 4-32
- alpha: r × scaling
- dropout: 0.05-0.1

### QLoRA
- 4-bit 量化 + LoRA
- 单卡微调 65B 模型
- DeepSpeed 集成

---

## 参数高效微调

### Adapter
- 在 Transformer 层插入小型网络
- 参数量: ~3% 原模型
- 可组合多任务

### Prefix Tuning
- 添加可学习前缀向量
- 冻结原模型
- 适合文本生成

### Prompt Tuning
- 软提示词
- 任务级别学习
- 适合少样本

---

## 训练技巧

### 数据构建
- 数据质量 > 数量
- 清洗噪声数据
- 合理分布比例

### 超参数
- 学习率: 1e-5 ~ 1e-4
- Batch size: 4-32
- Epochs: 2-5
- Warmup: 10% 步数

### 评估
- 困惑度 (PPL)
- 人工评估
- 特定任务指标
