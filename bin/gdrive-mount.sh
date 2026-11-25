#!/bin/sh
# Mount selected Google Drive folders with rclone.
# Files are only listed; each file is downloaded when it is opened.
#
# Usage: gdrive-mount.sh       mount all folders that are not mounted yet
#        gdrive-mount.sh -u    unmount all folders
#
# The folders come from $XDG_CONFIG_HOME/gdrive-mount/folders, one per line:
#   <Drive folder ID (last part of the folder URL)> <mount directory>
# A mount directory that does not start with / is relative to $HOME.
# Empty lines and lines starting with # are ignored.
#
# On a machine without rclone, without the rclone remote below or without the
# folder list, it does nothing (so it can be started at every login).

remote="gdrive:"
config="${XDG_CONFIG_HOME:-$HOME/.config}/gdrive-mount/folders"
log="${XDG_STATE_HOME:-$HOME/.local/state}/gdrive-mount.log"

mkdir -p "$(dirname "$log")"

skip() {
    echo "$(date '+%F %T') gdrive-mount: $1, nothing to do" >> "$log"
    exit 0
}

command -v rclone >/dev/null 2>&1 || skip "rclone is not installed"
rclone listremotes | grep -qx "$remote" || skip "rclone remote $remote is not configured"
[ -r "$config" ] || skip "no folder list at $config"

while read -r id dir; do
    case "$id" in "" | "#"*) continue ;; esac
    case "$dir" in /*) ;; *) dir="$HOME/$dir" ;; esac

    if [ "${1:-}" = "-u" ]; then
        if mountpoint -q "$dir" && ! fusermount -u "$dir"; then
            notify-send -u critical "Google Drive" "Unmount of $dir failed (files still open?)"
        fi
        continue
    fi

    mountpoint -q "$dir" && continue
    mkdir -p "$dir"
    if ! rclone mount "$remote" "$dir" \
        --drive-root-folder-id "$id" \
        --vfs-cache-mode full \
        --vfs-cache-max-size 10G \
        --vfs-cache-max-age 720h \
        --log-file "$log" --log-level NOTICE \
        --daemon; then
        notify-send -u critical "Google Drive" "Mount of $dir failed, see $log"
    fi
done < "$config"
