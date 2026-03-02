# Skill 安全规则

## 规则：安装新 Skill 前必须安全审计

**生效日期**: 2026-02-16  
**规则**: 所有新添加的 OpenClaw Skill 必须通过 `skill-security-audit` 安全扫描，确认无问题后方可安装和使用

---

## 背景

AI Agent 的 Skill 可能存在以下安全风险：
- **后门**: 恶意代码、隐藏执行
- **凭证窃取**: 键盘记录、钥匙串访问
- **数据外传**: 上传敏感文件
- **供应链攻击**: 依赖恶意包、npm postinstall 陷阱

---

## 执行流程

### 安装新 Skill 前

```bash
# 1. 安装 skill
clawhub install <skill-name>

# 2. 运行安全审计
python3 ~/.claude/skills/skill-security-audit/scripts/skill_audit.py --path ~/.claude/skills/<skill-name>

# 3. 检查结果
# - CRITICAL/HIGH: 立即删除，不允许使用
# - MEDIUM: 人工审查，确认无风险后可使用
# - LOW/无问题: 允许使用
```

### 审计结果判定

| 严重级别 | 结果 | 行动 |
|----------|------|------|
| **CRITICAL** | 发现恶意 IOC、凭证窃取 | 🚫 立即删除 + 凭证轮换 |
| **HIGH** | 混淆、持久化、权限提升 | 🚫 人工审查，疑似恶意 |
| **MEDIUM** | 可疑模式（Base64、网络调用） | ⚠️ 审查上下文后决定 |
| **LOW** | 社会工程命名 | 📝 记录知晓 |

---

## 责任

- **安装者**: 负责在安装新 Skill 前运行审计
- **使用者**: 使用前确认已通过审计
- **定期检查**: 建议每月对所有已安装 Skill 进行全面扫描

---

## 相关命令

```bash
# 扫描所有已安装 skills
python3 ~/.claude/skills/skill-security-audit/scripts/skill_audit.py

# 扫描单个 skill
python3 ~/.claude/skills/skill-security-audit/scripts/skill_audit.py --path /path/to/skill

# JSON 格式输出
python3 ~/.claude/skills/skill-security-audit/scripts/skill_audit.py --json
```

---

*规则制定时间: 2026-02-16*
