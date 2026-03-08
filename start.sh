#!/bin/sh
mkdir -p /tmp/.openclaw

cat > /tmp/.open#!/bin/sh
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
      "botToken": "$TELEGRAM_BOT_TOKEN"
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

# 启动网关
node openclaw.mjs gateway --port 8080 --allow-unconfigured &
GATEWAY_PID=$!

# 后台自动批准所有待配对的设备请求（每5秒扫描一次）
(
  sleep 25
  while true; do
    echo "=== 正在扫描并自动批准待配对设备 ==="
    node openclaw.mjs devices list 2>/dev/null | grep -oE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' | while read reqId; do
      echo "批准设备: $reqId"
      node openclaw.mjs devices approve "$reqId" 2>/dev/null && echo "批准成功: $reqId"
    done
    sleep 5
  done
) &

wait $GATEWAY_PID
claw/openclaw.json << EOF
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
      "botToken": "$TELEGRAM_BOT_TOKEN"
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

node openclaw.mjs gateway --port 8080 --allow-unconfigured &
GATEWAY_PID=$!

sleep 20
echo "========================================"
echo "=== 复制下面链接中的 #token= 部分到浏览器地址后面 ==="
node openclaw.mjs dashboard --no-open 2>&1
echo "========================================"

wait $GATEWAY_PID
