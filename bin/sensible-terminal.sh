#!/bin/sh
#
# NOTE: This is a copy from the i3wm
#
# This code is released in public domain by Han Boetes <han@mijncomputer.nl>
#
# This script tries to exec a terminal emulator by trying some known terminal
# emulators.
#
# We welcome patches that add distribution-specific mechanisms to find the
# preferred terminal emulator. On Debian, there is the x-terminal-emulator
# symlink for example.
#
# Invariants:
# 1. $TERMINAL must come first
# 2. Distribution-specific mechanisms come next, e.g. x-terminal-emulator
# 3. The terminal emulator with best accessibility comes first.
# 4. No order is guaranteed/desired for the remaining terminal emulators.
for terminal in "$TERMINAL" zellij x-terminal-emulator mate-terminal gnome-terminal terminator xfce4-terminal urxvt rxvt termit Eterm aterm uxterm xterm roxterm termite lxterminal terminology st qterminal lilyterm tilix terminix konsole kitty guake tilda alacritty hyper wezterm rio; do
    if ! command -v "$terminal" > /dev/null 2>&1; then
        continue
    fi
    if [ "$terminal" = zellij ] && [ "${1:-}" = -e ]; then
        shift
        # A window for one program (mail, jira) gets its own session: hide its bars.
        exec zellij terminal -e sh -c 'zellij action hide-bars all; exec "$@"' sh "$@"
    elif [ "$terminal" = zellij ]; then
        exec zellij terminal "$@"
    elif [ "$terminal" = kitty ]; then
        # We start kitty as a single instance, otherwise each open takes a really long time
        # Now it is only the first time when no other kitty terminal is open
        exec kitty --single-instance "$@"
    else
        exec "$terminal" "$@"
    fi
done

notify-send 'sensible-terminal.sh could not find a terminal emulator. Please install one.'
