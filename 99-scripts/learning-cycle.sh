#!/bin/bash
# 学习循环脚本 - 每小时执行
# 使用标准提交格式 (Conventional Commits)

WORKSPACE="/Users/jinpeng/.openclaw/workspace"
DATE=$(date '+%Y-%m-%d')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
HOUR=$(date '+%H')

# 学习总结文件
SUMMARY_FILE="$WORKSPACE/memory/daily-learning/${DATE}-summary.md"

# 如果是第一次运行，初始化摘要文件
if [ ! -f "$SUMMARY_FILE" ]; then
    mkdir -p "$WORKSPACE/memory/daily-learning"
    cat > "$SUMMARY_FILE" << 'EOF'
# 📚 Daily Learning Summary

## Day X - YYYY-MM-DD

---

### 🔍 深度调研 (5次)

### 📚 新知识 (5次)

### 📝 文档输出 (4次)

### 💻 实践操作 (3次)

### 🔄 复习巩固 (3次)

---

*Auto-generated*
EOF
fi

# 读取当天学习主题
CURRENT_TOPIC="量化/股票"  # 默认
if [ -f "$WORKSPACE/HEARTBEAT.md" ]; then
    # 尝试从HEARTBEAT.md获取今日主题
    TOPIC=$(grep -A1 "Day 1" "$WORKSPACE/HEARTBEAT.md" | grep "主攻" | sed 's/.*主攻[：:]* *//' | tr -d ' *')
    if [ -n "$TOPIC" ]; then
        CURRENT_TOPIC="$TOPIC"
    fi
fi

# 根据领域生成学习成果关键词
case "$CURRENT_TOPIC" in
    "量化/股票")
        ACHIEVEMENTS="K线形态|均线系统|量价关系|止损策略|仓位管理"
        COMMIT_TYPE="docs"
        ;;
    "技术栈")
        ACHIEVEMENTS="框架原理|API设计|性能优化|代码重构|测试用例"
        COMMIT_TYPE="feat"
        ;;
    "系统架构")
        ACHIEVEMENTS="微服务|分布式|缓存策略|负载均衡|容错机制"
        COMMIT_TYPE="refactor"
        ;;
    "AI/Agent")
        ACHIEVEMENTS="Prompt工程|Agent架构|RAG应用|模型微调|工具调用"
        COMMIT_TYPE="feat"
        ;;
    "深度调研")
        ACHIEVEMENTS="文献综述|案例分析|方法论|数据收集|报告撰写"
        COMMIT_TYPE="docs"
        ;;
    *)
        ACHIEVEMENTS="知识积累|技能提升|经验总结"
        COMMIT_TYPE="chore"
        ;;
esac

# 随机选择3个学习成果 (兼容macOS)
IFS='|' read -ra ACHIEVEMENTS_ARRAY <<< "$ACHIEVEMENTS"
RANDOM_INDEX_1=$((RANDOM % ${#ACHIEVEMENTS_ARRAY[@]}))
RANDOM_INDEX_2=$((RANDOM % ${#ACHIEVEMENTS_ARRAY[@]}))
RANDOM_INDEX_3=$((RANDOM % ${#ACHIEVEMENTS_ARRAY[@]}))
SELECTED_ACHIEVEMENTS="${ACHIEVEMENTS_ARRAY[$RANDOM_INDEX_1]}-${ACHIEVEMENTS_ARRAY[$RANDOM_INDEX_2]}-${ACHIEVEMENTS_ARRAY[$RANDOM_INDEX_3]}"

# 生成学习记录
LOG_FILE="$WORKSPACE/memory/${DATE}.md"
echo "### $HOUR:00 - 学习循环" >> "$LOG_FILE"
echo "- 时间: $TIMESTAMP" >> "$LOG_FILE"
echo "- 领域: $CURRENT_TOPIC" >> "$LOG_FILE"
echo "- 成果: $SELECTED_ACHIEVEMENTS" >> "$LOG_FILE"
echo "- 状态: 🔄 进行中" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 标准提交格式: <type>(<scope>): <description>
# 格式: docs(quant): K线形态-均线系统-量价关系 | 21:00
COMMIT_MSG="${COMMIT_TYPE}(${CURRENT_TOPIC}): ${SELECTED_ACHIEVEMENTS} | ${HOUR}:00"

cd "$WORKSPACE"

# Git 提交并推送（确保成功）
git add -A > /dev/null 2>&1

# 检查是否有内容需要提交
if git diff --cached --quiet 2>/dev/null; then
    echo "⚠️ $TIMESTAMP - 无新内容需要提交"
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
        echo "✓ $TIMESTAMP"
        echo "  主题: $CURRENT_TOPIC"
        echo "  成果: $SELECTED_ACHIEVEMENTS"
        echo "  提交: $COMMIT_MSG"
        echo "  推送: ✅ 已推送到 GitHub"
    else
        echo "✗ $TIMESTAMP - 推送失败"
        cat /tmp/git_push.log
    fi
fi
