---
allowed-tools: Bash(cargo check *), Bash(cargo clippy *), Bash(cargo fmt *), Bash(cargo fetch *), Bash(ls *), Bash(cat *)
description: Check, lint, and format-check the current Rust project
---

## Context

- Cargo.toml: !`cat Cargo.toml 2>/dev/null | grep -E '^name|^\[features\]|^\[workspace\]' | head -10 || echo "No Cargo.toml found"`
- Workspace members: !`cat Cargo.toml 2>/dev/null | grep -A20 '\[workspace\]' | grep '"' || echo "single crate"`
- Git dependencies (SSH = needs prefetch in sandbox): !`grep -E 'git\s*=' Cargo.toml 2>/dev/null || echo "none"`
- VS Code tasks (how we document lint/build): !`cat .vscode/tasks.json 2>/dev/null || echo "No .vscode/tasks.json"`
- Cargo git cache (already-fetched deps): !`ls ~/.cargo/git/checkouts 2>/dev/null || echo "empty"`

## Task

Check and lint the Rust project, in this order of preference:

1. **Honour what the user asked for** (a specific crate, feature set, or target).
2. **`.vscode/tasks.json` is the documented source of truth for this repo.** If it defines lint tasks (e.g. a `Lint` task that chains `cargo fmt` + `cargo clippy`, or a `Run clippy` task like `cargo clippy --tests --workspace -- -Dclippy::all`), prefer those exact commands and flags over generic defaults. Skip deploy/flash tasks (they SSH to hardware) unless asked.
3. **Fallback when nothing is documented:** run `cargo check`, then `cargo clippy -- -D warnings`, then `cargo fmt --check`. Group results by crate for workspaces. Don't run a full release build unless asked.

Report all errors and warnings clearly.

## Dependency fetch in the sandbox (cargo git deps over SSH)

The Bash sandbox proxies **HTTP/HTTPS only** — SSH can't traverse it. Repos with `ssh://git@github.com/...` git dependencies (and `git-fetch-with-cli = true` in `.cargo/config.toml`) can't fetch them inside the sandbox. Handle it in this order:

1. **Reuse the cached deps with `--offline`.** If `~/.cargo/git/checkouts/` already holds the dependency (see Context) and `target/` exists, every cargo command works offline with no network: `cargo check --offline`, `cargo clippy --offline ...`, etc. This is the normal case — VS Code builds populate the cache. Prefer `--offline` whenever the cache is present.
2. **If a dep is missing from the cache**, it must be fetched once over SSH outside the sandbox: tell the user to run `! cargo fetch` (the `! ` prefix uses their real, unsandboxed shell). Subsequent sandboxed commands then work with `--offline`.
3. **Don't** rewrite `Cargo.toml` SSH→HTTPS (shared with other devs/CI) or try to enable SSH in settings (not possible in the sandbox).
