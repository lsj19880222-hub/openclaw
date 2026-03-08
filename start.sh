#!/bin/sh
mkdir -p /tmp/.openclaw
echo '{"gateway":{"controlUi":{"dangerouslyAllowHostHeaderOriginFallback":true}},"channels":{"telegram":{"botToken":"'"$TELEGRAM_BOT_TOKEN"'","dmPolicy":"open","allowFrom":["*"],"groupPolicy":"open","groupAllowFrom":["*"]},"feishu":{"accounts":{"main":{"appId":"'"$FEISHU_APP_ID"'","appSecret":"'"$FEISHU_APP_SECRET"'","verificationToken":"'"$FEISHU_VERIFICATION_TOKEN"'","encryptKey":"'"$FEISHU_ENCRYPT_KEY"'"}}}}}' > /tmp/.openclaw/openclaw.json
cd /app && npm install --no-optional @larksuiteoapi/node-sdk 2>/dev/null
exec node openclaw.mjs gateway --bind lan --port 8080 --allow-unconfigured
