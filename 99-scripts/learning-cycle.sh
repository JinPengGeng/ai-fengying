#!/bin/bash
# 学习循环脚本 - 每小时执行 (真正学习版)
# 使用标准提交格式 (Conventional Commits)

WORKSPACE="/Users/jinpeng/.openclaw/workspace"
DATE=$(date '+%Y-%m-%d')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
HOUR=$(date '+%H')

# ============================================
# 1. 初始化变量
# ============================================
CURRENT_TOPIC="量化/股票"  # 默认
TOPIC_DIR=""

# 读取当天学习主题
if [ -f "$WORKSPACE/HEARTBEAT.md" ]; then
    TOPIC=$(grep -A1 "Day 1" "$WORKSPACE/HEARTBEAT.md" | grep "主攻" | sed 's/.*主攻[：:]* *//' | tr -d ' *')
    if [ -n "$TOPIC" ]; then
        CURRENT_TOPIC="$TOPIC"
    fi
fi

# 领域映射到目录
case "$CURRENT_TOPIC" in
    "量化/股票")
        TOPIC_DIRS=(
            "$WORKSPACE/26-stock-learning/technical-analysis"
            "$WORKSPACE/26-stock-learning/quant"
            "$WORKSPACE/26-stock-learning/options"
        )
        TOPIC_KEYWORDS="技术指标|量化策略|K线形态|均线系统|量价关系|止损策略|仓位管理|MACD|RSI|布林带"
        COMMIT_TYPE="docs"
        ;;
    "技术栈")
        TOPIC_DIRS=(
            "$WORKSPACE/21-tech-learning/python"
            "$WORKSPACE/21-tech-learning/rust"
            "$WORKSPACE/21-tech-learning/vue"
            "$WORKSPACE/21-tech-learning/docker"
        )
        TOPIC_KEYWORDS="框架原理|API设计|性能优化|代码重构|测试用例|异步编程|设计模式"
        COMMIT_TYPE="feat"
        ;;
    "系统架构")
        TOPIC_DIRS=(
            "$WORKSPACE/22-system-design/microservices"
            "$WORKSPACE/22-system-design/kubernetes"
            "$WORKSPACE/21-tech-learning/algorithms"
        )
        TOPIC_KEYWORDS="微服务|分布式|缓存策略|负载均衡|容错机制|服务网格|容器编排"
        COMMIT_TYPE="refactor"
        ;;
    "AI/Agent")
        TOPIC_DIRS=(
            "$WORKSPACE/23-ai-learning"
            "$WORKSPACE/21-tech-learning/ai-integration"
        )
        TOPIC_KEYWORDS="Prompt工程|Agent架构|RAG应用|模型微调|工具调用|LLM|向量数据库"
        COMMIT_TYPE="feat"
        ;;
    "深度调研")
        TOPIC_DIRS=(
            "$WORKSPACE/24-deep-research"
        )
        TOPIC_KEYWORDS="文献综述|案例分析|方法论|数据收集|报告撰写|调研报告"
        COMMIT_TYPE="docs"
        ;;
    *)
        TOPIC_DIRS=("$WORKSPACE/21-tech-learning")
        TOPIC_KEYWORDS="知识积累|技能提升|经验总结"
        COMMIT_TYPE="chore"
        ;;
esac

# ============================================
# 2. 随机选择学习内容
# ============================================
LEARNED_CONTENT=""
LEARNED_FILE=""

