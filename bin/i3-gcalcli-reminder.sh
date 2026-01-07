#!/usr/bin/env bash

if command -v gcalcli >/dev/null 2>&1; then
    while true; do
        gcalcli remind --use-reminders
        sleep 300
    done
fi

