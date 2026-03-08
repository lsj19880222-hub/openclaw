#!/bin/sh
mkdir -p /tmp/.openclaw
echo '{"gateway":{"controlUi":{"dangerouslyAllowHostHeaderOriginFallback":true}},"channels":{"telegram":{"botToken":"'"$TELEGRAM_BOT_TOKEN"'","dmPolicy":"open","groupPolicy":"open"},"feishu":{"accounts":{"main":{"appId":"'"$FEISHU_APP_ID"'","appSecret":"'"$FEISHU_APP_SECRET"'","verificationToken":"'"$FEISHU_VERIFICATION_TOKEN"'","encryptKey":"'"$FEISHU_ENCRYPT_KEY"'"}}}}}' > /tmp/.openclaw/openclaw.json
cd /app && npx pnpm add @larksuiteoapi/node-sdk 2>/dev/null
node openclaw.mjs gateway --bind lan --port 8080 --allow-unconfigured &
GATEWAY_PID=$!
sleep 30
node openclaw.mjs devices list 2>/dev/null | awk -F'│' '{gsub(/ /,"",$2)} $2~/^[0-9a-f].*-/{print $2}' | while read id; do node openclaw.mjs devices approve "$id" 2>/dev/null && echo "设备已批准: $id"; done
wait $GATEWAY_PID
