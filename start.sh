#!/bin/sh
mkdir -p /tmp/.openclaw

printf '{
  "gateway": {
    "bind": "lan",
    "controlUi": {
      "dangerouslyAllowHostHeaderOriginFallback": true
    }
  },
  "models": {
    "providers": {
      "siliconflow": {
        "api": "openai-completions",
        "baseUrl": "https://api.siliconflow.cn/v1",
        "apiKey": "%s",
        "models": [
          {
            "id": "%s",
            "name": "%s"
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": "siliconflow/%s"
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
      "dmPolicy": "open",
      "allowFrom": ["*"],
      "groupPolicy": "open",
      "groupAllowFrom": ["*"],
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
"$MY_MODEL" \
"$MY_MODEL" \
"$TELEGRAM_BOT_TOKEN" \
"$FEISHU_APP_ID" \
"$FEISHU_APP_SECRET" \
"$FEISHU_VERIFICATION_TOKEN" \
"$FEISHU_ENCRYPT_KEY" > /tmp/.openclaw/openclaw.json

node openclaw.mjs gateway --port 8080 --allow-unconfigured
