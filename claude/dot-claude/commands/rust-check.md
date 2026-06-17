---
allowed-tools: Bash(cargo check *), Bash(cargo clippy *), Bash(ls *), Bash(cat *)
description: Run cargo check and clippy on the current Rust project
---

## Context

- Cargo.toml: !`cat Cargo.toml 2>/dev/null | grep -E '^name|^\[features\]' | head -10 || echo "No Cargo.toml found"`
- Workspace members: !`cat Cargo.toml 2>/dev/null | grep -A20 '\[workspace\]' | grep '"' || echo "single crate"`

## Task

Run `cargo check` on the project. If it passes, run `cargo clippy -- -D warnings`. Report all errors and warnings clearly, grouped by crate if it's a workspace. Do not run a full build.
