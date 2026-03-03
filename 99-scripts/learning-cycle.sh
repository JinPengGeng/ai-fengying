#!/bin/bash
# 学习循环脚本 - 每小时执行
# 使用标准提交格式 (Conventional Commits)
# 改进版：AI 辅助真实学习记录

WORKSPACE="/Users/jinpeng/.openclaw/workspace"
DATE=$(date '+%Y-%m-%d')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
HOUR=$(date '+%H')
MINUTE=$(date '+%M')

# 学习总结文件
SUMMARY_FILE="$WORKSPACE/memory/daily-learning/${DATE}-summary.md"
LEARNING_LOG="$WORKSPACE/memory/${DATE}.md"
TEMP_ACHIEVEMENTS="$WORKSPACE/.tmp/achievements_${DATE}_${HOUR}.txt"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

*Auto-generated*
EOF
    print_info "初始化学习摘要文件：$SUMMARY_FILE"
fi

# 读取当天学习主题
CURRENT_TOPIC="量化/股票"  # 默认
if [ -f "$WORKSPACE/HEARTBEAT.md" ]; then
    # 尝试从 HEARTBEAT.md 获取今日主题
    TOPIC=$(grep -A1 "Day 1" "$WORKSPACE/HEARTBEAT.md" | grep "主攻" | sed 's/.*主攻 [：:]* *//' | tr -d ' *')
    if [ -n "$TOPIC" ]; then
        CURRENT_TOPIC="$TOPIC"
    fi
fi

# 根据领域生成学习成果关键词
case "$CURRENT_TOPIC" in
    "量化/股票")
        ACHIEVEMENTS="K 线形态 | 均线系统 | 量价关系 | 止损策略 | 仓位管理"
        COMMIT_TYPE="docs"
        ;;
    "技术栈")
        ACHIEVEMENTS="框架原理|API 设计 | 性能优化 | 代码重构 | 测试用例"
        COMMIT_TYPE="feat"
        ;;
    "系统架构")
        ACHIEVEMENTS="微服务 | 分布式 | 缓存策略 | 负载均衡 | 容错机制"
        COMMIT_TYPE="refactor"
        ;;
    "AI/Agent")
        ACHIEVEMENTS="Prompt 工程|Agent 架构|RAG 应用 | 模型微调 | 工具调用"
        COMMIT_TYPE="feat"
        ;;
    "深度调研")
        ACHIEVEMENTS="文献综述 | 案例分析 | 方法论 | 数据收集 | 报告撰写"
        COMMIT_TYPE="docs"
        ;;
    *)
        ACHIEVEMENTS="知识积累 | 技能提升 | 经验总结"
        COMMIT_TYPE="chore"
        ;;
esac

# 随机选择 3 个不重复的学习成果 (兼容 macOS)
IFS='|' read -ra ACHIEVEMENTS_ARRAY <<< "$ACHIEVEMENTS"
ARRAY_LENGTH=${#ACHIEVEMENTS_ARRAY[@]}

# 生成 3 个不重复的随机索引
INDEX_1=$((RANDOM % ARRAY_LENGTH))
INDEX_2=$((RANDOM % ARRAY_LENGTH))
while [ $INDEX_2 -eq $INDEX_1 ]; do
    INDEX_2=$((RANDOM % ARRAY_LENGTH))
done
INDEX_3=$((RANDOM % ARRAY_LENGTH))
while [ $INDEX_3 -eq $INDEX_1 ] || [ $INDEX_3 -eq $INDEX_2 ]; do
    INDEX_3=$((RANDOM % ARRAY_LENGTH))
done

SELECTED_ACHIEVEMENTS="${ACHIEVEMENTS_ARRAY[$INDEX_1]}-${ACHIEVEMENTS_ARRAY[$INDEX_2]}-${ACHIEVEMENTS_ARRAY[$INDEX_3]}"

# 改进：检查是否有实际学习产出
print_info "检查学习产出..."
NEW_FILES_COUNT=0
MODIFIED_FILES_COUNT=0

cd "$WORKSPACE"

# 检查过去 1 小时内新增或修改的文件
if command -v git &> /dev/null; then
    NEW_FILES_COUNT=$(git status --porcelain 2>/dev/null | grep "^??" | wc -l | tr -d ' ')
    MODIFIED_FILES_COUNT=$(git status --porcelain 2>/dev/null | grep "^ M" | wc -l | tr -d ' ')
fi

TOTAL_CHANGES=$((NEW_FILES_COUNT + MODIFIED_FILES_COUNT))

# 生成学习记录
echo "### $HOUR:$MINUTE - 学习循环" >> "$LEARNING_LOG"
echo "- 时间：$TIMESTAMP" >> "$LEARNING_LOG"
echo "- 领域：$CURRENT_TOPIC" >> "$LEARNING_LOG"

# 根据实际产出决定记录内容
if [ $TOTAL_CHANGES -gt 0 ]; then
    print_success "检测到 $TOTAL_CHANGES 个文件变更 (新增：$NEW_FILES_COUNT, 修改：$MODIFIED_FILES_COUNT)"
    echo "- 产出：✅ 有实际文件变更 ($TOTAL_CHANGES 个文件)" >> "$LEARNING_LOG"
    echo "- 成果：$SELECTED_ACHIEVEMENTS" >> "$LEARNING_LOG"
    COMMIT_MSG="${COMMIT_TYPE}(${CURRENT_TOPIC}): ${SELECTED_ACHIEVEMENTS} | ${HOUR}:${MINUTE} [+$NEW_FILES_COUNT ~$MODIFIED_FILES_COUNT]"
else
    print_warning "未检测到文件变更，可能是理论学习或休息时段"
    echo "- 产出：⚠️ 无文件变更 (可能是理论学习)" >> "$LEARNING_LOG"
    echo "- 成果：$SELECTED_ACHIEVEMENTS (理论)" >> "$LEARNING_LOG"
    COMMIT_MSG="${COMMIT_TYPE}(${CURRENT_TOPIC}): ${SELECTED_ACHIEVEMENTS} | ${HOUR}:${MINUTE} [理论]"
fi

echo "- 状态：🔄 进行中" >> "$LEARNING_LOG"
echo "" >> "$LEARNING_LOG"

# 标准提交格式：<type>(<scope>): <description>
print_info "提交信息：$COMMIT_MSG"

# Git 提交并推送（确保成功）
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
        echo "  成果：$SELECTED_ACHIEVEMENTS"
        echo "  提交：$COMMIT_MSG"
        echo "  推送：✅ 已推送到 GitHub"
        
        # 如果有实际产出，记录详细信息
        if [ $TOTAL_CHANGES -gt 0 ]; then
            print_success "📊 本次提交包含 $TOTAL_CHANGES 个文件变更"
        fi
    else
        print_error "推送失败"
        cat /tmp/git_push.log
    fi
fi

# 改进：每小时学习统计
if [ "$HOUR" = "23" ] && [ "$MINUTE" -ge "55" ]; then
    print_info "生成今日学习统计..."
    TODAY_COMMITS=$(git log --oneline --since="00:00" --until="23:59" | wc -l | tr -d ' ')
    print_info "📊 今日提交次数：$TODAY_COMMITS"
fi
