# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

### Proton Mail（风影的个人邮箱）

- **邮箱**：fengying2026@proton.me
- **用途**：自主学习、注册服务
- **备注**：密码已保存至系统钥匙串

---

### 🛡️ Skill 安全规则

**规则**: 所有新添加的 Skill 必须通过 `skill-security-audit` 审计后才能使用

**详细规则**: 参见 `规则/skill-security-rule.md`

**执行**:
```bash
python3 ~/.claude/skills/skill-security-audit/scripts/skill_audit.py --path <skill-path>
```
