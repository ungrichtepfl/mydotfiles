---
name: rust-check
description: Check, lint, and format-check the current Rust project using its documented commands. Use when asked to check, lint, clippy, or verify a Rust project compiles.
---

# Rust check

## Gather context first
Check: `Cargo.toml` (name, `[features]`, `[workspace]` members), git dependencies
(`git =` entries — SSH ones need prefetch in the sandbox), `.vscode/tasks.json`,
and the cargo git cache (`~/.cargo/git/checkouts`).

## Check and lint, in this order
1. **Honour what the user asked for** (a specific crate, feature set, or target).
2. **`.vscode/tasks.json` is the documented source of truth.** If it defines lint tasks (e.g. a `Lint` task chaining `cargo fmt` + `cargo clippy`, or `cargo clippy --tests --workspace -- -Dclippy::all`), prefer those exact commands and flags over generic defaults. Skip deploy/flash tasks (they SSH to hardware) unless asked.
3. **Fallback when nothing is documented:** `cargo check`, then `cargo clippy -- -D warnings`, then `cargo fmt --check`. Group results by crate for workspaces. Don't run a full release build unless asked.

Report all errors and warnings clearly.

## Dependency fetch when sandboxed (cargo git deps over SSH)
**Applies only when running inside a sandbox that blocks SSH** (e.g. Claude Code's Bash sandbox — HTTP/HTTPS only). Detect it by a fetch error on `ssh://git@github.com/...` git dependencies (often with `git-fetch-with-cli = true`); unsandboxed, fetch normally:

1. **Reuse the cached deps with `--offline`.** If `~/.cargo/git/checkouts/` already holds the dependency and `target/` exists, every cargo command works offline: `cargo check --offline`, `cargo clippy --offline ...`. This is the normal case — VS Code builds populate the cache. Prefer `--offline` whenever the cache is present.
2. **If a dep is missing from the cache**, it must be fetched once over SSH outside the sandbox: ask the user to run `cargo fetch` in an unsandboxed shell (in Claude Code: `! cargo fetch`; note `!` has no TTY, so if SSH needs an interactive passphrase they must use a separate terminal). Subsequent sandboxed commands then work with `--offline`.
3. **Don't** rewrite `Cargo.toml` SSH→HTTPS (shared with other devs/CI) or try to enable SSH in settings (not possible in the sandbox).
