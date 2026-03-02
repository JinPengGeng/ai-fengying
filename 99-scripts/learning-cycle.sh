#!/bin/bash
# 学习循环脚本 - 每小时执行

WORKSPACE="/Users/jinpeng/.openclaw/workspace"
DATE=$(date '+%Y-%m-%d')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')

# 创建学习日志
LOG_FILE="$WORKSPACE/memory/${DATE}.md"

echo "### $(date '+%H:00') - 学习循环" >> "$LOG_FILE"
echo "- 时间: $TIMESTAMP" >> "$LOG_FILE"
echo "- 状态: 后台学习执行中" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Git 提交
cd "$WORKSPACE"
git add -A > /dev/null 2>&1
git commit -m "Learning: $TIMESTAMP" > /dev/null 2>&1
git push origin main > /dev/null 2>&1

echo "✓ 学习循环完成: $TIMESTAMP"
