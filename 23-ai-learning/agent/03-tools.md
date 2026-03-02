# Agent 工具系统深度

## 工具系统架构

### 1. 工具注册

```python
# 工具定义规范
class Tool:
    def __init__(self, name, description, parameters):
        self.name = name
        self.description = description
        self.parameters = parameters
    
    def execute(self, **kwargs):
        raise NotImplementedError

# 工具注册表
class ToolRegistry:
    def __init__(self):
        self.tools = {}
    
    def register(self, tool: Tool):
        self.tools[tool.name] = tool
    
    def get(self, name: str):
        return self.tools.get(name)
    
    def list_tools(self):
        return list(self.tools.keys())
```

### 2. 工具选择

```python
# 基于 LLM 的工具选择
def select_tool(task, tools, llm):
    # 构建工具描述
    tool_descriptions = "\n".join([
        f"- {t.name}: {t.description}"
        for t in tools
    ])
    
    prompt = f"""
任务: {task}

可用工具:
{tool_descriptions}

请选择最合适的工具并给出参数。
"""
    
    response = llm.generate(prompt)
    return parse_tool_call(response)
```

---

## 常见工具类型

### 1. 搜索工具

```python
class SearchTool(Tool):
    def __init__(self):
        super().__init__(
            name="search",
            description="搜索互联网信息",
            parameters={
                "query": {"type": "string", "description": "搜索关键词"}
            }
        )
    
    def execute(self, query):
        # 调用搜索API
        results = search_api(query)
        return format_results(results)
```

### 2. 计算工具

```python
class CalculatorTool(Tool):
    def __init__(self):
        super().__init__(
            name="calculate",
            description="执行数学计算",
            parameters={
                "expression": {"type": "string", "description": "数学表达式"}
            }
        )
    
    def execute(self, expression):
        try:
            result = eval(expression)
            return str(result)
        except Exception as e:
            return f"错误: {e}"
```

### 3. 代码执行工具

```python
class CodeExecutor(Tool):
    def __init__(self):
        super().__init__(
            name="execute_code",
            description="执行Python代码",
            parameters={
                "code": {"type": "string", "description": "要执行的代码"},
                "language": {"type": "string", "description": "语言"}
            }
        )
    
    def execute(self, code, language="python"):
        if language == "python":
            # 安全执行
            result = safe_exec(code)
            return result
        raise ValueError(f"不支持的语言: {language}")
```

---

## 工具调用流程

```
用户输入 → 理解意图 → 选择工具 → 构造参数 → 执行 → 解析结果 → 格式化输出
```

### 1. 意图理解

```python
def understand_intent(user_input, llm):
    prompt = f"""
分析用户输入，提取关键信息:
用户: {user_input}

请识别:
1. 用户想要做什么?
2. 需要什么工具?
3. 需要什么参数?
"""
    return llm.generate(prompt)
```

### 2. 参数验证

```python
def validate_params(tool, params):
    required = tool.parameters.get("required", [])
    for param in required:
        if param not in params:
            raise ValueError(f"缺少必需参数: {param}")
    
    # 类型检查
    for param, value in params.items():
        expected_type = tool.parameters.get(param, {}).get("type")
        if not isinstance(value, eval(expected_type)):
            raise TypeError(f"参数 {param} 类型错误")
```

### 3. 错误处理

```python
def execute_with_retry(tool, params, max_retries=3):
    for attempt in range(max_retries):
        try:
            result = tool.execute(**params)
            return {"success": True, "result": result}
        except Exception as e:
            if attempt == max_retries - 1:
                return {"success": False, "error": str(e)}
            # 重试前尝试修复
            params = fix_params(params, e)
    return {"success": False, "error": "Max retries exceeded"}
```

---

## 让我变强的工具技能

1. **设计良好工具接口** - 清晰描述、准确参数
2. **实现工具执行器** - 安全执行、错误处理
3. **构建工具注册表** - 动态注册、灵活调度
4. **优化工具选择** - 减少调用、提高准确率

---
