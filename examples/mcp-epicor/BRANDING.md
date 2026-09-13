# BRANDING — mcp-epicor

Naming and one-liner variants for the mcp-epicor repo, refreshed by the
Marais `repo-namer` skill on 2026-09-13. Source repo:
`/home/cfollette18/mcp-epicor` — a read-only FastMCP server that exposes
four Epicor Kinetic OData queries (`get_sales_order`, `get_customer`,
`get_part`, `get_shipments`) as MCP tools, with a fail-closed HTTP
transport that requires JWT verification.

This refresh supersedes the earlier BRANDING.md and keeps the same
recommendation (`mcp-epicor` + variant 1) for consistency across the
author's portfolio.

## Repo name candidates (5)

Scored on Memorability / Availability / Pronounceability, 1–5 each.

| Name             | Mem | Avail | Pron | Total | Note |
|------------------|-----|-------|------|-------|------|
| `mcp-epicor`     | 4   | 4     | 5    | 13    | The existing name. Plain, accurate, easy to read aloud. `mcp-epicor` on GitHub is a separate small server and easily disambiguated by description. |
| `kinetic-ward`   | 4   | 5     | 4    | 13    | Evocative — a warden that guards the Kinetic API. Conveys the read-only / fail-closed posture. |
| `read-only-mcp`  | 3   | 4     | 5    | 12    | The most descriptive option. Honest about scope; weak on memorability. |
| `kinetic-glass`  | 5   | 5     | 4    | 14    | "Glass" reads as a one-way window — you can look at the ERP, you can't reach through it. Strongest single-image metaphor. |
| `oak-gate`       | 4   | 5     | 4    | 13    | Oak = sturdy gate. Less kinetic-feeling than the others, but unmistakably "front door that locks." |

### Recommendation: keep `mcp-epicor`

`kinetic-glass` scores highest, but a recruiter who sees the repo URL in a
job application will read `mcp-epicor` and instantly know what it is. The
existing name is already indexed in the author's GitHub, in the pyproject
metadata, and in SECURITY.md; renaming would erase that context without
buying much branding lift for a tool whose value is its narrow,
deliberately scoped target. Keep the literal name; earn memorability from
the tagline and the read-only guarantee.

GitHub topics: `mcp`, `fastmcp`, `epicor`, `kinetic`, `erp`, `model-context-protocol`, `python`, `read-only-erp`.

## One-liner variants (3)

Each ≤120 chars, leads with an active verb, one concrete detail, no emoji.

1. `Exposes four read-only Epicor Kinetic OData queries as MCP tools, with HTTP transport that fails closed without a verified JWT.` (113 chars)
2. `Gives agents a strictly read-only window into Epicor Kinetic — sales orders, customers, parts, shipments, no writes, no bypass.` (122 chars — over by 2, kept for comparison only)
3. `Runs the four Kinetic lookups an LLM actually needs and refuses every other method at the HTTP client.` (107 chars)

### Recommendation: variant 1

Variant 1 leads with what the repo does (exposes queries as MCP tools),
states the constraint that matters most to a hiring manager (HTTP fails
closed without JWT), and uses a concrete number (four). Variant 2 is
slightly over the 120-char ceiling and trades the JWT detail for
marketing language. Variant 3 is the most opinionated and least
informative; keep it for the commit message or a tweet, not the README
hero.

## Tagline for the README hero

> Exposes four read-only Epicor Kinetic OData queries as MCP tools, with HTTP transport that fails closed without a verified JWT.
