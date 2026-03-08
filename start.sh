#!/bin/sh
mkdir -p /tmp/.openclaw
printf '{"gateway":{"bind":"lan","trustedProxies":["10.0.0.0/8","172.16.0.0/12","127.0.0.1"],"controlUi":{"dangerouslyAllowHostHeaderOriginFallback":true}},"agents":{"defaults":{"model":"groq/meta-llama/llama-4-maverick-17b-128e-instruct"}},"channels":{"telegram":{"botToken":"'"$TELEGRAM_BOT_TOKEN"'"},"feishu":{"accounts":{"main":{"appId":"'"$FEISHU_APP_ID"'","appSecret":"'"$FEISHU_APP_SECRET"'","verificationToken":"'"$FEISHU_VERIFICATION_TOKEN"'","encryptKey":"'"$FEISHU_ENCRYPT_KEY"'"}}}}}' > /tmp/.openclaw/openclaw.json
node openclaw.mjs gateway --port 8080 --allow-unconfigured &
GATEWAY_PID=$!
sleep 30
node openclaw.mjs devices list 2>/dev/null | grep -oE '[0-9a-f-]{36}' | while read reqId; do node openclaw.mjs devices approve "$reqId" 2>/dev/null; done
wait $GATEWAY_PID
