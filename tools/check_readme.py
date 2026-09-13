#!/usr/bin/env python3
"""check_readme.py — score a README.md against the Marais standard.

Usage: python3 check_readme.py <path-to-README.md>
Exits 0 only when every check passes. Stdlib-only.
"""
import os
import re
import sys


def check_badges(text):
    badges = re.findall(
        r"img\.shields\.io|badgen\.net|badge\.fury\.io|!?\[[^\]]*\]\([^)]*badge[^)]*\)",
        text, re.IGNORECASE,
    )
    ok = len(badges) >= 3
    return ok, f"{len(badges)} badge(s) found, need >= 3"


def check_demo_media(text):
    ok = bool(re.search(r"\[[^\]]*\]\([^)]*\.(gif|mp4|webm|cast)[^)]*\)", text, re.IGNORECASE))
    return ok, "demo media reference (.gif/.mp4/.webm/.cast) " + ("found" if ok else "missing")


def check_architecture(text):
    has_mermaid = bool(re.search(r"```mermaid", text, re.IGNORECASE))
    has_section = bool(re.search(r"^#{1,4}\s+architecture", text, re.IGNORECASE | re.MULTILINE))
    ok = has_mermaid or has_section
    return ok, "mermaid block or Architecture section " + ("found" if ok else "missing")


def check_setup(text):
    section = re.search(
        r"^#{1,4}\s+.*(quickstart|quick start|getting started|setup|installation|install)\b.*$",
        text, re.IGNORECASE | re.MULTILINE,
    )
    if not section:
        return False, "setup/install section missing"
    rest = text[section.end():]
    next_heading = re.search(r"^#{1,4}\s", rest, re.MULTILINE)
    body = rest[: next_heading.start()] if next_heading else rest
    ok = "```" in body
    return ok, "setup section " + ("has a code block" if ok else "has no code block")


def check_features(text):
    ok = bool(re.search(r"^#{1,4}\s+.*features", text, re.IGNORECASE | re.MULTILINE))
    return ok, "Features section " + ("found" if ok else "missing")


def check_license(text):
    ok = bool(re.search(r"license", text, re.IGNORECASE))
    return ok, "license mention " + ("found" if ok else "missing")


CHECKS = [
    ("badges (>=3)", check_badges),
    ("demo media", check_demo_media),
    ("architecture", check_architecture),
    ("setup + code block", check_setup),
    ("features", check_features),
    ("license", check_license),
]


def main(argv):
    if len(argv) != 2:
        print("usage: check_readme.py <path-to-README.md>", file=sys.stderr)
        return 2
    path = argv[1]
    if not os.path.isfile(path):
        print(f"error: {path} not found", file=sys.stderr)
        return 2
    with open(path, encoding="utf-8") as fh:
        text = fh.read()

    print(f"README standard check: {path}\n")
    print(f"{'check':<22}{'result':<8}detail")
    print("-" * 70)
    all_ok = True
    for name, fn in CHECKS:
        ok, detail = fn(text)
        all_ok = all_ok and ok
        print(f"{name:<22}{'PASS' if ok else 'FAIL':<8}{detail}")
    print("-" * 70)
    print("PASS — README meets the Marais standard." if all_ok
          else "FAIL — fix the checks above and re-run.")
    return 0 if all_ok else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
