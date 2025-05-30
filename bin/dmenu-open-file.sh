#!/usr/bin/env bash

# search root
root_path="$HOME"

# scripts path
scripts_path="$HOME/.local/bin"

# dmenu theming
. "$scripts_path/dmenu-theming"

prompt="-p Folder"

file_path="$(find $root_path -maxdepth 5 -type d \( ! -regex '.*/\..*' \) | \
             sed 's|^'$root_path/'||' | sort | \
             dmenu -i $prompt $lines $colors $font)"

if [[ -n $file_path ]]; then

    if [[ "$file_path" == "$root_path" ]]; then
        search_path=$root_path
    else
        search_path="$root_path/$file_path"
    fi

    total="$(find "$search_path" -maxdepth 1 -type f | wc -l)"
    
    if [[ $total -eq 0 ]]; then
        prompt="No files here!"
    else
        prompt="File:"
    fi

    file_name="$(find "$search_path" -maxdepth 1 -type f | \
                 awk -F'/' '{print $NF}' | \
                 dmenu -i -p "$prompt" $lines $colors $font)"

    if [[ -n $file_name ]]; then
        xdg-open "$search_path/$file_name"
    fi

fi

exit 0
