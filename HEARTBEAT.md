# 💬 微信实时监控

**状态**: 🔄 运行中

---

## 🎯 监控状态

| 组件 | 状态 | 说明 |
|------|------|------|
| 后台监控 | ✅ 运行中 | `/tmp/wechat_with_alert.py` (每秒检查) |
| 文件监听器 | ✅ | `/tmp/wechat_file_watcher.py` |
| 屏幕截图 | ✅ | 使用 peekaboo 备用 |

## 📝 检查命令

```bash
# 方法1: 使用 peekaboo 截图检查
peekaboo image --mode screen --screen-index 0 --path /tmp/wechat_check.png --retina

# 方法2: 检查消息文件
cat /tmp/wechat_realtime_msg.txt
```

## ⚠️ 重要：心跳检查流程

1. 首先使用 peekaboo 截图
2. 读取截图查看是否有来自"金鹏"的新消息
3. 如果有新消息，立即回复！

```bash
# 快速检查脚本
/tmp/wechat_quick_check.sh
```
