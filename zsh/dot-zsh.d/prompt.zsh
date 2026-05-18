setopt prompt_subst

PROMPT=$'%{$fg_bold[red]%}%n%{$fg_bold[yellow]%}@%{$fg_bold[green]%}%m %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%}%{$fg[blue]%}%{$fg_bold[blue]%} %#%{$reset_color%} '

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"                              # plus/minus     - clean repo
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"             # A"NUM"         - ahead by "NUM" commits
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"           # B"NUM"         - behind by "NUM" commits
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"    # lightning bolt - merge conflict
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"       # red circle     - untracked files
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"     # yellow circle  - tracked files modified
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"        # green circle   - staged changes present = ready for "git push"

parse_git_branch() {
    if jj root &>/dev/null; then
        jj log -r '@' --no-graph -T 'if(description.first_line(), description.first_line(), "(no description)")' 2>/dev/null
        return
    fi
    # Show Git branch/tag, or name-rev if on detached head
    ( git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD ) 2> /dev/null
}

parse_git_state() {
    local GIT_STATE=""
    local trunk_branch=""
    local GIT_DIR="$(git rev-parse --git-dir 2>/dev/null)"

    if jj root &>/dev/null; then
        if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
            GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
        fi
        if [[ -n "$(jj diff --summary 2>/dev/null)" ]]; then
            GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
        fi
    else
        local NUM_AHEAD="$(git log --oneline @{u}.. 2>/dev/null | wc -l | tr -d ' ')"
        local NUM_BEHIND="$(git log --oneline ..@{u} 2>/dev/null | wc -l | tr -d ' ')"
        if [ "$NUM_AHEAD" -gt 0 ]; then GIT_STATE=$GIT_STATE${GIT_PROMPT_AHEAD//NUM/$NUM_AHEAD}; fi
        if [ "$NUM_BEHIND" -gt 0 ]; then GIT_STATE=$GIT_STATE${GIT_PROMPT_BEHIND//NUM/$NUM_BEHIND}; fi

        if [ -n $GIT_DIR ] && test -r $GIT_DIR/MERGE_HEAD; then
            GIT_STATE=$GIT_STATE$GIT_PROMPT_MERGING
        fi
        if [[ -n $(git ls-files --other --exclude-standard 2>/dev/null) ]]; then
            GIT_STATE=$GIT_STATE$GIT_PROMPT_UNTRACKED
        fi
        if ! git diff --quiet 2>/dev/null; then
            GIT_STATE=$GIT_STATE$GIT_PROMPT_MODIFIED
        fi
        if ! git diff --cached --quiet 2>/dev/null; then
            GIT_STATE=$GIT_STATE$GIT_PROMPT_STAGED
        fi
    fi

    if [[ -n $GIT_STATE ]]; then
        echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
    fi
}

git_prompt_string() {
    local git_where="$(parse_git_branch)"

    # If inside a Git repository, print its branch and state
    [ -n "$git_where" ] && echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX%{$fg[yellow]%}${git_where#(refs/heads/|tags/)}$GIT_PROMPT_SUFFIX%{$fg[red]%}%(?..[%?])"

    # If not inside the Git repo, only yprint exit codes of last command (only if it failed)
    [ ! -n "$git_where" ] && echo "%{$fg[red]%} %(?..[%?])"
}
# Apply different settings for different terminals
case $(basename "$(cat "/proc/$PPID/comm")") in
    login)
        RPROMPT="%{$fg[red]%} %(?..[%?])"
        ;;
    *)
        RPROMPT='$(git_prompt_string)'
        ;;
esac
