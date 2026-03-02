# Claude Code / OpenAI 集成

## Claude Code 基础

### 1. 安装与配置

```bash
# 安装
npm install -g @anthropic-ai/claude-code

# 配置
claude config set api-key YOUR_API_KEY

# 验证
claude --version
```

### 2. 基本使用

```bash
# 交互式对话
claude

# 单次提示
claude "Write a hello world program in Python"

# 指定模型
claude --model claude-3-5-sonnet-20241022 "Your prompt"
```

### 3. 项目模式

```bash
# 初始化项目
claude init

# 在项目目录中运行
cd my-project
claude "Add error handling to the API"

# 查看项目状态
claude status
```

---

## OpenAI API

### 4. GPT API 调用

```python
import openai

# 配置 API Key
openai.api_key = "your-api-key"

# 聊天完成
response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Hello!"}
    ],
    temperature=0.7,
    max_tokens=1000
)

print(response.choices[0].message.content)
```

### 5. 函数调用

```python
# 定义函数
functions = [
    {
        "name": "get_weather",
        "description": "Get weather for a location",
        "parameters": {
            "type": "object",
            "properties": {
                "location": {
                    "type": "string",
                    "description": "City name"
                }
            },
            "required": ["location"]
        }
    }
]

# 调用
response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "What's the weather in Beijing?"}],
    functions=functions
)

# 解析函数调用
function_call = response.choices[0].message.function_call
if function_call:
    args = json.loads(function_call.arguments)
    weather = get_weather(args["location"])
```

### 6. 流式响应

```python
response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "Tell me a story"}],
    stream=True
)

for chunk in response:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="")
```

---

## Embeddings

### 7. 文本嵌入

```python
# 获取嵌入向量
response = openai.Embedding.create(
    model="text-embedding-3-small",
    input="The quick brown fox"
)

embedding = response.data[0].embedding
print(f"Embedding dimensions: {len(embedding)}")
```

### 8. 相似度搜索

```python
import numpy as np

def cosine_similarity(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))

# 搜索
query_embedding = get_embedding("search query")
results = []

for doc in documents:
    doc_embedding = get_embedding(doc.text)
    similarity = cosine_similarity(query_embedding, doc_embedding)
    results.append((doc, similarity))

results.sort(key=lambda x: x[1], reverse=True)
```

---

## Vision API

### 9. 图像理解

```python
response = openai.ChatCompletion.create(
    model="gpt-4-vision-preview",
    messages=[
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "What's in this image?"},
                {
                    "type": "image_url",
                    "image_url": {"url": "https://example.com/image.jpg"}
                }
            ]
        }
    ],
    max_tokens=300
)
```

---

## 让我变强的 AI 集成技能

1. **Claude Code** - 本地 AI 编程
2. **OpenAI API** - GPT 调用
3. **函数调用** - 工具集成
4. **流式响应** - 实时输出
5. **Embeddings** - 向量搜索

---
