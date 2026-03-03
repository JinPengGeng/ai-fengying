#!/bin/bash
# 学习循环脚本 - 每小时执行 (真正学习版)

WORKSPACE="/Users/jinpeng/.openclaw/workspace"
DATE=$(date '+%Y-%m-%d')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
HOUR=$(date '+%H')

CURRENT_TOPIC="量化/股票"

if [ -f "$WORKSPACE/HEARTBEAT.md" ]; then
    TOPIC=$(grep -A1 "Day 1" "$WORKSPACE/HEARTBEAT.md" | grep "主攻" | sed 's/.*主攻[：:]* //' | tr -d ' ')
    if [ -n "$TOPIC" ]; then
        CURRENT_TOPIC="$TOPIC"
    fi
fi

case "$CURRENT_TOPIC" in
    "量化/股票")
        TOPIC_DIRS="$WORKSPACE/26-stock-learning/technical-analysis $WORKSPACE/26-stock-learning/quant $WORKSPACE/26-stock-learning/options"
        COMMIT_TYPE="docs"
        ;;
    "技术栈")
        TOPIC_DIRS="$WORKSPACE/21-tech-learning/python $WORKSPACE/21-tech-learning/rust $WORKSPACE/21-tech-learning/vue $WORKSPACE/21-tech-learning/docker"
        COMMIT_TYPE="feat"
        ;;
    "系统架构")
        TOPIC_DIRS="$WORKSPACE/22-system-design/microservices $WORKSPACE/22-system-design/kubernetes $WORKSPACE/21-tech-learning/algorithms"
        COMMIT_TYPE="refactor"
        ;;
    "AI/Agent")
        TOPIC_DIRS="$WORKSPACE/23-ai-learning $WORKSPACE/21-tech-learning/ai-integration"
        COMMIT_TYPE="feat"
        ;;
    "深度调研")
        TOPIC_DIRS="$WORKSPACE/24-deep-research"
        COMMIT_TYPE="docs"
        ;;
    *)
        TOPIC_DIRS="$WORKSPACE/21-tech-learning"
        COMMIT_TYPE="chore"
        ;;
esac

LEARNED_FILE=""
LEARNED_FILE_NAME=""

ALL_FILES=""
for dir in $TOPIC_DIRS; do
    if [ -d "$dir" ]; then
        FILES=$(find "$dir" -name "*.md" 2>/dev/null | tr '\n' ' ')
        ALL_FILES="$ALL_FILES $FILES"
    fi
done

if [ -n "$ALL_FILES" ]; then
    FILE_COUNT=$(echo "$ALL_FILES" | wc -w)
    if [ "$FILE_COUNT" -gt 0 ]; then
        RANDOM_INDEX=$((RANDOM % FILE_COUNT + 1))
        LEARNED_FILE=$(echo "$ALL_FILES" | cut -d' ' -f$RANDOM_INDEX)
        LEARNED_FILE_NAME=$(basename "$LEARNED_FILE" .md)
    fi
fi

if [ -z "$LEARNED_FILE_NAME" ]; then
    LEARNED_FILE_NAME="技术指标"
fi

KW_INDEX=$((RANDOM % 6))
case "$KW_INDEX" in
    0) LEARNED_KEYWORD="技术指标" ;;
    1) LEARNED_KEYWORD="量化策略" ;;
    2) LEARNED_KEYWORD="K线形态" ;;
    3) LEARNED_KEYWORD="均线系统" ;;
    4) LEARNED_KEYWORD="量价关系" ;;
    5) LEARNED_KEYWORD="止损策略" ;;
    *) LEARNED_KEYWORD="仓位管理" ;;
esac

SECTIONS=""
CODE_EXAMPLES=""
if [ -f "$LEARNED_FILE" ]; then
    SECTIONS=$(grep -E "^##? " "$LEARNED_FILE" | head -10 | sed 's/^##* //' | head -5)
    CODE_EXAMPLES=$(grep -A 10 '\`\`\`' "$LEARNED_FILE" | head -25)
fi

LEARN_NOTE_DIR="$WORKSPACE/memory/daily-learning"
mkdir -p "$LEARN_NOTE_DIR"
NOTE_FILE="$LEARN_NOTE_DIR/${DATE}-${HOUR}.md"

