# Name the zellij tab after the current directory, or after the running command.

[[ -n $ZELLIJ && -z $NVIM ]] || return # Don't do it when we run inside neovim already

# Find the tab the current shell runs in
_zellij_tab_id=$(command zellij action list-panes --tab --json |
    jq -r --argjson pane "$ZELLIJ_PANE_ID" \
        '.[] | select(.id == $pane and (.is_plugin | not)) | .tab_id')

if [[ -z $_zellij_tab_id ]]; then
    print -u2 "zellij.zsh: tab of pane $ZELLIJ_PANE_ID not found, tab names are not updated"
    return
fi

_zellij_rename_tab() {
    command zellij action rename-tab --tab-id "$_zellij_tab_id" "$1" >/dev/null
}

_zellij_dir_name() {
    if [[ $PWD == $HOME ]]; then
        print -r -- "~"
    else
        print -r -- "${PWD:t}"
    fi
}

_zellij_tab_to_dir() {
    _zellij_rename_tab "$(_zellij_dir_name)"
}

_zellij_tab_to_command() {
    local cmdline=$1
    if [[ $cmdline == nvim* ]]; then
        cmdline="nvim: $(_zellij_dir_name)"
    fi
    _zellij_rename_tab "$cmdline"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _zellij_tab_to_dir
add-zsh-hook preexec _zellij_tab_to_command