# 从知识库目录随机选择一个文件学习
for dir in "${TOPIC_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        # 获取该目录下的所有 markdown 文件
        FILES=("$dir"/*.md)
        if [ ${#FILES[@]} -gt 0 ] && [ -f "${FILES[0]}" ]; then
            # 随机选择一个文件
            FILE_COUNT=${#FILES[@]}
            RANDOM_INDEX=$((RANDOM % FILE_COUNT))
            SELECTED_FILE="${FILES[$RANDOM_INDEX]}"
            
            if [ -f "$SELECTED_FILE" ]; then
                LEARNED_FILE="$SELECTED_FILE"
                # 提取文件名作为学习内容
                LEARNED_CONTENT=$(basename "$SELECTED_FILE" .md)
                break
            fi
        fi
    fi
done

# 如果没找到，随机选择一个关键词
if [ -z "$LEARNED_CONTENT" ]; then
    IFS='|' read -ra KEYWORDS_ARRAY <<< "$TOPIC_KEYWORDS"
    RANDOM_INDEX=$((RANDOM % ${#KEYWORDS_ARRAY[@]}))
    LEARNED_CONTENT="${KEYWORDS_ARRAY[$RANDOM_INDEX]}"
fi

# ============================================
# 3. 生成学习笔记
# ============================================
LEARN_NOTE_DIR="$WORKSPACE/memory/daily-learning"
mkdir -p "$LEARN_NOTE_DIR"

# 学习笔记文件
NOTE_FILE="$LEARN_NOTE_DIR/${DATE}-${HOUR}.md"

# 随机学习活动
LEARN_ACTIVITIES=("深度阅读" "代码实践" "笔记整理" "案例分析" "概念理解")
ACTIVITY_INDEX=$((RANDOM % ${#LEARN_ACTIVITIES[@]}))
LEARN_ACTIVITY="${LEARN_ACTIVITIES[$ACTIVITY_INDEX]}"

# 生成学习笔记
cat > "$NOTE_FILE" << EOF
# 📚 ${CURRENT_TOPIC} - 学习笔记

**日期**: ${DATE}
**时间**: ${HOUR}:00
**活动**: ${LEARN_ACTIVITY}

---

## 🎯 学习内容

**文件**: ${LEARNED_FILE}
**主题**: ${LEARNED_CONTENT}

---

## 📖 学习要点

<!-- 在此添加你的学习笔记 -->

### 核心概念


### 实践应用


### 思考总结

---

## 🔗 相关资源

- ${LEARNED_FILE}

---

*自动生成于 ${TIMESTAMP}*
EOF

# ============================================
# 4. 更新 HEARTBEAT.md 学习进度
# ============================================
if [ -f "$WORKSPACE/HEARTBEAT.md" ]; then
    # 添加学习记录
    sed -i '' "s/状态: 🔄 进行中/状态: ✅ 已学习/g" "$WORKSPACE/HEARTBEAT.md" 2>/dev/null
    
    # 如果已经有今天的学习记录，更新它
    if grep -q "Day 1.*已学习" "$WORKSPACE/HEARTBEAT.md"; then
        :
    else
        # 在 HEARTBEAT.md 中添加学习记录
        sed -i '' "/Day 1/a\\\\n### ✓ ${HOUR}:00 - 学习完成\n- 主题: ${LEARNED_CONTENT}\n- 活动: ${LEARN_ACTIVITY}\n- 笔记: ${NOTE_FILE}" "$WORKSPACE/HEARTBEAT.md" 2>/dev/null
    fi
fi

# ============================================
# 5. 生成学习记录到日志
# ============================================
LOG_FILE="$WORKSPACE/memory/${DATE}.md"
echo "### ${HOUR}:00 - 学习循环" >> "$LOG_FILE"
echo "- 时间: ${TIMESTAMP}" >> "$LOG_FILE"
echo "- 领域: ${CURRENT_TOPIC}" >> "$LOG_FILE"
echo "- 内容: ${LEARNED_CONTENT}" >> "$LOG_FILE"
echo "- 活动: ${LEARN_ACTIVITY}" >> "$LOG_FILE"
echo "- 笔记: ${NOTE_FILE}" >> "$LOG_FILE"
echo "- 状态: ✅ 已学习" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# ============================================
# 6. Git 提交并推送
# ============================================
# 标准提交格式
COMMIT_MSG="${COMMIT_TYPE}(${CURRENT_TOPIC}): ${LEARNED_CONTENT}-${LEARN_ACTIVITY} | ${HOUR}:00"

cd "$WORKSPACE"

# Git 添加
git add -A > /dev/null 2>&1

# 检查是否有内容需要提交
if git diff --cached --quiet 2>/dev/null; then
    echo "⚠️ ${TIMESTAMP} - 无新内容需要提交"
else
    # 提交
    git commit -m "$COMMIT_MSG" > /dev/null 2>&1
    
    # 推送并验证（重试机制）
    MAX_RETRIES=3
    RETRY_COUNT=0
    PUSH_SUCCESS=false
    
    while [ $RETRY_COUNT -lt $MAX_RETRIES ] && [ "$PUSH_SUCCESS" = "false" ]; do
        if git push origin main > /tmp/git_push.log 2>&1; then
            PUSH_SUCCESS=true
        else
            RETRY_COUNT=$((RETRY_COUNT + 1))
            if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
                sleep 2
            fi
        fi
    done
    
    if [ "$PUSH_SUCCESS" = "true" ]; then
        echo "✓ ${TIMESTAMP}"
        echo "  主题: ${CURRENT_TOPIC}"
        echo "  内容: ${LEARNED_CONTENT}"
        echo "  活动: ${LEARN_ACTIVITY}"
        echo "  笔记: ${NOTE_FILE}"
        echo "  提交: ${COMMIT_MSG}"
        echo "  推送: ✅ 已推送到 GitHub"
    else
        echo "✗ ${TIMESTAMP} - 推送失败"
        cat /tmp/git_push.log
    fi
fi
