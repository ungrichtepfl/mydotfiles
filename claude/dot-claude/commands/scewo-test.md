---
allowed-tools: Bash(cargo test *), Bash(cargo nextest *), Bash(ls *), Bash(cat *)
description: Run tests for the current Scewo Rust project
---

## Context

- Cargo.toml: !`grep '^name\|^\[dev-dependencies\]' Cargo.toml 2>/dev/null | head -5 || echo "No Cargo.toml"`
- Test files: !`find src tests -name '*test*' -o -name '*.rs' 2>/dev/null | xargs grep -l '#\[test\]' 2>/dev/null | head -10 || echo "none found"`

## Task

Run `cargo test` (or `cargo nextest run` if nextest is available). If the user specified a test name or pattern, pass it as a filter. Report pass/fail counts and any failures with their output. Do not run integration tests that require hardware (check for `#[ignore]` annotations or cfg gates on `target_arch`).
