#!/bin/bash

set -euo pipefail

SUCCESS="Successfully sync'd emails!"
FAIL="Failed to sync emails!"

neomutt "$@"
tmux new -d bash -c "(mbsync -a && notmuch new && notify-send \"$SUCCESS\") || notify-send -u critical \"$FAIL\"; exit" 
