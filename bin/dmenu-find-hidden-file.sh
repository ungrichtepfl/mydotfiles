#!/usr/bin/env bash

search_path="$HOME"

DISTRO="$(lsb_release -i | cut -f 2-)"

if [ "$DISTRO" = "VoidLinux" ]; then
    fd=fd
else
    fd=fdfind
fi

if [[ -n $search_path ]]; then
    if (( $# == 0 )); then
        prompt="File:"
        scripts_path="$HOME/.local/bin"
        . "$scripts_path/dmenu-theming"
        file_name="$($fd --hidden --no-ignore . "$search_path" | \
                 dmenu -i -p "$prompt" $lines $colors $font)"
    else
        file_name="$($fd --hidden --no-ignore . "$search_path" | \
                 dmenu $@)"
    fi

    if [[ ! -z $file_name ]]; then
        xdg-open "$file_name"
    fi

fi
