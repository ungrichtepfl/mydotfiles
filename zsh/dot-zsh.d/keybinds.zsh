bindkey -e # Select emacs keybindings to be compatible with bash
autoload edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
