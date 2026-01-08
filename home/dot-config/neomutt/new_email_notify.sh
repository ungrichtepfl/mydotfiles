#!/usr/bin/env bash

maildirnew="$HOME/Mail/$1/INBOX/new/"
new="$(find $maildirnew -type f | wc -l)"

if [ "$new" -gt 0 ]; then
    notify-send -a "Neomutt" "$2" "$3"
fi
