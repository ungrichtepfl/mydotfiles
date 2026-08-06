---
name: test
description: Run the test suite for the current project (Rust or CMake) using the repo's documented test commands. Use when asked to run tests or verify changes with the test suite.
---

# Run tests

## Gather context first
Check: project type (`Cargo.toml` vs `CMakeLists.txt`/`CMakePresets.json`),
`.vscode/tasks.json`, existing `build/` dirs, and the cargo git cache
(`~/.cargo/git/checkouts`).

## Run the tests, in this order
1. **Honour what the user asked for** (a specific test, target, crate, or filter).
2. **`.vscode/tasks.json` is the documented source of truth.** Prefer the command from the task in the `test` group (or one labelled like "Run unit tests"). Resolve VS Code template variables — `${command:cmake.buildDirectory}` → `build/<preset>`, `${workspaceFolder}` → repo root, `$(nproc)` is fine to keep. Example (m7-cortex): `cmake --build build/UnitTest -j$(nproc) --target runUnitTests`. Skip `hide: true` helpers and deploy/flash tasks unless asked.
3. **Fallback when no test task is documented:**
   - **Rust (Cargo.toml):** `cargo nextest run` if nextest is available, otherwise `cargo test`. Add `--workspace` for workspaces.
   - **CMake (CMakeLists.txt):** prefer `ctest --test-dir build/<preset> --output-on-failure`; if there's no CTest registration, build the test target (e.g. `--target runUnitTests`). Use the UnitTest preset/dir if one exists.

Report pass/fail counts and surface failing tests with their output.

## Dependency fetch
The sandbox is configured with ssh-agent forwarding, so dependency fetches over `git@github.com:` (cargo git deps, CMake `FetchContent`) work normally on a cold cache — no special handling needed on this machine.

**If a fetch error still occurs** (e.g. on a machine without this fix, or no ssh-agent running):
- **Rust:** if `~/.cargo/git/checkouts/` is populated, add `--offline` to the cargo command. If a dep is missing, ask the user to check `ssh-add -l` or prefetch once in an unsandboxed shell.
- **CMake:** if `build/<preset>/_deps/` is already populated, tests build against it without re-fetching. Otherwise see the `cmake-build` skill's fallback procedure.

Don't rewrite manifests SSH→HTTPS.
