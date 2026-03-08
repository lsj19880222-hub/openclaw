#!/bin/sh
mkdir -p /tmp/.openclaw

cat > /tmp/.openclaw/openclaw.json << 'EOF'
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
      "model": "groq/meta-llama/llama-4-maverick-17b-128e-instruct",
      "apiKey": "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"
    }
  },
  "channels": [
    {
      "type": "telegram",
      "token": "8649583026:AAGcEUWw8nVMrmkREnmcVNzKyzL6JSVhWa8"
    },
    {
       "type": "feishu",
      "appId": "cli_a927137e4d78dbc7",
      "appSecret": "uAxIOZfqcpQpgGSC07RbQh7TQ3bQonDo",
      "verificationToken": "Hh5OeGRLSHXlB4x0lRlGlbdzMfpkch3I",
      "encryptKey": "0mvIVE3MDzVQn7fra6NuxtSkNfUJkvtM"
    }
  ]
}
EOF

# 启动网关，后台生成预批准链接
node openclaw.mjs gateway --port 8080 --allow-unconfigured &
GATEWAY_PID=$!

sleep 20
echo "========================================"
echo "=== 复制下面链接中的 #token= 部分到浏览器地址后面 ==="
node openclaw.mjs dashboard --no-open 2>&1
echo "========================================"

wait $GATEWAY_PID
