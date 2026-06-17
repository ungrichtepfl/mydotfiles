---
allowed-tools: Bash(cmake *), Bash(ninja *), Bash(make *), Bash(ls *), Bash(cat *)
description: Configure and build the CMake project using available presets
---

## Context

- CMakePresets: !`cat CMakePresets.json 2>/dev/null | grep -E '"name"|"hidden"' | grep -v 'true' | grep '"name"' || echo "No CMakePresets.json found"`
- Build dirs: !`ls build/ 2>/dev/null || echo "No build directory yet"`

## Task

Build the CMake project:
1. If CMakePresets.json exists, use `cmake --preset <preset>` then `cmake --build --preset <preset>` (or `cmake --build build/<preset>`). Default to `Debug_App` if it exists, otherwise `Debug`.
2. If no presets, fall back to `cmake -B build -S . && cmake --build build`.
3. If the user specified a preset or build type in their message, use that instead.
Report build output, highlight any errors or warnings.
