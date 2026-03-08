#!/bin/sh
mkdir -p /tmp/.openclaw

# 核心配置：明确指定 Groq 的 Llama 4 Maverick 视觉模型
cat > /tmp/.openclaw/openclaw.json << EOF
{
  "gateway": {
    "bind": "lan",
    "controlUi": {
      "dangerouslyAllowHostHeaderOriginFallback": true
    }
  },
  "agents": {
    "defaults": {
      "model": "MY_MODEL"
    }
  },
  "channels": {
    "telegram": {
      "botToken": "$TELEGRAM_BOT_TOKEN",
      "dmPolicy": "open",
      "allowFrom": ["*"],
      "groupPolicy": "open",
      "groupAllowFrom": ["*"]
    },
    "feishu": {
      "accounts": {
        "main": {
          "appId": "$FEISHU_APP_ID",
          "appSecret": "$FEISHU_APP_SECRET",
          "verificationToken": "$FEISHU_VERIFICATION_TOKEN",
          "encryptKey": "$FEISHU_ENCRYPT_KEY"
        }
      }
    }
  }
}
EOF

# 安装飞书依赖（针对 512MB 内存做的最小化尝试）
cd /app && npm install --no-optional @larksuiteoapi/node-sdk 2>/dev/null || echo "Skip optional deps"

exec node openclaw.mjs gateway --port 8080 --allow-unconfigured
