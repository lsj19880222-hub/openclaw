#!/bin/sh
mkdir -p /tmp/.openclaw
printf '{
  "gateway":{
    "bind":"lan",
    "controlUi":{"dangerouslyAllowHostHeaderOriginFallback":true}
  },
  "agents":{
    "defaults":{
      "model":"groq/meta-llama/llama-4-maverick-17b-128e-instruct"
    }
  }
}' > /tmp/.openclaw/openclaw.json
exec node openclaw.mjs gateway --port 8080 --allow-unconfigured
