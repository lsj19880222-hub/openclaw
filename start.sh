#!/bin/sh
mkdir -p /tmp/.openclaw

# 核心配置：注入硅基流动 (SiliconFlow) 作为模型供应商
printf '{
  "gateway": {
    "bind": "lan",
    "controlUi": {
      "dangerouslyAllowHostHeaderOriginFallback": true
    }
  },
  "modelProviders": {
    "siliconflow": {
      "api": "openai",
      "baseUrl": "https://api.siliconflow.cn/v1",
      "apiKey": "%s"
    }
  },
  "agents": {
    "defaults": {
      "model": "siliconflow:%s"
    }
  },
  "channels": {
    "telegram": {
      "botToken": "%s",
      "dmPolicy": "open",
      "allowFrom": ["*"],
      "groupPolicy": "open",
      "groupAllowFrom": ["*"]
    },
    "feishu": {
      "accounts": {
        "main": {
          "appId": "%s",
          "appSecret": "%s",
          "verificationToken": "%s",
          "encryptKey": "%s"
        }
      }
    }
  }
}' \
"$SILICONFLOW_API_KEY" \
"$MY_MODEL" \
"$TELEGRAM_BOT_TOKEN" \
"$FEISHU_APP_ID" \
"$FEISHU_APP_SECRET" \
"$FEISHU_VERIFICATION_TOKEN" \
"$FEISHU_ENCRYPT_KEY" > /tmp/.openclaw/openclaw.json

node openclaw.mjs gateway --port 8080 --allow-unconfigured
