#!/usr/bin/env bash

DISTRO="$(lsb_release -i | cut -f 2-)"

if [ "$DISTRO" = "VoidLinux" ]; then
    fd=fd
else
    fd=fdfind
fi

search_path="$HOME"

if [[ -n $search_path ]]; then
    if (( $# == 0 )); then
        # Used in i3
        prompt="File:"
        scripts_path="$HOME/.local/bin"
        . "$scripts_path/dmenu-theming"
        file_name="$($fd . "$search_path" | \
                 dmenu -i -p "$prompt" $lines $colors $font)"
    else
        file_name="$($fd . "$search_path" | \
                 dmenu $@)"
    fi

    if [[ ! -z $file_name ]]; then
        xdg-open "$file_name"
    fi

fi
