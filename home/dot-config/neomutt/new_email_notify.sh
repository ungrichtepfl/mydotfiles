#!/usr/bin/env bash

maildirnew="$HOME/Mail/*/INBOX/new/"
new="$(find $maildirnew -type f | wc -l)"

if [ "$new" -gt 0 ]; then
    notify-send -a "Neomutt" "$1" "$2"
fi
