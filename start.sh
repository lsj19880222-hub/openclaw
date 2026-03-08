#!/bin/sh
mkdir -p /tmp/.openclaw

cat > /tmp/.openclaw/openclaw.json << EOF
{
  "gateway": {
    "bind": "lan",
    "trustedProxies": ["10.0.0.0/8", "172.16.0.0/12", "127.0.0.1"],
    "controlUi": {
      "dangerouslyAllowHostHeaderOriginFallback": true
    }
  },
  "agents": {
    "defaults": {
      "model": "groq/meta-llama/llama-4-maverick-17b-128e-instruct"
    }
  },
  "channels": {
    "telegram": {
      "token": "$TELEGRAM_BOT_TOKEN"
    },
    "feishu": {
      "appId": "$FEISHU_APP_ID",
      "appSecret": "$FEISHU_APP_SECRET",
      "verificationToken": "$FEISHU_VERIFICATION_TOKEN",
      "encryptKey": "$FEISHU_ENCRYPT_KEY"
    }
  }
}
EOF

node openclaw.mjs gateway --port 8080 --allow-unconfigured &
GATEWAY_PID=$!

sleep 20
echo "========================================"
echo "=== 复制下面链接中的 #token= 部分到浏览器地址后面 ==="
node openclaw.mjs dashboard --no-open 2>&1
echo "========================================"

wait $GATEWAY_PID
