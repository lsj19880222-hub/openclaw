#!/bin/sh
mkdir -p /tmp/.openclaw
echo '{"gateway":{"controlUi":{"dangerouslyAllowHostHeaderOriginFallback":true}}}' > /tmp/.openclaw/openclaw.json
cd /app && npx pnpm add @larksuiteoapi/node-sdk 2>/dev/null
(sleep 30; while true; do node openclaw.mjs devices list 2>/dev/null | grep -oE '[0-9a-f-]\{36\}' | while read id; do node openclaw.mjs devices approve "$id" 2>/dev/null; done; sleep 5; done) &
exec node openclaw.mjs gateway --bind lan --port 8080 --allow-unconfigured
