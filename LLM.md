# Koma — agent notes

Koma is Hanzo's image SKU. This repo is its **model card and API contract**; no
code runs from here. Read this before changing anything that serves `koma`.

## Where Koma actually lives

| Layer | Repo / file | What it owns |
|---|---|---|
| The SKU, its price, its rungs | `hanzo/universe` → `charts/app/files/zen/catalog.yaml` | the `koma` entry: mode `image`, `min_tier: paid`, `retail: { in: "0.16", out: "0.16" }`, the rungs and their per-model `path:` |
| The serving plane | [`hanzo-inc/zen`](https://github.com/hanzo-inc/zen) → `media.go` | `mediaProxy` (gate, meter, relay), `nativeImage` (request shape), `fitImage`/`imageSize` (size fitting), `openAIImage` (answer shape) |
| The route | cloud, `apps/ai` | `/v1/images/generations` at `api.hanzo.ai`, gated and billed like any model call |
| The catalog row | [`hanzo/ai`](https://github.com/hanzo/ai) → `controllers/zen_client.go` | discovery: it reads zen's `/v1/models` every 5 minutes, so a SKU zen serves appears on `api.hanzo.ai/v1/models` within five minutes of the deploy, with no second change |
| Delivery | `cd.hanzo.ai` | reconciles universe; a catalog edit rolls zen |

Nothing about Koma is configured in this repository. A price change here is a
README edit; the price itself changes in the catalog above.

## Brand policy

Koma is sold as **Koma**. The upstream endpoints that render it are an
implementation detail: they appear in the catalog's `path:`/`upstream:` fields
(which are ours) and in zen's admin catalog view, and they must not appear in
customer-facing copy, the dashboard, `/v1/models`, error messages, or this
README. `/v1/models` publishes the id, the mode, the price and the context — it
publishes no upstream.

## The two translations zen performs

The upstream image endpoints are not the OpenAI schema, and both differences are
handled in `media.go` rather than pushed onto callers.

**Request** (`nativeImage`): the model is named in the URL path, so `model` is
dropped from the body; `n`, `response_format` and `cfg_scale` are dropped; the
OpenAI `size` string becomes a `width`/`height` pair. An `aspect_ratio`, if the
caller sent one, wins and removes the pixel pair — the endpoint refuses both
together.

**Size fitting** (`fitImage`): the renderable pairs are constrained on three axes
at once — each edge on a 16px grid from 512 to 1568, and the whole image inside
1,062,400 pixels. The OpenAI-documented sizes are exactly the ones that violate
it (`1792x1024` is 1,835,008 px; `256x256` is under the floor), so Koma picks the
closest renderable ratio instead of returning a 422 that lists 67 legal numbers.
Among pairs of equal ratio it takes the one closest in area, so a thumbnail is
not answered with four times the pixels for the same single unit.

**Answer** (`openAIImage`): the upstream answers `{"artifacts":[{"base64":…}]}`;
that is translated to `{"data":[{"b64_json":…}]}`. The translation is a *shape*
check, not a vendor check, so a new upstream answering the same way needs no
code change.

## Measured, 2026-10-27

Every size below was sent through a running zen to both configured rungs and
answered `200` with a JPEG:

`1344x768` · `1248x832` · `768x1344` · `512x1568` · `1568x672` · `1024x1024` ·
`512x512` — 1.6 s to 4.4 s per render.

`n: 4` is refused. `aspect_ratio` beside `size` is resolved to `aspect_ratio`.

## Open

- **Image editing** — the upstreams' `image` field takes a bundled `example_id`
  reference, not base64 or a URL, so an edit of the caller's own image is not
  possible on these accounts. `/v1/images/edits` stays unserved, deliberately.
- **Multi-image** — one unit, one image. `n > 1` is a refusal, not a silent
  downgrade.

## Verifying a deploy

```bash
# the SKU is listed, at its price, as an image model
curl -s https://api.hanzo.ai/v1/models | jq '.data[] | select(.id=="koma")'

# a render, at a size the raw endpoint refuses and Koma fits
curl -s https://api.hanzo.ai/v1/images/generations \
  -H "Authorization: Bearer $HANZO_API_KEY" -H 'Content-Type: application/json' \
  -d '{"model":"koma","prompt":"a red cube on a white table","size":"1792x1024"}' \
  | jq -r '.data[0].b64_json' | base64 -d > /tmp/koma.jpg

file /tmp/koma.jpg   # JPEG image data
```

A `422` naming a pixel count or a list of legal edges means `fitImage` did not
run — the deployed zen predates it.
