---
name: repo-namer
description: Use when proposing a repository name, one-line description, or GitHub topics — outputs exactly 5 scored name candidates and 3 one-liner variants with one recommendation.
---

# repo-namer

Name a repository and write its one-line description. Follow the brand voice rules (rules/20-brand-voice.mdc).

## Workflow

1. Read the repo enough to know what it actually does and who it is for.
2. Generate name candidates: lowercase-hyphenated, ≤3 syllables preferred, evocative rather than descriptive.
3. **Availability check.** Web-search each candidate plus "github". Discard any colliding with a project over ~1k stars or a known product. Replace discards until 5 survive.
4. Score the 5 survivors on the rubric below.
5. Write 3 one-liner variants (≤120 chars each, active verb first, one concrete detail).
6. Output the table, recommend exactly one name + one-liner pairing, and say why in one sentence.

## Scoring rubric (1–5 each)

- **Memorability** — could a recruiter recall it an hour later?
- **Availability** — clean of famous-project collisions, domain/handle plausibly free.
- **Pronounceability** — sayable on a phone call without spelling.

## Output format

| Name | Memorability | Availability | Pronounceability | Total |
|------|---|---|---|---|
| ...  | ... | ... | ... | ... |

Then:

1. One-liner variant A
2. One-liner variant B
3. One-liner variant C

**Recommendation:** `<name>` — "one-liner". One sentence of rationale. Plus 5–8 GitHub topics.

Store the decision with quinovo `remember` once the user picks.
