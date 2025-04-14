#!/usr/bin/env bash

search_path="$HOME"

DISTRO="$(lsb_release -i | cut -f 2-)"

if [ "$DISTRO" = "VoidLinux" ]; then
    fd=fd
else
    fd=fdfind
fi

# scripts path
scripts_path="$HOME/.local/bin"

# dmenu theming
. "$scripts_path/dmenu-theming"

if [[ -n $search_path ]]; then

    prompt="File:"

    # file_name="$(find "$search_path" \( ! -regex '.*/\..*' \) -type f | \
    #              dmenu -i -p "$prompt" $lines $colors $font)"
    file_name="$($fd --hidden --no-ignore . "$search_path" | \
                 dmenu -i -p "$prompt" $lines $colors $font)"

    if [[ ! -z $file_name ]]; then
        xdg-open "$file_name"
    fi

fi

exit 0
