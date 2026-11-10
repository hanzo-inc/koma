#!/usr/bin/env python3
"""Generate with Koma (駒) via https://api.hanzo.ai/v1/videos/generations."""
import json
import os
import sys
import urllib.request

API_KEY = os.environ["HANZO_API_KEY"]
PROMPT = sys.argv[1] if len(sys.argv) > 1 else "Slow dolly-in across a rain-lit Tokyo alley at night, anamorphic lens"

body = {"model": "koma", "prompt": PROMPT}
if "koma" == "koe":
    body["voice"] = "alloy"

req = urllib.request.Request(
    "https://api.hanzo.ai/v1/videos/generations",
    data=json.dumps(body).encode(),
    headers={
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json",
    },
)
with urllib.request.urlopen(req, timeout=120) as resp:
    raw = resp.read()

out_path = "/tmp/koma.json"
with open(out_path, "wb") as f:
    f.write(raw)
print(f"Wrote {len(raw)} bytes to {out_path}")
