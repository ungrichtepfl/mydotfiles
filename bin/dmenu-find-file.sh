#!/usr/bin/env bash

DISTRO="$(lsb_release -i | cut -f 2-)"

if [ "$DISTRO" = "VoidLinux" ]; then
    fd=fd
else
    fd=fdfind
fi

search_path="$HOME"

# scripts path
scripts_path="$HOME/.local/bin"

# dmenu theming
. "$scripts_path/dmenu-theming"

if [[ -n $search_path ]]; then

    prompt="File:"
    # FIXME: Get dmenu args from command line args (it only gets one at the moment)
    file_name="$($fd . "$search_path" | \
                 dmenu -i -p "$prompt" $lines $colors $font $1 $2)"

    if [[ ! -z $file_name ]]; then
        xdg-open "$file_name"
    fi

fi

exit 0
