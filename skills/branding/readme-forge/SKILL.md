---
name: readme-forge
description: Use when generating or rewriting a repository's README.md to the Marais standard — analyzes the repo, drafts the README, scores it with tools/check_readme.py, and iterates until it passes.
---

# readme-forge

Generate a README.md that passes the Marais standard (see rules/10-readme-standard.mdc).

## Workflow

1. **Analyze the repo.** Read the entry points, manifests (package.json, pyproject.toml, Cargo.toml, go.mod), directory layout, existing docs, and CI config. Extract: primary language and version, framework(s), dependencies count, test setup, and the license. Every claim in the README must trace back to something you actually saw.

2. **Detect a demo-able command.** Find the single most impressive CLI command or make target a visitor could run. If nothing runs standalone, note it and skip the demo media section gracefully — or pair with the demo-reel skill to record one.

3. **Draft the README** following the section order in 10-readme-standard: hero (title, tagline, ≥3 shields.io badges), demo media, features, mermaid architecture diagram, quickstart, usage, configuration table (if applicable), license + author footer.

4. **Score it.** Write the draft to a temp path and run:

   ```bash
   python3 /home/cfollette18/projects/marais/tools/check_readme.py /tmp/readme-draft.md
   ```

5. **Iterate until it exits 0.** Fix exactly what the failing checks report, then re-run. Do not weaken the checks.

6. **Deliver.** Show the user the diff against any existing README.md (or the full draft if none exists). Only write into the target repo after an explicit yes. Never overwrite silently.

## Notes

- Badges: use shields.io static badges keyed to facts you verified (license from LICENSE, language from the manifest, status from CI config).
- Keep the mermaid diagram to one flowchart with ≤10 nodes.
- After shipping, store the decisions via quinovo `remember` (see rules/30-quinovo-memory.mdc).
