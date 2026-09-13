<p align="center">
  <h1 align="center">Marais</h1>
  <p align="center"><strong>A beautician for GitHub repos — a Hermes agent that polishes the storefront, the gallery, and the first impression.</strong></p>
  <p align="center">
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
    <a href="https://github.com/NousResearch/hermes-agent"><img src="https://img.shields.io/badge/built%20with-Hermes%20Agent-blueviolet.svg" alt="Built with Hermes Agent"></a>
    <a href="https://langfuse.com"><img src="https://img.shields.io/badge/traced%20with-Langfuse-teal.svg" alt="Traced with Langfuse"></a>
    <a href="https://mermaid.js.org"><img src="https://img.shields.io/badge/architecture-mermaid-ff3670.svg" alt="Mermaid diagrams"></a>
  </p>
</p>

<p align="center">
  <img src="docs/demo.gif" alt="Marais demo — recorded live from this local instance" width="900">
</p>

<p align="center"><em>Marais presenting itself — recorded live from the local instance with asciinema, rendered by agg.</em></p>

<p align="center">
  <a href="docs/demo.mp4"><img src="https://img.shields.io/badge/demo-watch%20MP4-181717?style=for-the-badge&logo=github&logoColor=white" alt="Watch the full demo MP4"></a>
  <a href="docs/demo.gif"><img src="https://img.shields.io/badge/demo-download%20GIF-181717?style=for-the-badge&logo=github&logoColor=white" alt="Download the demo GIF"></a>
</p>

[**Watch the demo**](docs/demo.mp4) · [**Download the GIF**](docs/demo.gif)

## Why — the 30-second storefront

A recruiter decides whether a repo is worth opening in about 30 seconds. The window is a storefront: title, badge row, an embedded demo, a few concrete features, a copy-paste quickstart. Most repos fail not because the code is weak but because the storefront is — a bare paragraph, a dead screenshot, a feature list with no numbers. Marais is the beautician that rebuilds that storefront so the code behind it gets the read it earned.

## Features — what the atelier produces

- **READMEs that pass a quality gate** — hero with badges, embedded demo, mermaid architecture, quickstart, license footer. Refused until `tools/check_readme.py` exits 0.
- **Names and one-liners** — 5 scored name candidates with availability checks, 3 one-liner variants under 120 characters, GitHub topics.
- **Terminal demo videos** — a scripted recording of the repo's most impressive command, rendered to `docs/demo.gif` and `docs/demo.mp4` via asciinema or VHS.
- **Scoped to one repo per run** — a `guard_scope.sh` hook refuses to write outside the target directory, so the polish never spills onto the wrong project.
- **Traced end to end** — every run is recorded by Langfuse; the craft is inspectable, not opaque.

## Architecture

Marais is a Hermes Agent profile — an isolated agent home with its own rules, skills, hooks, and MCP wiring.

```mermaid
flowchart LR
    U[you: hermes -p marais] --> P[marais profile]
    P --> R[rules: mission,<br>README standard,<br>brand voice]
    P --> S[skills: readme-forge,<br>repo-namer, demo-reel]
    P --> H[hook: guard_scope.sh<br>blocks writes outside target repo]
    P --> Q[quinovo MCP<br>branding decisions memory]
    P --> L[Langfuse<br>full trace of every run]
    S --> T[target repo<br>README.md + docs/demo.gif]
```

## Skills

| Skill | What it does |
|-------|--------------|
| `readme-forge` | Analyzes a repo, drafts a README to the Marais standard, scores it with `check_readme.py`, iterates until it passes |
| `repo-namer` | Proposes 5 scored name candidates + 3 one-liner variants, recommends one |
| `demo-reel` | Scripts and records a ≤60s terminal demo via asciinema or VHS, outputs `docs/demo.gif` + `docs/demo.mp4` |

## Quickstart

Requires [Hermes Agent](https://github.com/NousResearch/hermes-agent) v0.20+ and git. Asciinema or VHS is optional (only needed for demo recording).

```bash
git clone https://github.com/cfollette18/marais.git
cd marais
./install.sh
```

Then polish any repo:

```bash
cd /path/to/target-repo
hermes -p marais chat -q "Give this repo a recruiter-ready README" -Q
```

Use `chat -q ... -Q`, never `-z`: one-shot mode bypasses Hermes' plugin manager, so Langfuse tracing only fires in chat runs.

`install.sh` is idempotent — it creates the `marais` profile, links the rules and skills, installs the config, symlinks the shared `.env`, verifies the Langfuse dependency, and prints the exact follow-up commands.

## Configuration

Configured by `config.yaml`:

| Key | Value | Purpose |
|-----|-------|---------|
| `model.default` | `MiniMax-M3` | Generation model |
| `toolsets` | `file, terminal, web, skills, todo` | Only what presentation needs |
| `agent.max_turns` | `60` | Run budget per session |
| `hooks.pre_tool_call` | `guard_scope.sh` | Confines writes to the target repo |
| `mcp_servers.quinovo` | local Quinovo pack | Remembers branding decisions per repo |
| `plugins.enabled` | `observability/langfuse, quinovo` | Tracing + memory |

## Example output

A real before/after proof run lives in [`examples/mcp-epicor/`](examples/mcp-epicor/) — Marais turned a working but un-presented MCP server into a repo with an embedded demo, a scored README, and a one-liner. The harness ships empty; the first run populates the gallery.

## License

MIT. Written by Clinton Follette.