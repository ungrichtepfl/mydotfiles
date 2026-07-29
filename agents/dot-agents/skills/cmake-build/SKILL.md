---
name: cmake-build
description: Configure and build a CMake project using its presets and documented VS Code tasks. Use when asked to build, configure, or compile a CMake project.
---

# CMake build

## Gather context first
Check (in the project root): non-hidden preset names in `CMakePresets.json`,
`.vscode/tasks.json`, existing `build/` dirs, and already-fetched deps
(`build/*/_deps/*-src`).

## Determine the build command, in this order
1. **Honour what the user asked for** — if they named a preset, build type, or task, use that.
2. **`.vscode/tasks.json` is the documented source of truth.** Prefer the command from the task matching the user's intent (default build → the `group: build` / `isDefault` task, usually `CMake: build`; tests → the `test` group task; lint/format → those labelled tasks). Resolve VS Code template variables:
   - `${command:cmake.activeBuildPresetName}` → the active/chosen preset.
   - `${command:cmake.buildDirectory}` → `build/<preset>`.
   - `${workspaceFolder}` → repo root; `$(nproc)` is fine to keep.
   Skip `hide: true` helper tasks and deploy/flash tasks (those SSH to hardware) unless explicitly requested.
3. **Fall back to presets**: `cmake --preset <preset>` then `cmake --build --preset <preset>` (or `cmake --build build/<preset>`). Pick the preset by: user request → a `*_App`/`Debug_App` preset if present → otherwise the first non-hidden preset.
4. **No presets at all:** `cmake -B build -S . && cmake --build build`.

Report build output, highlight any errors or warnings.

## Dependency fetch when sandboxed (FetchContent / SSH)
**Applies only when running inside a sandbox that blocks SSH** (e.g. Claude Code's Bash sandbox, which proxies HTTP/HTTPS only — port 22 raw TCP cannot traverse it). Detect it by an SSH/clone error on a fresh configure of a `FetchContent_Declare(... GIT_REPOSITORY git@github.com:...)` dep; unsandboxed, fetch normally. Handle it in this order:

1. **Reuse already-fetched sources.** A populated `build/<preset>/_deps/` means the dependency is already cloned; `cmake --build build/<preset>` will not re-fetch. Don't wipe `build/` or reconfigure from scratch if it isn't needed.
2. **Prefetch with `gh`, then point CMake at it.** `gh` uses HTTPS + token, which works in the sandbox. Clone the dep at the pinned `GIT_TAG` and pass it via `FETCHCONTENT_SOURCE_DIR_<NAME>` (NAME = upper-cased `FetchContent_Declare` name):
   ```bash
   gh repo clone Scewo/imx8-scewo-messages "$TMPDIR/scewo-messages" -- --branch v0.18.0 --depth 1
   cmake --preset <preset> -D"FETCHCONTENT_SOURCE_DIR_SCEWO-MESSAGES=$TMPDIR/scewo-messages"
   ```
3. **Don't** edit the project's `CMakeLists.txt` to swap SSH→HTTPS or try to enable SSH in settings — the URL is shared with other devs/CI, and SSH can't be enabled in the sandbox.

If a genuine first-time fetch is unavoidable, ask the user to run the configure step once in an unsandboxed shell (in Claude Code: the `! ` prefix; `!` has no TTY — use a separate terminal if SSH needs an interactive passphrase); sandboxed builds then reuse the `_deps` cache.
