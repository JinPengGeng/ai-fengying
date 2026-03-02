#!/usr/bin/env python3
"""
尝试通过各种免费的 SMTP 服务发送邮件
"""

import smtplib
import socket
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import sys

def test_smtp_connection(host, port, timeout=5):
    """测试 SMTP 连接"""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        result = sock.connect_ex((host, port))
        sock.close()
        if result == 0:
            print(f"✓ {host}:{port} - 端口开放")
            return True
        else:
            print(f"✗ {host}:{port} - 端口关闭")
            return False
    except Exception as e:
        print(f"✗ {host}:{port} - 错误: {e}")
        return False

# 测试常见的 SMTP 端口
smtp_servers = [
    ("smtp.gmail.com", 587),
    ("smtp.gmail.com", 465),
    ("smtp.live.com", 587),
    ("smtp-mail.outlook.com", 587),
    ("smtp.office365.com", 587),
    ("smtp.mail.yahoo.com", 587),
    ("smtp.mail.yahoo.com", 465),
    ("smtp.aol.com", 587),
]

print("测试 SMTP 服务器连接...")
print("=" * 50)

for host, port in smtp_servers:
    test_smtp_connection(host, port)

print("=" * 50)
print("\n注意：大多数 SMTP 服务器需要认证")
print("需要提供有效的邮箱账户和密码才能发送邮件")
