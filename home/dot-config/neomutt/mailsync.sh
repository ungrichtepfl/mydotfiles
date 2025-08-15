#!/bin/bash

function main {
    if pgrep goimapnotify 2&> /dev/null; then
        echo "gomapnotify already running."
        exit 0
    fi

    while true; do
        while ping -c 1 "8.8.8.8" 2&> /dev/null; do
            sleep 1
        done
        if ! pgrep goimapnotify 2&> /dev/null; then
            goimapnotify
        fi
        sleep 5
    done
}

main "$@"
