#!/usr/bin/env bash
set -euo pipefail

# Wrapper that accepts the same flags as `dmenu` and passes them to
# j4-dmenu-desktop via its --dmenu argument.
# Usage: scripts/j4dmenu-desktop-dmenu [dmenu-args]

if (( $# == 0 )); then
    DMENU_CMD='dmenu'
else
    DMENU_CMD='dmenu'
    for a in "$@"; do
        # Use bash's %q to produce a shell-quoted/escaped form of the arg
        # so the constructed command is safe when evaluated by j4-dmenu-desktop.
        esc=$(printf '%q' "$a")
        DMENU_CMD+=" $esc"
    done
fi

exec j4-dmenu-desktop --dmenu="$DMENU_CMD"
