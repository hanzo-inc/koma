// TypeScript / Bun / Node 22+ example for Koma (駒)
// Run: HANZO_API_KEY=... bun run examples/generate.ts

import { writeFileSync } from "node:fs";

const apiKey = process.env.HANZO_API_KEY;
if (!apiKey) throw new Error("Set HANZO_API_KEY");

const prompt = process.argv[2] ?? "Slow dolly-in across a rain-lit Tokyo alley at night, anamorphic lens";

const res = await fetch("https://api.hanzo.ai/v1/videos/generations", {
  method: "POST",
  headers: {
    Authorization: `Bearer ${apiKey}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    model: "koma",
    prompt: prompt,
  }),
});

if (!res.ok) {
  throw new Error(`koma failed (${res.status}): ${await res.text()}`);
}

const buf = Buffer.from(await res.arrayBuffer());
const outPath = "/tmp/koma.json";
writeFileSync(outPath, buf);
console.log(`Saved ${buf.byteLength} bytes to ${outPath}`);
