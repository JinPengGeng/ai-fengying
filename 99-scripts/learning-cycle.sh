#!/bin/bash
# 学习循环脚本 - 每小时执行
# 深度结合 OpenClaw 实现自主学习
# 版本：v3.0 - AI 驱动真实学习

set -e

WORKSPACE="/Users/jinpeng/.openclaw/workspace"
DATE=$(date '+%Y-%m-%d')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
HOUR=$(date '+%H')
MINUTE=$(date '+%M')

# 学习总结文件
SUMMARY_FILE="$WORKSPACE/memory/daily-learning/${DATE}-summary.md"
LEARNING_LOG="$WORKSPACE/memory/${DATE}.md"
AI_SESSION_FILE="$WORKSPACE/.tmp/ai_learning_${DATE}_${HOUR}.json"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠️]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_ai() {
    echo -e "${CYAN}[🤖 AI]${NC} $1"
}

# 如果是第一次运行，初始化摘要文件
if [ ! -f "$SUMMARY_FILE" ]; then
    mkdir -p "$WORKSPACE/memory/daily-learning"
    cat > "$SUMMARY_FILE" << 'EOF'
# 📚 Daily Learning Summary

## Day X - YYYY-MM-DD

---

### 🔍 深度调研 (5 次)

### 📚 新知识 (5 次)

### 📝 文档输出 (4 次)

### 💻 实践操作 (3 次)

### 🔄 复习巩固 (3 次)

---

*AI 辅助生成*
EOF
    print_info "初始化学习摘要文件：$SUMMARY_FILE"
fi

# 读取当天学习主题
CURRENT_TOPIC="量化/股票"  # 默认
if [ -f "$WORKSPACE/HEARTBEAT.md" ]; then
    TOPIC=$(grep -A1 "Day 1" "$WORKSPACE/HEARTBEAT.md" | grep "主攻" | sed 's/.*主攻 [：:]* *//' | tr -d ' *')
    if [ -n "$TOPIC" ]; then
        CURRENT_TOPIC="$TOPIC"
    fi
fi

print_ai "今日学习主题：$CURRENT_TOPIC"

# 创建临时目录
mkdir -p "$WORKSPACE/.tmp"

# ==================== OpenClaw AI 辅助学习 ====================
print_ai "启动 OpenClaw AI 辅助学习..."

# 构建 AI 学习提示词
AI_PROMPT="你现在是我的学习助手。我正在学习【${CURRENT_TOPIC}】。

请帮助我完成以下任务：

1. **知识点讲解** (5 分钟)
   - 讲解 1 个核心概念
   - 提供实际案例
   - 说明应用场景

2. **实践指导** (10 分钟)
   - 给出一个具体的小任务
   - 提供代码示例或步骤
   - 说明预期结果

3. **学习总结** (3 分钟)
   - 总结关键要点 (3 条)
   - 指出常见误区
   - 给出下一步建议

请用简洁清晰的方式回答，适合快速学习。"

# 调用 OpenClaw agent
print_info "调用 OpenClaw agent..."
cd "$WORKSPACE"

# 执行 AI 对话并保存结果 (使用 local 模式，不需要 session)
if openclaw agent --local --message "$AI_PROMPT" --json > "$AI_SESSION_FILE" 2>&1; then
    print_success "AI 响应获取成功"
    
    # 提取 AI 回复内容
    AI_RESPONSE=$(cat "$AI_SESSION_FILE" | grep -o '"content":"[^"]*"' | head -1 | sed 's/"content":"//;s/"$//' | sed 's/\\n/\n/g')
    
    if [ -n "$AI_RESPONSE" ]; then
        print_ai "AI 学习内容:"
        echo "$AI_RESPONSE" | head -20
        
        # 生成学习记录
        echo "### $HOUR:$MINUTE - AI 辅助学习" >> "$LEARNING_LOG"
        echo "- 时间：$TIMESTAMP" >> "$LEARNING_LOG"
        echo "- 领域：$CURRENT_TOPIC" >> "$LEARNING_LOG"
        echo "- 方式：🤖 AI 对话" >> "$LEARNING_LOG"
        echo "- 状态：✅ 已完成" >> "$LEARNING_LOG"
        echo "" >> "$LEARNING_LOG"
        
        # 保存详细学习笔记
        AI_NOTE_FILE="$WORKSPACE/memory/ai-notes/${DATE}_${HOUR}.md"
        mkdir -p "$(dirname "$AI_NOTE_FILE")"
        cat > "$AI_NOTE_FILE" << EOF
