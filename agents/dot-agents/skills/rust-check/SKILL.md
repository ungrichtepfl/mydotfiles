---
name: rust-check
description: Check, lint, and format-check the current Rust project using its documented commands. Use when asked to check, lint, clippy, or verify a Rust project compiles.
---

# Rust check

## Gather context first
Check: `Cargo.toml` (name, `[features]`, `[workspace]` members), git dependencies
(`git =` entries), `.vscode/tasks.json`, and the cargo git cache
(`~/.cargo/git/checkouts`).

## Check and lint, in this order
1. **Honour what the user asked for** (a specific crate, feature set, or target).
2. **`.vscode/tasks.json` is the documented source of truth.** If it defines lint tasks (e.g. a `Lint` task chaining `cargo fmt` + `cargo clippy`, or `cargo clippy --tests --workspace -- -Dclippy::all`), prefer those exact commands and flags over generic defaults. Skip deploy/flash tasks (they SSH to hardware) unless asked.
3. **Fallback when nothing is documented:** `cargo check`, then `cargo clippy -- -D warnings`, then `cargo fmt --check`. Group results by crate for workspaces. Don't run a full release build unless asked.

Report all errors and warnings clearly.

## Dependency fetch (cargo git deps over SSH)
The sandbox is configured with ssh-agent forwarding (`SSH_AUTH_SOCK` + `sandbox.network.allowAllUnixSockets`) and `~/.cargo` is writable, so `cargo check`/`cargo fetch` on `git = "ssh://git@github.com/..."` dependencies works normally — no special handling needed on this machine.

**If a fetch error still occurs** (e.g. on a machine without this fix, or no ssh-agent running):
1. **Reuse the cached deps with `--offline`.** If `~/.cargo/git/checkouts/` already holds the dependency and `target/` exists, every cargo command works offline: `cargo check --offline`, `cargo clippy --offline ...`.
2. **If a dep is missing from the cache**, ask the user to check that an ssh-agent is running with the key loaded (`ssh-add -l`), or run `cargo fetch` once in an unsandboxed shell.
3. **Don't** rewrite `Cargo.toml` SSH→HTTPS (shared with other devs/CI).
