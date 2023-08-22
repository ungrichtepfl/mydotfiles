#!/usr/bin/env bash

search_path="$HOME"

# scripts path
scripts_path="$HOME/.local/bin"

# dmenu theming
. "$scripts_path/dmenu-theming"

if [[ ! -z $search_path ]]; then

    prompt="File:"

    # file_name="$(find "$search_path" \( ! -regex '.*/\..*' \) -type f | \
    #              dmenu -i -p "$prompt" $lines $colors $font)"
    file_name="$(fdfind . "$search_path" | \
                 dmenu -i -p "$prompt" $lines $colors $font)"

    if [[ ! -z $file_name ]]; then
        xdg-open "$file_name"
    fi

fi

exit 0
