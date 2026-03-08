#!/bin/sh
mkdir -p /tmp/.openclaw

# 核心配置：使用 printf 防止变量解析失败
printf '{"gateway":{"bind":"lan","controlUi":{"dangerouslyAllowHostHeaderOriginFallback":true}},"agents":{"defaults":{"model":"%s"}},"channels":{"telegram":{"botToken":"%s","dmPolicy":"open","allowFrom":["*"],"groupPolicy":"open","groupAllowFrom":["*"]},"feishu":{"accounts":{"main":{"appId":"%s","appSecret":"%s","verificationToken":"%s","encryptKey":"%s"}}}}}' \
"$MY_MODEL" \
"$TELEGRAM_BOT_TOKEN" \
"$FEISHU_APP_ID" \
"$FEISHU_APP_SECRET" \
"$FEISHU_VERIFICATION_TOKEN" \
"$FEISHU_ENCRYPT_KEY" > /tmp/.openclaw/openclaw.json

# 飞书：既然在线装不上，我命令你用轻量模式启动（至少保证不爆内存）
node openclaw.mjs gateway --port 8080 --allow-unconfigured
