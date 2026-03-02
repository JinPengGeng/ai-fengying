# AI Agent 架构模式

## ReAct 模式

### 核心思想
- Reasoning (推理): 思考下一步行动
- Acting (行动): 执行工具调用
- 交替进行直到完成任务

### 实现框架
```python
class ReActAgent:
    def run(self, task):
        thought = self.reason(task, history)
        action = self.select_tool(thought)
        obs = self.execute(action)
        history.append((thought, action, obs))
```

### 优势
- 可解释性强
- 适合复杂推理任务
- 工具调用灵活

---

## CoT (Chain of Thought)

### 思维链
- 显式展示推理步骤
- 适用于数学、逻辑问题
- 可结合 self-consistency

### 变体
- **ToT (Tree of Thought)**: 探索多条推理路径
- **GoT (Graph of Thought)**: 图结构推理
- **XoT**: 混合策略

---

## Agent 架构

### 规划模块
- 任务分解 (LLM + prompts)
- 子目标排序
- 异常处理与重规划

### 记忆模块
- 短期记忆: 当前上下文
- 长期记忆: 向量数据库
- 记忆检索与整合

### 工具生态
- API 调用
- 代码执行
- 文件操作
- 浏览器控制

---

## 多 Agent 系统

### 角色分工
- 规划 Agent
- 执行 Agent
- 审核 Agent
- 记忆 Agent

### 协作模式
- 串行: 流水线式
- 并行: 独立任务
- 层次: 主从结构

### 通信协议
- 消息队列
- 共享状态
- 共识机制
