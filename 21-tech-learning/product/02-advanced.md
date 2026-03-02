# 产品设计基础

## 用户研究

### 1. 研究方法

| 方法 | 用途 | 成本 |
|------|------|------|
| 用户访谈 | 深度了解需求 | 中 |
| 问卷调查 | 定量分析 | 低 |
| 焦点小组 | 讨论碰撞 | 中 |
| 可用性测试 | 验证方案 | 中 |
| A/B 测试 | 数据决策 | 高 |

### 2. 用户画像

```markdown
## 用户画像 - 小明

### 基本信息
- 年龄: 28岁
- 职业: 产品经理
- 收入: 15K/月

### 目标
- 提升工作效率
- 减少重复劳动

### 痛点
- 手动整理数据耗时
- 多工具切换麻烦

### 行为
- 每天 9-19 点工作
- 常用工具: Excel, Slack, Notion
```

---

## 需求分析

### 3. 需求优先级

```python
# RICE 评分
def rice_score(reach, impact, confidence, effort):
    return (reach * impact * confidence) / effort

# 示例
feature = {
    "reach": 10000,      # 每月影响用户数
    "impact": 0.8,       # 影响程度 (0.25-2)
    "confidence": 0.8,   # 置信度 %
    "effort": 5          # 人周
}

score = rice_score(**feature)
print(f"RICE Score: {score}")  # 128
```

### 4. User Story

```markdown
# 格式
作为 [角色]，我希望 [功能]，以便 [价值]

# 示例
作为 运营人员，
我希望 批量导入用户数据，
以便 减少手动录入时间

# 验收标准
- [ ] 支持 CSV 格式
- [ ] 最大支持 10000 条
- [ ] 导入进度可视化
- [ ] 错误提示清晰
```

---

## 交互设计

### 5. 设计原则

| 原则 | 说明 |
|------|------|
| **一致性** | 相似场景相同处理 |
| **反馈** | 操作后及时反馈 |
| **约束** | 限制用户操作范围 |
| **映射** | 操作与结果对应 |
| **容错** | 允许错误、易于恢复 |

### 6. 组件状态

```css
/* 按钮状态 */
.btn {
  background: #007bff;
}

.btn:hover {
  background: #0056b3;
}

.btn:active {
  background: #004085;
  transform: scale(0.98);
}

.btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}

/* 输入框状态 */
.input:focus {
  border-color: #007bff;
  box-shadow: 0 0 0 3px rgba(0,123,255,0.25);
}

.input:invalid {
  border-color: #dc3545;
}
```

---

## 数据分析

### 7. 关键指标

| 指标 | 公式 | 意义 |
|------|------|------|
| DAU | 日活跃用户 | 产品健康 |
| MAU | 月活跃用户 | 市场规模 |
| 留存率 | 次日/7日/30日 | 用户粘性 |
| 转化率 | 目标用户/总用户 | 漏斗效率 |
| ARPU | 收入/用户 | 变现能力 |

### 8. 漏斗分析

```python
# 漏斗分析
def funnel_analysis(events, steps):
    """
    events: 用户事件列表
    steps: 步骤列表
    """
    funnel = {}
    
    for step in steps:
        users = set()
        for event in events:
            if event['action'] == step:
                users.add(event['user_id'])
        
        funnel[step] = len(users)
    
    # 计算转化率
    conversion = {}
    for i, step in enumerate(steps):
        if i == 0:
            conversion[step] = 100
        else:
            prev = funnel[steps[i-1]]
            curr = funnel[step]
            conversion[step] = (curr / prev) * 100 if prev > 0 else 0
    
    return funnel, conversion
```

---

## 产品策略

### 9. MVP 设计

```
MVP = 最小可行产品

核心原则:
1. 只做核心功能
2. 快速验证假设
3. 收集反馈迭代

验证方法:
- 冒烟测试
- 灰度发布
- 快速迭代
```

### 10. 增长模型

```python
# AARRR 模型
def aarrr_analysis(acquisition, activation, retention, referral, revenue):
    return {
        "Acquisition": acquisition,      # 获取
        "Activation": activation,        # 激活
        "Retention": retention,          # 留存
        "Referral": referral,            # 推荐
        "Revenue": revenue              # 收入
    }

# Pirate Metrics
# AARRR = Acquisition, Activation, Retention, Referral, Revenue
```

---

## 让我变强的产品技能

1. **用户研究** - 访谈、问卷、测试
2. **需求分析** - 优先级、User Story
3. **交互设计** - 原则、组件
4. **数据分析** - 指标、漏斗
5. **产品策略** - MVP、增长

---
