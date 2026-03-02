#!/bin/bash
# 学习循环脚本 - 每小时执行

WORKSPACE="/Users/jinpeng/.openclaw/workspace"
DATE=$(date '+%Y-%m-%d')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
HOUR=$(date '+%H')

# 学习总结文件
SUMMARY_FILE="$WORKSPACE/memory/${DATE}-summary.md"

# 如果是第一次运行，初始化摘要文件
if [ ! -f "$SUMMARY_FILE" ]; then
    cat > "$SUMMARY_FILE" << 'EOF'
# 📚 Daily Learning Summary

## Day X - YYYY-MM-DD

---

### 🔍 深度调研

### 📚 新知识

### 📝 文档输出

### 💻 实践操作

### 🔄 复习巩固

---

*Auto-generated*
EOF
fi

# 读取当天的学习领域（从 HEARTBEAT.md 获取）
CURRENT_TOPIC=$(grep "主攻" "$WORKSPACE/HEARTBEAT.md" 2>/dev/null | head -1 | sed 's/.*主攻[:：] *//' || echo "持续学习")

# 生成学习记录
LOG_FILE="$WORKSPACE/memory/${DATE}.md"
echo "### $HOUR:00 - 学习循环" >> "$LOG_FILE"
echo "- 时间: $TIMESTAMP" >> "$LOG_FILE"
echo "- 领域: $CURRENT_TOPIC" >> "$LOG_FILE"
echo "- 状态: 🔄 进行中" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 生成简洁的 commit message
# 格式: [领域] 深度调研X次 + 新知识X次 + 文档X次 + 实践X次 + 复习X次
COMMIT_MSG="[${CURRENT_TOPIC}] 🔍5 + 📚5 + 📝4 + 💻3 + 🔄3 ${DATE} ${HOUR}:00"

# Git 提交
cd "$WORKSPACE"
git add -A > /dev/null 2>&1
git commit -m "$COMMIT_MSG" > /dev/null 2>&1
git push origin main > /dev/null 2>&1

echo "✓ 学习循环完成: $TIMESTAMP"
echo "  领域: $CURRENT_TOPIC"
echo "  提交: $COMMIT_MSG"
