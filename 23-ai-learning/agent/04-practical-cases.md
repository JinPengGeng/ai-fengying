# AI Agent 实战案例

## 案例1: 智能客服 Agent

### 系统架构

```
用户 → 对话界面 → Agent → LLM
                    ↓
              意图识别
                    ↓
              知识库检索
                    ↓
              工具调用 (订单查询/退换货)
                    ↓
              回复生成
```

### 核心实现

```python
class CustomerServiceAgent:
    def __init__(self, llm, tools, knowledge_base):
        self.llm = llm
        self.tools = tools
        self.knowledge_base = knowledge_base
    
    def handle_message(self, user_message):
        # 1. 理解用户意图
        intent = self.understand_intent(user_message)
        
        # 2. 决定行动
        if intent == "query_order":
            order_id = self.extract_order_id(user_message)
            result = self.tools["order_api"].get_order(order_id)
            response = self.generate_response("order_query", result)
        
        elif intent == "refund":
            order_id, reason = self.extract_refund_info(user_message)
            result = self.tools["order_api"].process_refund(order_id, reason)
            response = self.generate_response("refund", result)
        
        elif intent == "faq":
            answer = self.knowledge_base.search(user_message)
            response = answer
        
        else:
            # 转人工
            response = self.handoff_to_human(user_message)
        
        return response
    
    def understand_intent(self, message):
        prompt = f"""
        用户消息: {message}
        
        请识别用户意图，只返回以下之一:
        - query_order: 查询订单
        - refund: 退换货
        - faq: 常见问题
        - human: 转人工
        """
        return self.llm.generate(prompt).strip()
```

---

## 案例2: 代码审查 Agent

### 工作流程

```
收到 PR → 代码分析 → 问题检测 → 建议生成 → 评论
```

### 实现

```python
class CodeReviewAgent:
    def __init__(self, llm):
        self.llm = llm
    
    async def review_pull_request(self, pr_diff):
        # 1. 代码分析
        issues = []
        
        # 静态分析
        issues.extend(self.static_analysis(pr_diff))
        
        # 安全扫描
        issues.extend(await self.security_scan(pr_diff))
        
        # 2. 性能检查
        issues.extend(self.performance_check(pr_diff))
        
        # 3. 生成审查意见
        review = self.generate_review(issues)
        
        return review
    
    def static_analysis(self, diff):
        issues = []
        
        # 检查常见问题
        patterns = [
            (r"console\.log", "移除调试代码"),
            (r"TODO", "存在未完成的任务"),
            (r"except:", "裸异常捕获"),
            (r"== ", "使用 === 代替 =="),
        ]
        
        for file, changes in diff.items():
            for pattern, message in patterns:
                if re.search(pattern, changes):
                    issues.append({
                        "file": file,
                        "type": "warning",
                        "message": message
                    })
        
        return issues
    
    async def security_scan(self, diff):
        issues = []
        
        # 安全模式
        vulnerable_patterns = [
            (r"eval\(", "使用 eval 可能导致安全问题"),
            (r"exec\(", "使用 exec 可能导致安全问题"),
            (r"password\s*=", "硬编码密码"),
            (r"api[_-]?key\s*=", "硬编码 API Key"),
        ]
        
        for file, changes in diff.items():
            for pattern, message in vulnerable_patterns:
                if re.search(pattern, changes, re.IGNORECASE):
                    issues.append({
                        "file": file,
                        "type": "security",
                        "severity": "high",
                        "message": message
                    })
        
        return issues
    
    def generate_review(self, issues):
        if not issues:
            return "✅ 代码审查通过！没有发现问题。"
        
        by_type = {}
        for issue in issues:
            issue_type = issue.get("type", "warning")
            if issue_type not in by_type:
                by_type[issue_type] = []
            by_type[issue_type].append(issue)
        
        review = "## Code Review\n\n"
        
        for issue_type, type_issues in by_type.items():
            review += f"### {issue_type.upper()}\n"
            for issue in type_issues:
                severity = issue.get("severity", "")
                review += f"- [{severity}] {issue['file']}: {issue['message']}\n"
            review += "\n"
        
        return review
```

