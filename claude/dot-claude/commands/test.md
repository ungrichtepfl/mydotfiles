---
allowed-tools: Bash(cargo test *), Bash(cargo nextest *), Bash(ctest *), Bash(cmake *), Bash(ninja *), Bash(make *), Bash(ls *), Bash(cat *)
description: Run the test suite for the current project (Rust or CMake), using the repo's documented test commands
---

## Context

- Project type: !`ls Cargo.toml CMakePresets.json CMakeLists.txt 2>/dev/null`
- VS Code tasks (how we document tests): !`cat .vscode/tasks.json 2>/dev/null || echo "No .vscode/tasks.json"`
- CMake build dirs: !`ls build/ 2>/dev/null || echo "none"`
- Cargo git cache (already-fetched deps): !`ls ~/.cargo/git/checkouts 2>/dev/null || echo "empty"`

## Task

Run the project's tests, in this order of preference:

1. **Honour what the user asked for** (a specific test, target, crate, or filter).
2. **`.vscode/tasks.json` is the documented source of truth for this repo.** Prefer the command from the task in the `test` group (or one labelled like "Run unit tests" / "Run tests"). Resolve VS Code template variables to concrete values — `${command:cmake.buildDirectory}` → `build/<preset>`, `${workspaceFolder}` → repo root, `$(nproc)` is fine to keep. Example (m7-cortex): `cmake --build build/UnitTest -j$(nproc) --target runUnitTests`. Skip `hide: true` helpers and deploy/flash tasks unless asked.
3. **Fallback when no test task is documented:**
   - **Rust (Cargo.toml):** `cargo nextest run` if nextest is available, otherwise `cargo test`. Add `--workspace` for workspaces.
   - **CMake (CMakeLists.txt):** prefer `ctest --test-dir build/<preset> --output-on-failure`; if there's no CTest registration, build the test target (e.g. `--target runUnitTests`). Use the UnitTest preset/dir if one exists.

Report pass/fail counts and surface failing tests with their output.

## Dependency fetch in the sandbox

The Bash sandbox proxies **HTTP/HTTPS only** — SSH can't traverse it, so tests that trigger a dependency fetch over `git@github.com:`/`ssh://git@github.com/` will fail on a cold cache. Reuse what's already fetched first:

- **Rust:** if `~/.cargo/git/checkouts/` is populated (see Context), add `--offline` to the cargo command. If a dep is missing, the user must prefetch once outside the sandbox with `! cargo fetch`.
- **CMake:** if `build/<preset>/_deps/` is already populated, tests build against it without re-fetching. Otherwise see the `/cmake-build` skill's prefetch-with-`gh` procedure.

Don't rewrite manifests SSH→HTTPS or try to enable SSH in settings (not possible in the sandbox).