# AI 辅助学习笔记

**时间**: $TIMESTAMP
**主题**: $CURRENT_TOPIC
**会话**: $HOUR:$MINUTE

---

## AI 讲解内容

$AI_RESPONSE

---

*由 OpenClaw AI 生成*
EOF
        
        print_success "学习笔记已保存：$AI_NOTE_FILE"
        
        # 根据 AI 内容生成提交信息
        COMMIT_TYPE="docs"
        case "$CURRENT_TOPIC" in
            "量化/股票") COMMIT_TYPE="docs" ;;
            "技术栈"|"AI/Agent") COMMIT_TYPE="feat" ;;
            "系统架构") COMMIT_TYPE="refactor" ;;
            *) COMMIT_TYPE="chore" ;;
        esac
        
        # 提取 AI 内容关键词 (简化版)
        KEYWORD=$(echo "$AI_RESPONSE" | grep -o "[A-Za-z0-9\u4e00-\u9fa5]\{2,8\}" | head -3 | tr '\n' '-' | sed 's/-$//')
        if [ -z "$KEYWORD" ]; then
            KEYWORD="AI 辅助学习"
        fi
        
        COMMIT_MSG="${COMMIT_TYPE}(${CURRENT_TOPIC}): AI 辅助-${KEYWORD} | ${HOUR}:${MINUTE}"
        
    else
        print_warning "AI 响应为空"
        echo "### $HOUR:$MINUTE - AI 辅助学习" >> "$LEARNING_LOG"
        echo "- 时间：$TIMESTAMP" >> "$LEARNING_LOG"
        echo "- 领域：$CURRENT_TOPIC" >> "$LEARNING_LOG"
        echo "- 方式：🤖 AI 对话" >> "$LEARNING_LOG"
        echo "- 状态：⚠️ 响应为空" >> "$LEARNING_LOG"
        echo "" >> "$LEARNING_LOG"
        COMMIT_MSG="chore(learning): AI 辅助学习 | ${HOUR}:${MINUTE} [空响应]"
    fi
else
    print_error "AI 调用失败"
    echo "### $HOUR:$MINUTE - AI 辅助学习" >> "$LEARNING_LOG"
    echo "- 时间：$TIMESTAMP" >> "$LEARNING_LOG"
    echo "- 领域：$CURRENT_TOPIC" >> "$LEARNING_LOG"
    echo "- 方式：🤖 AI 对话" >> "$LEARNING_LOG"
    echo "- 状态：❌ 调用失败" >> "$LEARNING_LOG"
    echo "" >> "$LEARNING_LOG"
    COMMIT_MSG="chore(learning): AI 辅助学习失败 | ${HOUR}:${MINUTE}"
fi

# ==================== Git 提交并推送 ====================
print_info "提交信息：$COMMIT_MSG"

cd "$WORKSPACE"
git add -A > /dev/null 2>&1

# 检查是否有内容需要提交
if git diff --cached --quiet 2>/dev/null; then
    print_warning "无新内容需要提交"
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
        print_success "$TIMESTAMP"
        echo "  主题：$CURRENT_TOPIC"
        echo "  方式：AI 辅助学习"
        echo "  提交：$COMMIT_MSG"
        echo "  推送：✅ 已推送到 GitHub"
    else
        print_error "推送失败"
        cat /tmp/git_push.log
    fi
fi

# ==================== 每日学习统计 ====================
if [ "$HOUR" = "23" ] && [ "$MINUTE" -ge "55" ]; then
    print_info "生成今日学习统计..."
    TODAY_COMMITS=$(git log --oneline --since="00:00" --until="23:59" | wc -l | tr -d ' ')
    AI_SESSIONS=$(ls -1 "$WORKSPACE/memory/ai-notes/${DATE}_"*.md 2>/dev/null | wc -l | tr -d ' ')
    
    print_info "📊 今日统计:"
    print_info "  - 提交次数：$TODAY_COMMITS"
    print_info "  - AI 学习会话：$AI_SESSIONS"
    print_info "  - 学习领域：$CURRENT_TOPIC"
fi

# 清理临时文件 (保留最近 3 个)
if [ -d "$WORKSPACE/.tmp" ]; then
    ls -t "$WORKSPACE/.tmp"/ai_learning_*.json 2>/dev/null | tail -n +4 | xargs rm -f 2>/dev/null || true
fi

print_success "学习循环完成"
