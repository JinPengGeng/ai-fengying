# AI Agent 高级架构

## 多 Agent 系统

### 1. Agent 协作模式

```python
class MultiAgentSystem:
    def __init__(self):
        self.agents = {}
        self.message_queue = Queue()
    
    def register(self, name, agent):
        self.agents[name] = agent
    
    def broadcast(self, message, from_agent):
        """广播消息给所有 Agent"""
        for name, agent in self.agents.items():
            if name != from_agent:
                agent.receive(message)
    
    def route(self, message, from_agent, to_agent):
        """路由消息给指定 Agent"""
        if to_agent in self.agents:
            self.agents[to_agent].receive(message)
```

### 2. Agent 类型

| 类型 | 职责 | 例子 |
|------|------|------|
| **Coordinator** | 协调任务分配 | 任务分发 |
| **Specialist** | 专业领域 | 编程、搜索 |
| **Critic** | 审查结果 | 质量把控 |
| **Executor** | 执行具体任务 | 代码生成 |

### 3. 消息协议

```python
class AgentMessage:
    def __init__(self, sender, receiver, content, metadata=None):
        self.sender = sender
        self.receiver = receiver
        self.content = content
        self.metadata = metadata or {}
        self.timestamp = datetime.now()
    
    def to_dict(self):
        return {
            "sender": self.sender,
            "receiver": self.receiver,
            "content": self.content,
            "metadata": self.metadata,
            "timestamp": self.timestamp.isoformat()
        }
```

---

## 记忆系统

### 4. 分层记忆

```python
class LayeredMemory:
    def __init__(self):
        # 工作记忆 - 当前会话
        self.working = []
        
        # 情景记忆 - 最近交互
        self.episodic = []
        
        # 语义记忆 - 知识存储
        self.semantic = VectorStore()
        
        # 程序记忆 - 技能/流程
        self.procedural = {}
    
    def add_working(self, item):
        self.working.append(item)
        if len(self.working) > 10:
            # 转移到情景记忆
            self.episodic.append(self.working.pop(0))
    
    def retrieve(self, query, top_k=5):
        """语义检索"""
        return self.semantic.search(query, top_k)
```

### 5. 向量存储

```python
class VectorStore:
    def __init__(self, dimension=768):
        self.dimension = dimension
        self.vectors = []
        self.metadata = []
    
    def add(self, text, embedding, metadata=None):
        self.vectors.append(embedding)
        self.metadata.append({"text": text, "metadata": metadata})
    
    def search(self, query_embedding, top_k=5):
        """余弦相似度搜索"""
        scores = []
        for i, vec in enumerate(self.vectors):
            score = cosine_similarity(query_embedding, vec)
            scores.append((i, score))
        
        scores.sort(key=lambda x: x[1], reverse=True)
        return scores[:top_k]
```

---

## 工具系统

### 6. 工具注册与发现

```python
class ToolRegistry:
    def __init__(self):
        self.tools = {}
        self.capabilities = {}
    
    def register(self, tool, capabilities):
        """注册工具及其能力"""
        self.tools[tool.name] = tool
        self.capabilities[tool.name] = capabilities
    
    def find_tools(self, required_capabilities):
        """基于能力查找工具"""
        results = []
        for name, caps in self.capabilities.items():
            if all(c in caps for c in required_capabilities):
                results.append(self.tools[name])
        return results
    
    def describe_tools(self):
        """生成工具描述供 LLM 使用"""
        descriptions = []
        for tool in self.tools.values():
            desc = f"- {tool.name}: {tool.description}"
            if tool.parameters:
                desc += f"\n  参数: {tool.parameters}"
            descriptions.append(desc)
        return "\n".join(descriptions)
```

---

## 规划系统

### 7. 任务规划

```python
class TaskPlanner:
    def __init__(self, llm):
        self.llm = llm
    
    def decompose(self, task):
        """任务分解"""
        prompt = f"""
        将以下任务分解为可执行的步骤:
        任务: {task}
        
        输出格式:
        1. 步骤1
        2. 步骤2
        3. 步骤3
        """
        steps = self.llm.generate(prompt)
        return self.parse_steps(steps)
    
    def plan(self, task, context):
        """生成执行计划"""
        prompt = f"""
        任务: {task}
        上下文: {context}
        
        请制定详细执行计划，包括:
        1. 需要的信息
        2. 执行步骤
        3. 预期结果
        4. 备选方案
        """
        return self.llm.generate(prompt)
    
    def adapt(self, plan, feedback):
        """根据反馈调整计划"""
        prompt = f"""
        原计划: {plan}
        反馈: {feedback}
        
        请调整计划。
        """
        return self.llm.generate(prompt)
```

---

## 反思系统

### 8. 自我反思

```python
class ReflectionSystem:
    def __init__(self, llm):
        self.llm = llm
    
    def reflect(self, action, result, context):
        """反思行动结果"""
        prompt = f"""
        行动: {action}
        结果: {result}
        上下文: {context}
        
        反思以下问题:
        1. 行动是否正确?
        2. 结果是否符合预期?
        3. 有哪些可以改进的地方?
        4. 学到了什么?
        """
        reflection = self.llm.generate(prompt)
        return reflection
    
    def evaluate_confidence(self, response):
        """评估回答置信度"""
        prompt = f"""
        回答: {response}
        
        评估置信度 (0-100):
        - 100: 完全确定
        - 50: 不太确定
        - 0: 完全不确定
        
        同时标记不确定的部分。
        """
        return self.llm.generate(prompt)
```

---

## 让我变强的架构能力

1. **多 Agent 协作** - 协调、 Specialist、Critic
2. **记忆系统** - 工作、情景、语义、程序记忆
3. **工具系统** - 注册、发现、描述
4. **规划系统** - 分解、计划、调整
5. **反思系统** - 自我评估、置信度

---
