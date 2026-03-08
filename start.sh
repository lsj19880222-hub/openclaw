#!/bin/sh
mkdir -p /tmp/.openclaw
echo '{"gateway":{"controlUi":{"dangerouslyAllowHostHeaderOriginFallback":true}},"channels":{"telegram":{"botToken":"'"$TELEGRAM_BOT_TOKEN"'","dmPolicy":"open","allowFrom":["*"],"groupPolicy":"open","groupAllowFrom":["*"]}}}' > /tmp/.openclaw/openclaw.json
node openclaw.mjs gateway --bind lan --port 8080 --allow-unconfigured &
GATEWAY_PID=$!
sleep 30
node openclaw.mjs devices list 2>/dev/null | awk -F'│' '{gsub(/ /,"",$2)} $2~/^[0-9a-f].*-/{print $2}' | while read id; do node openclaw.mjs devices approve "$id" 2>/dev/null; done
wait $GATEWAY_PID
