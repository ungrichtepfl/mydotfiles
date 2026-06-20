---
allowed-tools: Bash(cmake *), Bash(ninja *), Bash(make *), Bash(ls *), Bash(cat *), Bash(gh *)
description: Configure and build the CMake project using available presets
---

## Context

- CMakePresets: !`cat CMakePresets.json 2>/dev/null | grep -E '"name"|"hidden"' | grep -v 'true' | grep '"name"' || echo "No CMakePresets.json found"`
- VS Code tasks (how we document builds): !`cat .vscode/tasks.json 2>/dev/null || echo "No .vscode/tasks.json"`
- Build dirs: !`ls build/ 2>/dev/null || echo "No build directory yet"`
- Existing fetched deps: !`ls -d build/*/_deps/*-src 2>/dev/null || echo "No _deps fetched yet"`

## Task

Determine the right build command, in this order of preference:

1. **Honour what the user asked for** — if they named a preset, build type, or task in their message, use that.
2. **`.vscode/tasks.json` is the documented source of truth for this repo.** Prefer the command from the task that matches the user's intent (default build → the `group: build` / `isDefault` task, which is usually `CMake: build`; tests → the `test` group task; lint/format → those labelled tasks). Resolve VS Code template variables to concrete values:
   - `${command:cmake.activeBuildPresetName}` → the active/chosen preset (see below).
   - `${command:cmake.buildDirectory}` → `build/<preset>`.
   - `${workspaceFolder}` → the repo root; `$(nproc)` is fine to keep.
   Skip `hide: true` helper tasks and deploy/flash tasks (those SSH to hardware) unless explicitly requested.
3. **Fall back to presets** when there's no matching task: `cmake --preset <preset>` then `cmake --build --preset <preset>` (or `cmake --build build/<preset>`). Pick the preset by: user request → a `*_App`/`Debug_App` preset if present → otherwise the first non-hidden preset.
4. **No presets at all:** `cmake -B build -S . && cmake --build build`.

Report build output, highlight any errors or warnings.

## Dependency fetch in the sandbox (FetchContent / SSH)

The Bash sandbox proxies **HTTP/HTTPS only** — SSH (port 22, raw TCP) cannot traverse it, regardless of `allowedDomains`. So a `FetchContent_Declare(... GIT_REPOSITORY git@github.com:...)` step will fail on a fresh configure with an SSH/clone error. Handle it in this order:

1. **Reuse already-fetched sources.** A populated `build/<preset>/_deps/` (see Context above) means the dependency is already cloned. Just run `cmake --build build/<preset>` — CMake will not re-fetch. Don't wipe `build/` or reconfigure from scratch if it isn't needed.
2. **Prefetch with `gh`, then point CMake at it.** `gh` uses HTTPS + your token, which works in the sandbox. Clone the dep (at the tag the CMakeLists pins, e.g. `GIT_TAG`) and pass it to CMake via `FETCHCONTENT_SOURCE_DIR_<NAME>` (NAME is the upper-cased `FetchContent_Declare` name; e.g. `scewo-messages` → `FETCHCONTENT_SOURCE_DIR_SCEWO-MESSAGES`):
   ```bash
   gh repo clone Scewo/imx8-scewo-messages "$TMPDIR/scewo-messages" -- --branch v0.18.0 --depth 1
   cmake --preset <preset> -D"FETCHCONTENT_SOURCE_DIR_SCEWO-MESSAGES=$TMPDIR/scewo-messages"
   ```
   This makes FetchContent use the local copy instead of cloning over SSH.
3. **Don't** edit the project's `CMakeLists.txt` to swap SSH→HTTPS or try to enable SSH in settings — the URL is shared with other devs/CI, and SSH can't be enabled in the sandbox anyway. Prefer the overrides above.

If the user must do a genuine first-time fetch that none of the above covers, tell them they can run the configure step once via the `! ` prefix (their real, unsandboxed shell) so the SSH clone succeeds, after which sandboxed builds reuse the `_deps` cache.
