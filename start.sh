#!/bin/sh
mkdir -p /tmp/.openclaw
printf '{
  "gateway":{
    "bind":"lan",
    "controlUi":{"dangerouslyAllowHostHeaderOriginFallback":true}
  },
  "agents":{
    "defaults":{
      "model":"groq/llama-3.3-70b-versatile"
    }
  }
}' > /tmp/.openclaw/openclaw.json
exec node openclaw.mjs gateway --port 8080 --allow-unconfigured
