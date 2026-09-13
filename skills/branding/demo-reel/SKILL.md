---
name: demo-reel
description: Use when recording a terminal demo video or GIF for a repository — scripts and records the repo's most impressive command via VHS (preferred) or asciinema+agg, producing docs/demo.gif and docs/demo.mp4.
---

# demo-reel

Record a terminal demo of the target repo and embed it in the README.

## Tooling detection

1. `which vhs` — preferred. Uses .tape scripts.
2. If missing: `which asciinema` and `which agg` — the fallback path.
3. If neither: tell the user how to install and stop. VHS: `go install github.com/charmbracelet/vhs@latest` (or their package manager). asciinema: `pip install asciinema` plus `agg` from https://github.com/asciinema/agg.

## The demo itself

- Pick the repo's single most impressive command. One command, one payoff.
- Total runtime ≤60 seconds. Cut setup; show only the payoff and one line of context.
- Write the script first, show it to the user, then record.
- For VHS: adapt `/home/cfollette18/projects/marais/tools/vhs-templates/demo.tape` — it has placeholders for the command, output dir, and theme.
- For asciinema: `asciinema rec -c "<command>" docs/demo.cast`, then `agg docs/demo.cast docs/demo.gif`. MP4: convert the gif with ffmpeg if available (`ffmpeg -i docs/demo.gif -movflags faststart -pix_fmt yuv420p docs/demo.mp4`).

## Outputs

- `docs/demo.gif` — the README embed (keep it under ~5 MB; drop fps or width if larger).
- `docs/demo.mp4` — the full video for the "Watch the demo" link.

## README embed snippet

Place near the top, right after the hero badges:

```markdown
![demo](docs/demo.gif)

[Watch the full demo](docs/demo.mp4)
```

If only the GIF exists, embed the GIF alone — never link a missing MP4.
