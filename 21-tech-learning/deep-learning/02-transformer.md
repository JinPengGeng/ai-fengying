# Transformer 架构详解

## 核心组件

### 多头注意力 (Multi-Head Attention)

```python
class MultiHeadAttention(nn.Module):
    def __init__(self, d_model, num_heads):
        self.d_model = d_model
        self.num_heads = num_heads
        self.d_k = d_model // num_heads
        
        self.W_q = nn.Linear(d_model, d_model)
        self.W_k = nn.Linear(d_model, d_model)
        self.W_v = nn.Linear(d_model, d_model)
        self.W_o = nn.Linear(d_model, d_model)
    
    def forward(self, Q, K, V, mask=None):
        # 1. 线性投影并分头
        Q = self.split_heads(self.W_q(Q))
        K = self.split_heads(self.W_k(K))
        V = self.split_heads(self.W_v(V))
        
        # 2. 缩放点积注意力
        scores = torch.matmul(Q, K.transpose(-2, -1)) / math.sqrt(self.d_k)
        if mask is not None:
            scores = scores.masked_fill(mask == 0, -1e9)
        attn = softmax(scores, dim=-1)
        
        # 3. 拼接输出
        output = torch.matmul(attn, V)
        output = self.merge_heads(output)
        return self.W_o(output)
```

### 前馈网络 (FFN)
```python
class FeedForward(nn.Module):
    def __init__(self, d_model, d_ff, dropout=0.1):
        self.linear1 = nn.Linear(d_model, d_ff)
        self.linear2 = nn.Linear(d_ff, d_model)
        self.dropout = nn.Dropout(dropout)
    
    def forward(self, x):
        return self.linear2(self.dropout(F.relu(self.linear1(x))))
```

---

## 位置编码

### 正弦/余弦编码
```python
def positional_encoding(d_model, max_len):
    pe = torch.zeros(max_len, d_model)
    position = torch.arange(0, max_len).unsqueeze(1)
    div_term = torch.exp(torch.arange(0, d_model, 2) * (-math.log(10000.0) / d_model))
    pe[:, 0::2] = torch.sin(position * div_term)
    pe[:, 1::2] = torch.cos(position * div_term)
    return pe
```

### 可学习位置编码
- BERT 使用
- 优点: 灵活
- 缺点: 需更多数据

---

## 训练技巧

### 标签平滑
```python
loss = CrossEntropyLoss(label_smoothing=0.1)
```

### 梯度裁剪
```python
torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)
```

### 学习率调度
- Warmup
- Cosine Decay
- Polynomial Decay

---

## 变体与进化

| 模型 | 特点 |
|------|------|
| BERT | 双向 Encoder |
| GPT | 单向 Decoder |
| T5 | Encoder-Decoder |
| ViT | 图像 Transformer |
| Swin | 层级 Transformer |
| LLM | 大规模预训练 |
