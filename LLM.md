# Koma — agent notes

Koma (`koma`, `koma-1`) is Hanzo's video generation and motion SKU. This repo is its **model card, API contract, and deployment spec**; inference serving runs in [`hanzo-inc/zen`](https://github.com/hanzo-inc/zen). Read this before changing anything that serves `koma`.

> **Note on image generation**: Image generation moved to its own dedicated SKU and repository, **Iro** ([`hanzo-inc/iro`](https://github.com/hanzo-inc/iro), model id `iro` / `iro-1`). Each creative modality has its own standalone repo (`hanzo-inc/iro`, `hanzo-inc/koma`, `hanzo-inc/koe`, `hanzo-inc/oto`, `hanzo-inc/uta`, `hanzo-inc/mori`).

## Where Koma lives across the stack

| Layer | Repo / file | What it owns |
|---|---|---|
| The SKU, its price, its rungs | `hanzo/universe` → `charts/app/files/zen/catalog.yaml` | `koma` / `koma-1` / `zen-video` / `zen-director` (`mode: video`) |
| The serving plane | [`hanzo-inc/zen`](https://github.com/hanzo-inc/zen) → `media.go`, `catalog.yaml` | `mediaProxy` on `/v1/videos/generations` |
| Cloud gateway & Studio | `hanzo-inc/cloud` → `apps/ai/media_rpc.go`, `apps/studio/exec.go` | `/v1/videos/generations` at `api.hanzo.ai`; Studio step defaults `video.generate` to `koma` |
| 1-click K8s Stack | [`hanzo-inc/platform`](https://github.com/hanzo-inc/platform) → `src/lib/deploy/stacks.ts` | `koma` stack template (`ghcr.io/hanzoai/koma:latest`) |
| Product page | [`hanzo-inc/app`](https://github.com/hanzo-inc/app) → `lib/creative-models.ts` | `/koma` (`koma-1`, open foundation `zen-director` / `zenlm/zen-director`) |

## Verifying a deploy

```bash
# 1. Verify koma is in the live model catalog
curl -s https://api.hanzo.ai/v1/models | jq '.data[] | select(.id=="koma" or .id=="zen-video")'

# 2. Generate video clip with koma
curl -s https://api.hanzo.ai/v1/videos/generations \
  -H "Authorization: Bearer $HANZO_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"koma","prompt":"slow dolly-in across a rain-lit Tokyo alley at night"}'
```
