#!/bin/sh
mkdir -p /tmp/.openclaw
printf '{"gateway":{"bind":"lan","controlUi":{"dangerouslyAllowHostHeaderOriginFallback":true}}}' > /tmp/.openclaw/openclaw.json
exec node openclaw.mjs gateway --port 8080 --allow-unconfigured
