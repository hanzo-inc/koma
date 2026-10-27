<p align="center"><b>koma</b><br><i>Hanzo's image model</i></p>

# Koma

Koma is Hanzo's image model, served from Hanzo's own inference fabric at
`api.hanzo.ai` under the single id **`koma`**. It renders one image per request
from a text prompt, at any aspect ratio from a 9:21 portrait to a 21:9 banner.

```bash
curl https://api.hanzo.ai/v1/images/generations \
  -H "Authorization: Bearer $HANZO_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"koma","prompt":"a red cube on a white table","size":"1792x1024"}'
```

```json
{"data":[{"b64_json":"/9j/4AAQSkZJRgABAQAAAQABAAD…"}]}
```

That is the whole API: the OpenAI images schema, one model id, no vendor
vocabulary to learn. Koma answers `b64_json` whatever `response_format` asks for.

## What it renders

| | |
|---|---|
| Modes | text → image |
| Output | JPEG, base64 in the OpenAI `data[].b64_json` envelope |
| Images per request | 1 |
| Aspect ratios | 9:21 5:11 1:2 7:13 3:5 2:3 3:4 6:7 1:1 7:6 4:3 3:2 5:3 13:7 2:1 11:5 21:9 |
| Sizes | any `size` you send; Koma fits it to the nearest ratio it can draw |
| Latency | 1.6 s to 4.4 s per render, measured on production hardware |

Koma is a **single image per call**, and says so rather than quietly serving one
for an `n` of four: `n: 4` is refused with a message that asks for one call per
image. The per-image price is then right for what was delivered.

### Sizes

You may ask for the size you actually want — `1792x1024`, `1024x1792`,
`1536x1024`, `256x256`. Koma **fits** the request to the nearest renderable shape
instead of refusing it, because the raw render ladder is narrower than the sizes
people ask for: each edge is on a 16-pixel grid between 512 and 1568, and the
whole image is at most 1,062,400 pixels. `1792x1024` becomes `1344x768` — the
same 7:4 ratio, the largest render that fits.

`aspect_ratio` wins when you send it, and drops `size`/`width`/`height`. Stating
both is a contradiction, not a preference.

| you ask | you get | ratio |
|---|---|---|
| `1024x1024` | `1024x1024` | 1:1 |
| `1792x1024` | `1344x768` | 7:4 |
| `1024x1792` | `768x1344` | 3:7 |
| `1536x1024` | `1248x832` | 3:2 |
| `512x512` | `512x512` | 1:1 |
| `256x256` | `512x512` | lifted to the floor |

## Pricing

**$0.16 per image**, flat. No charge for a refused request, and no charge for an
image that failed to render. Koma is a paid model: free accounts reach it on the
free allowance (50 requests a day), a paid plan reaches it on its own included
usage.

| | |
|---|---|
| Model id | `koma` |
| Price | $0.16 / image |
| Endpoint | `POST /v1/images/generations` |
| Minimum tier | paid |

## Not Koma

- **Image editing** is not available on Koma yet. `POST /v1/images/edits` and an
  `image` field are refused rather than silently ignored.
- **Video** is not Koma. There is no video model on the platform today.

## Surfaces

Koma is a product SKU, not a repository you run. The inference lives in
[`hanzo-inc/zen`](https://github.com/hanzo-inc/zen); the catalog that names it
(price, rungs, retail) is declared in `hanzo/universe`
(`charts/app/files/zen/catalog.yaml`) and reconciled by Hanzo CD.

- API and docs: <https://api.hanzo.ai/v1>, <https://docs.hanzo.ai>
- Dashboard: <https://platform.hanzo.ai>
- Agent notes for this repo: [LLM.md](./LLM.md)

## License

The contents of this repository are licensed under Apache-2.0. The model Koma
serves is proprietary and **no weights are distributed** — Koma is available only
through the Hanzo API under the [Hanzo Terms](https://hanzo.ai/terms).
