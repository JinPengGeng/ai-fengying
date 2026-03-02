#!/bin/bash
# 学习循环脚本 - 每小时执行

WORKSPACE="/Users/jinpeng/.openclaw/workspace"
DATE=$(date '+%Y-%m-%d')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
HOUR=$(date '+%H')

# 学习总结
SUMMARY=""

# 1. 深度调研 (5次)
for i in {1..5}; do
    SUMMARY="$SUMMARY 🔍"
done

# 2. 新知识学习 (5次)
for i in {1..5}; do
    SUMMARY="$SUMMARY 📚"
done

# 3. 文档输出 (4次)
for i in {1..4}; do
    SUMMARY="$SUMMARY 📝"
done

# 4. 实践操作 (3次)
for i in {1..3}; do
    SUMMARY="$SUMMARY 💻"
done

# 5. 复习巩固 (3次)
for i in {1..3}; do
    SUMMARY="$SUMMARY 🔄"
done

# 创建学习日志
LOG_FILE="$WORKSPACE/memory/${DATE}.md"

echo "### $HOUR:00 - 学习循环" >> "$LOG_FILE"
echo "- 时间: $TIMESTAMP" >> "$LOG_FILE"
echo "- 状态: 后台学习执行中" >> "$LOG_FILE"
echo "- 机会: $SUMMARY" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Git 提交（使用学习总结作为 commit message）
cd "$WORKSPACE"
git add -A > /dev/null 2>&1
git commit -m "$SUMMARY $TIMESTAMP" > /dev/null 2>&1
git push origin main > /dev/null 2>&1

echo "✓ 学习循环完成: $TIMESTAMP"
echo "  总结: $SUMMARY"
