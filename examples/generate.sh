#!/usr/bin/env bash
# Generate a video clip with Koma — the smallest complete call.
#
#   HANZO_API_KEY=... ./examples/generate.sh "slow dolly-in across a rain-lit Tokyo alley at night"
set -euo pipefail

prompt=${1:?usage: generate.sh <prompt>}
: "${HANZO_API_KEY:?set HANZO_API_KEY (https://platform.hanzo.ai → API keys)}"

body=$(printf '{"model":"koma","prompt":%s}' \
  "$(printf '%s' "$prompt" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')")

curl -sS https://api.hanzo.ai/v1/videos/generations \
  -H "Authorization: Bearer $HANZO_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$body"
