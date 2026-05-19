bindkey -e # Select emacs keybindings to be compatible with bash
autoload edit-command-line
zle -N edit-command-line
bindkey  "^X^E"   edit-command-line
bindkey  "^[[H"   beginning-of-line # HOME
bindkey  "^[[F"   end-of-line       # END
bindkey  "^[[3~"  delete-char       # DELETE
bindkey  "^[z"    undo              # Nicer for swiss keyboard than C-_
bindkey  "^[Z"    redo

bindkey -s '^f' 'cd "$(fd -t d . | fzf)"\n'

yazicd () {
    tmp="$(mktemp)"
    yazi --cwd-file="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'yazicd\n'
