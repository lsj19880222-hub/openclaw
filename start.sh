#!/bin/sh
mkdir -p /tmp/.openclaw

printf '{"gateway":{"bind":"lan","trustedProxies":["10.0.0.0/8","172.16.0.0/12","192.168.0.0/16","127.0.0.1"],"controlUi":{"dangerouslyAllowHostHeaderOriginFallback":true}},"agents":{"defaults":{"model":"groq/meta-llama/llama-4-maverick-17b-128e-instruct"}}}' > /tmp/.openclaw/openclaw.json

# 后台每5秒自动批准一次待处理的配对请求
(sleep 25; while true; do
  node openclaw.mjs devices approve --all 2>/dev/null || \
  node openclaw.mjs devices list 2>&1 | head -20
  sleep 5
done) &

exec node openclaw.mjs gateway --port 8080 --allow-unconfigured
