#!/usr/bin/env bash
# Render one image with Koma — the smallest complete call.
#
#   HANZO_API_KEY=... ./examples/generate.sh "a red cube on a white table" 1792x1024
#
# Writes /tmp/koma.jpg and prints its size. A 422 naming a pixel count or a list
# of legal edges means the deployed zen predates size fitting; see LLM.md.
set -euo pipefail

prompt=${1:?usage: generate.sh <prompt> [WxH]}
size=${2:-1024x1024}
: "${HANZO_API_KEY:?set HANZO_API_KEY (https://platform.hanzo.ai → API keys)}"

body=$(printf '{"model":"koma","prompt":%s,"size":"%s"}' \
  "$(printf '%s' "$prompt" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')" \
  "$size")

curl -sS https://api.hanzo.ai/v1/images/generations \
  -H "Authorization: Bearer $HANZO_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$body" \
  | python3 -c '
import base64, json, sys
d = json.load(sys.stdin)
if "data" not in d:
    sys.exit("koma refused: " + json.dumps(d)[:400])
open("/tmp/koma.jpg", "wb").write(base64.b64decode(d["data"][0]["b64_json"]))
'

file /tmp/koma.jpg
