#!/bin/sh
# Mount selected Google Drive folders with rclone.
# Files are only listed; each file is downloaded when it is opened.
#
# Usage: gdrive-mount.sh       unmount the folders that are no longer in the
#                              list, then mount all listed folders that are not
#                              mounted yet
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

log() {
    echo "$(date '+%F %T') gdrive-mount: $1" >> "$log"
}

skip() {
    log "$1, nothing to do"
    exit 0
}

command -v rclone >/dev/null 2>&1 || skip "rclone is not installed"
rclone listremotes | grep -qx "$remote" || skip "rclone remote $remote is not configured"
[ -r "$config" ] || skip "no folder list at $config"

# Prints "<folder ID> <absolute mount directory>" for each folder in the list.
listed_folders() {
    while read -r id dir; do
        case "$id" in "" | "#"*) continue ;; esac
        case "$dir" in /*) ;; *) dir="$HOME/$dir" ;; esac
        echo "$id $dir"
    done < "$config"
}

# rclone names the source of a mount "<remote name>{<hash>}:".
mounted_dirs_of_remote() {
    findmnt --list --noheadings --types fuse.rclone --output SOURCE,TARGET |
        while read -r source dir; do
            case "$source" in "${remote%:}{"*) echo "$dir" ;; esac
        done | sort -u
}

unmount() {
    if ! fusermount -u "$1"; then
        log "unmount of $1 failed"
        notify-send -u critical "Google Drive" "Unmount of $1 failed (files still open?)"
        return
    fi
    log "unmounted $1"
    rmdir "$1" || log "could not remove $1 after unmount"
}

if [ "${1:-}" = "-u" ]; then
    mounted_dirs_of_remote | while read -r dir; do unmount "$dir"; done
    exit 0
fi

listed_dirs="$(listed_folders | cut -d' ' -f2-)"
mounted_dirs_of_remote | while read -r dir; do
    printf '%s\n' "$listed_dirs" | grep -qxF "$dir" || unmount "$dir"
done

listed_folders | while read -r id dir; do
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
done
