---
allowed-tools: Bash(cargo check *), Bash(cargo clippy *), Bash(cargo build *), Bash(cargo test *), Bash(cmake *), Bash(ninja *), Bash(make *), Bash(ls *), Bash(cat *), Bash(cross *)
description: Auto-detect and build the current Scewo repo (Rust or CMake)
---

## Context

- Repo type detection: !`ls Cargo.toml CMakeLists.txt 2>/dev/null`
- Git branch: !`git branch --show-current 2>/dev/null || jj log -r @ --no-graph -T 'branches' 2>/dev/null`
- Cargo.toml name: !`grep '^name' Cargo.toml 2>/dev/null | head -1 || echo "n/a"`
- CMakePresets: !`cat CMakePresets.json 2>/dev/null | grep '"name"' | grep -v hidden || echo "n/a"`

## Task

Detect the project type and build it:

**Rust (Cargo.toml present):** Run `cargo check` for a quick validation, then `cargo clippy` to catch issues. If the user asked for a full build, run `cargo build`. For cross-compilation to ARM (imx8 targets), use `cross build --target aarch64-unknown-linux-gnu`.

**CMake (CMakeLists.txt present):** Configure and build using `cmake --preset Debug_App` (or `Release_App` if release requested), then `cmake --build build/Debug_App`. For STM32 bare-metal repos (go-control-panel, m4-core, m7-cortex, go-power-safety-mcu), use the arm-none-eabi toolchain already set in the CMakePresets.

Report results clearly. If both Cargo.toml and CMakeLists.txt exist, prefer Cargo.toml unless the user specifies otherwise.
