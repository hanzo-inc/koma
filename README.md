<p align="center"><b>koma (駒)</b><br><i>Hanzo's video generation & motion model</i></p>

# Koma

Koma (`koma`, `koma-1`) is Hanzo's video generation and motion model, served from Hanzo's inference fabric at `api.hanzo.ai` under the canonical id **`koma`** (open foundation: **`zen-director`** / [`zenlm/zen-director`](https://github.com/zenlm/zen-director)). It generates cinematic video clips with temporal character continuity, parametric camera choreography, and keyframe-guided motion trajectories.

```bash
curl https://api.hanzo.ai/v1/videos/generations \
  -H "Authorization: Bearer $HANZO_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"koma","prompt":"slow dolly-in across a rain-lit Tokyo alley at night, anamorphic 35mm lens"}'
```

## Capabilities

| | |
|---|---|
| Modes | text → video, image + text → video (`/v1/videos/generations`) |
| Model IDs | `koma`, `koma-1` (open foundation: `zen-director`, `zen-video`) |
| Controls | Prompt, seed, aspect ratio, keyframe conditioning, camera motion |
| Backwards compatibility | `koma` also resolves as an alias for [`iro`](https://github.com/hanzo-inc/iro) on `POST /v1/images/generations` for callers written against the pre-Iro image SKU |

- **Temporal character continuity** — maintains identity, costume attributes, facial geometry, and lighting coherence across multi-cut sequences.
- **Shot-level director control** — parametric camera choreography (focal length, pan/tilt rate, crane elevation, depth-of-field).
- **High-fidelity motion synthesis** — continuous flow-matching spatial-temporal diffusion eliminating morphing and temporal flicker.
- **Keyframe-guided trajectories** — interpolates smoothly between storyboard keyframes with physics-aware object kinematics.

## Creative AI Lineup

Each creative modality in Hanzo has its own dedicated model and repository:

| Model | Modality | Endpoint | Repository | Open Foundation |
|---|---|---|---|---|
| **Iro** (`iro`) | Image generation & editing | `POST /v1/images/generations` | [`hanzo-inc/iro`](https://github.com/hanzo-inc/iro) | `zen3-image` (`zenlm/zen-artist`) |
| **Koma** (`koma`) | Video generation & motion | `POST /v1/videos/generations` | [`hanzo-inc/koma`](https://github.com/hanzo-inc/koma) | `zen-director` (`zenlm/zen-director`) |
| **Koe** (`koe`) | Voice & dialogue synthesis | `POST /v1/audio/voice` | [`hanzo-inc/koe`](https://github.com/hanzo-inc/koe) | `zen3-tts` (`zenlm/zen-dub`) |
| **Oto** (`oto`) | Foley & sound effects | `POST /v1/audio/foley` | [`hanzo-inc/oto`](https://github.com/hanzo-inc/oto) | `zen-foley` (`zenlm/zen-foley`) |
| **Uta** (`uta`) | Music & score generation | `POST /v1/audio/music` | [`hanzo-inc/uta`](https://github.com/hanzo-inc/uta) | `zen-musician` (`zenlm/zen-musician`) |
| **Mori** (`mori`) | 3D assets, meshes & scenes | `POST /v1/videos/generations` | [`hanzo-inc/mori`](https://github.com/hanzo-inc/mori) | `zen-3d` (`zenlm/zen-3d`) |

## Surfaces

Koma is served by [`hanzo-inc/zen`](https://github.com/hanzo-inc/zen) and declared in `hanzo/universe` (`charts/app/files/zen/catalog.yaml`), with first-party Studio integration in [`hanzo-inc/studio`](https://github.com/hanzo-inc/studio) (`video.generate`).

- Product page: <https://hanzo.ai/koma>
- API and docs: <https://api.hanzo.ai/v1>, <https://docs.hanzo.ai>
- Studio & Dashboard: <https://hanzo.ai/studio>, <https://platform.hanzo.ai>
- Agent notes for this repo: [LLM.md](./LLM.md)

## License

The contents of this repository are licensed under Apache-2.0. The proprietary `koma-1` weights are served through the Hanzo API under the [Hanzo Terms](https://hanzo.ai/terms); the open foundation `zen-director` is available under Apache-2.0 at [`huggingface.co/zenlm/zen-director`](https://huggingface.co/zenlm/zen-director).
