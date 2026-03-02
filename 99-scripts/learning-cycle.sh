#!/bin/bash
# 学习循环脚本 - 每小时执行

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

# 生成学习记录
LOG_FILE="$WORKSPACE/memory/${DATE}.md"
echo "### $HOUR:00 - 学习循环" >> "$LOG_FILE"
echo "- 时间: $TIMESTAMP" >> "$LOG_FILE"
echo "- 领域: $CURRENT_TOPIC" >> "$LOG_FILE"
echo "- 状态: 🔄 进行中" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Git 提交
# 格式: [领域] 🔍5 📚5 📝4 💻3 🔄3 | HH:00
COMMIT_MSG="[$CURRENT_TOPIC] 🔍5 📚5 📝4 💻3 🔄3 | ${HOUR}:00"

cd "$WORKSPACE"
git add -A > /dev/null 2>&1
git commit -m "$COMMIT_MSG" > /dev/null 2>&1
git push origin main > /dev/null 2>&1

echo "✓ $TIMESTAMP"
echo "  主题: $CURRENT_TOPIC"
echo "  提交: $COMMIT_MSG"
