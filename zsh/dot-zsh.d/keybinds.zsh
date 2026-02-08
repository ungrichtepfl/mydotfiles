bindkey -e # Select emacs keybindings to be compatible with bash
autoload edit-command-line
zle -N edit-command-line
bindkey  "^X^E"   edit-command-line
bindkey  "^[[H"   beginning-of-line # HOME
bindkey  "^[[F"   end-of-line       # END
bindkey  "^[[3~"  delete-char       # DELETE