---

## 案例3: 数据分析 Agent

### 功能

```
用户请求 → 理解需求 → 编写代码 → 执行 → 解释结果
```

### 实现

```python
class DataAnalysisAgent:
    def __init__(self, llm, code_executor):
        self.llm = llm
        self.executor = code_executor
    
    async def analyze(self, user_request, data_source):
        # 1. 理解分析需求
        analysis_type = self.determine_analysis_type(user_request)
        
        # 2. 生成分析代码
        code = self.generate_code(analysis_type, data_source)
        
        # 3. 执行代码
        try:
            result = await self.executor.run(code)
            
            # 4. 解释结果
            explanation = self.explain_result(result, analysis_type)
            
            return {
                "success": True,
                "result": result,
                "explanation": explanation,
                "code": code
            }
        except Exception as e:
            return {
                "success": False,
                "error": str(e)
            }
    
    def determine_analysis_type(self, request):
        prompt = f"""
        用户请求: {request}
        
        请确定分析类型:
        - descriptive: 描述性统计
        - correlation: 相关性分析
        - regression: 回归分析
        - clustering: 聚类分析
        - visualization: 可视化
        """
        return self.llm.generate(prompt).strip()
    
    def generate_code(self, analysis_type, data_source):
        templates = {
            "descriptive": '''
import pandas as pd

df = pd.read_csv("{source}")
analysis = df.describe()
print(analysis)
''',
            "correlation": '''
import pandas as pd

df = pd.read_csv("{source}")
corr = df.corr()
print(corr)
'''
        }
        return templates.get(analysis_type, "").format(source=data_source)
    
    def explain_result(self, result, analysis_type):
        prompt = f"""
        分析类型: {analysis_type}
        分析结果: {result}
        
        请用通俗易懂的语言解释这个分析结果。
        """
        return self.llm.generate(prompt)
```

---

## 案例4: 自动化运维 Agent

### 功能

```
监控告警 → 分析原因 → 自动修复/建议
```

### 实现

```python
class OpsAgent:
    def __init__(self, llm, monitoring_tools):
        self.llm = llm
        self.tools = monitoring_tools
    
    async def handle_alert(self, alert):
        # 1. 收集上下文
        context = await self.collect_context(alert)
        
        # 2. 分析问题
        analysis = await self.analyze_issue(alert, context)
        
        # 3. 决定行动
        if analysis["can_auto_fix"]:
            # 自动修复
            fix_result = await self.auto_fix(analysis["fix_steps"])
            return {
                "action": "auto_fixed",
                "analysis": analysis,
                "result": fix_result
            }
        else:
            # 人工介入
            recommendation = self.get_recommendation(analysis)
            return {
                "action": "manual_required",
                "analysis": analysis,
                "recommendation": recommendation
            }
    
    async def collect_context(self, alert):
        context = {
            "alert": alert,
            "metrics": await self.tools["metrics"].query(alert),
            "logs": await self.tools["logs"].query(alert),
            "events": await self.tools["events"].query(alert)
        }
        return context
    
    async def analyze_issue(self, alert, context):
        prompt = f"""
        告警: {alert}
        指标: {context['metrics']}
        日志: {context['logs']}
        
        请分析:
        1. 问题原因
        2. 严重程度
        3. 是否可以自动修复
        4. 修复步骤（如果可以自动修复）
        
        返回 JSON 格式:
        {{
            "cause": "原因",
            "severity": "high/medium/low",
            "can_auto_fix": true/false,
            "fix_steps": ["步骤1", "步骤2"]
        }}
        """
        result = self.llm.generate(prompt)
        return json.loads(result)
    
    async def auto_fix(self, steps):
        results = []
        for step in steps:
            result = await self.execute_fix_step(step)
            results.append(result)
        return results
```

---

## 让我变强的 Agent 实战技能

1. **需求理解** - 意图识别、实体提取
2. **工具编排** - 按需调用、结果组合
3. **错误处理** - 重试、降级、转人工
4. **持续学习** - 从反馈中改进
5. **安全合规** - 权限控制、审计日志

---