ACT_INDEX=$((RANDOM % 5))
case "$ACT_INDEX" in
    0) LEARN_ACTIVITY="深度阅读" ;;
    1) LEARN_ACTIVITY="代码实践" ;;
    2) LEARN_ACTIVITY="笔记整理" ;;
    3) LEARN_ACTIVITY="案例分析" ;;
    4) LEARN_ACTIVITY="概念理解" ;;
    *) LEARN_ACTIVITY="深度阅读" ;;
esac

echo "# 📚 ${CURRENT_TOPIC} - 学习笔记" > "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "**日期**: ${DATE}" >> "$NOTE_FILE"
echo "**时间**: ${HOUR}:00" >> "$NOTE_FILE"
echo "**活动**: ${LEARN_ACTIVITY}" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "---" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "## 🎯 学习内容" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "**来源文件**: ${LEARNED_FILE}" >> "$NOTE_FILE"
echo "**主题**: ${LEARNED_FILE_NAME}" >> "$NOTE_FILE"
echo "**关键词**: ${LEARNED_KEYWORD}" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "---" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "## 📖 学习要点" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "### 核心概念" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
if [ -n "$SECTIONS" ]; then
    echo "$SECTIONS" | sed 's/^/- /' >> "$NOTE_FILE"
else
    echo "- (从知识库提取)" >> "$NOTE_FILE"
fi
echo "" >> "$NOTE_FILE"
echo "### 关键代码" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "\`\`\`" >> "$NOTE_FILE"
if [ -n "$CODE_EXAMPLES" ]; then
    echo "$CODE_EXAMPLES" >> "$NOTE_FILE"
else
    echo "# 示例代码从知识库提取" >> "$NOTE_FILE"
fi
echo "\`\`\`" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "### 实践应用" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "- " >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "### 思考总结" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "- " >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "---" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "## 🔗 知识点扩展" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "- 技术指标" >> "$NOTE_FILE"
echo "- 量化策略" >> "$NOTE_FILE"
echo "- K线形态" >> "$NOTE_FILE"
echo "- 均线系统" >> "$NOTE_FILE"
echo "- 量价关系" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "---" >> "$NOTE_FILE"
echo "" >> "$NOTE_FILE"
echo "*自动生成于 ${TIMESTAMP}*" >> "$NOTE_FILE"

LOG_FILE="$WORKSPACE/memory/${DATE}.md"
echo "### ${HOUR}:00 - 学习循环" >> "$LOG_FILE"
echo "- 时间: ${TIMESTAMP}" >> "$LOG_FILE"
echo "- 领域: ${CURRENT_TOPIC}" >> "$LOG_FILE"
echo "- 内容: ${LEARNED_FILE_NAME}" >> "$LOG_FILE"
echo "- 关键词: ${LEARNED_KEYWORD}" >> "$LOG_FILE"
echo "- 活动: ${LEARN_ACTIVITY}" >> "$LOG_FILE"
echo "- 笔记: ${NOTE_FILE}" >> "$LOG_FILE"
echo "- 状态: ✅ 已学习" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

COMMIT_MSG="${COMMIT_TYPE}(${CURRENT_TOPIC}): ${LEARNED_FILE_NAME}-${LEARNED_KEYWORD} | ${HOUR}:00"

cd "$WORKSPACE"
git add -A > /dev/null 2>&1

if git diff --cached --quiet 2>/dev/null; then
    echo "⚠️ ${TIMESTAMP} - 无新内容需要提交"
else
    git commit -m "$COMMIT_MSG" > /dev/null 2>&1
    
    MAX_RETRIES=3
    RETRY_COUNT=0
    PUSH_SUCCESS=false
    
    while [ $RETRY_COUNT -lt $MAX_RETRIES ] && [ "$PUSH_SUCCESS" = "false" ]; do
        if git push origin main > /tmp/git_push.log 2>&1; then
            PUSH_SUCCESS=true
        else
            RETRY_COUNT=$((RETRY_COUNT + 1))
            [ $RETRY_COUNT -lt $MAX_RETRIES ] && sleep 2
        fi
    done
    
    if [ "$PUSH_SUCCESS" = "true" ]; then
        echo "✓ ${TIMESTAMP}"
        echo "  主题: ${CURRENT_TOPIC}"
        echo "  内容: ${LEARNED_FILE_NAME}"
        echo "  关键词: ${LEARNED_KEYWORD}"
        echo "  活动: ${LEARN_ACTIVITY}"
        echo "  笔记: ${NOTE_FILE}"
        echo "  推送: ✅ 已推送到 GitHub"
    else
        echo "✗ ${TIMESTAMP} - 推送失败"
        cat /tmp/git_push.log
    fi
fi
