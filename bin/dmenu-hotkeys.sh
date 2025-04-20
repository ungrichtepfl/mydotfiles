#!/usr/bin/env bash

# scripts path
scripts_path="$HOME/.local/bin"

# dmenu theming
. "$scripts_path/dmenu-theming"

grep -e '^[^#]*bind' ~/.config/i3/config | sed -e 's/^\s*//' -e '/^$/d' | dmenu -i -p "$prompt" $lines $colors $font


exit 0
