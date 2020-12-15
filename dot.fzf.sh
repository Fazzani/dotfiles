
# Configure fzf (if available).
if _has fzf; then
  # Source fzf key bindings and auto-completion.
  if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
    # Source fzf scripts via Homebrew.
    source /usr/local/opt/fzf/shell/key-bindings.zsh
    source /usr/local/opt/fzf/shell/completion.zsh
  elif [ -e /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
  elif [ -e ~/.fzf ]; then
    # Source fzf scripts via via local installation.
    _append_to_path ~/.fzf/bin
    source ~/.fzf/shell/key-bindings.zsh
    source ~/.fzf/shell/completion.zsh
  elif [ -f ~/.fzf.zsh ]; then
    # Auto-generated completion script when installing from custom path.
    source ~/.fzf.zsh
  fi

  if _has fd; then
    # Use fd for fzf.
    export FZF_DEFAULT_COMMAND="fd --type f --color=always --follow --hidden --exclude .git --exclude node_modules --exclude .vscode"
    # Use fd for fzf directory search.
    export FZF_ALT_C_COMMAND='fd --type d --color never'
  #elif _has rg; then
    # Use ripgrep for fzf.
    #export FZF_DEFAULT_COMMAND='rg --files --hidden'
  fi
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  # Source fzf-cd plugin.
  if [[ -f ~/.zsh-interactive-cd.plugin.zsh ]]; then
    source ~/.zsh-interactive-cd.plugin.zsh
  fi

  # Display source tree and file preview for CTRL-T and ALT-C.
  if _has tree; then
    # Show subdir tree for directories.
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
  fi

  # Bind alt-j/k/d/u to moving the preview window for fzf.
  export FZF_DEFAULT_OPTS="--bind ?:toggle-preview,alt-k:preview-up,alt-j:preview-down,alt-u:preview-page-up,alt-d:preview-page-down"

  # Show previews for files and directories.
  # Having `bat` or `highlight` (or any of the other binaries below) installed
  # enables syntax highlighting.
  export FZF_CTRL_T_OPTS="--ansi --preview '(bat --style=numbers --color=always {} || highlight -O ansi -l {} || coderay {} || rougify {} || cat {}) | head -200'"

  if _has bat; then
    # Export theme for http://github.com/sharkdp/bat.
    export BAT_THEME="TwoDark"
  fi

  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" --exclude ".vscode" . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" --exclude ".vscode" . "$1"
  }

  fzf_find_edit() {
      local file=$(
        fzf --query="$1" --no-multi --select-1 --exit-0 \
            --preview 'bat --color=always --line-range :500 {}'
        )
      if [[ -n $file ]]; then
          $EDITOR $file
      fi
  }

  alias ffe='fzf_find_edit'
fi

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
function fo() {
  local out file key
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    { [ "$key" = ctrl-o ] && open "$file"; } || ${EDITOR:-vim} "$file"
  fi
}

# fd - cd to selected directory
# function fd() {
#   local dir
#   dir=$(find ${1:-.} -path '*/\.*' -prune \
#                   -o -type d -print 2> /dev/null | fzf +m) &&
#   cd "$dir"
# }

function fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# fh - repeat history
function fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -r 's/ *[0-9]*\*? *//' | sed -r 's/\\/\\\\/g')
}

# Select a docker container to start and attach to
function da() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
}
# Select a running docker container to stop
function ds() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker stop "$cid"
}
# Select a docker container to remove
function drm() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

  [ -n "$cid" ] && docker rm "$cid"
}

# Git
function gli() {
  local filter
  if [ -n $@ ] && [ -f $@ ]; then
    filter="-- $@"
  fi

  git log \
    --graph --color=always --abbrev=7 --format='%C(auto)%h %C(red)%an %C(blue)%s %C(yellow)%cr' $@ | \
    fzf \
      --ansi --no-sort --reverse --tiebreak=index \
      --preview "f() { set -- \$(echo -- \$@ | grep -o '[a-f0-9]\{7\}'); [ \$# -eq 0 ] || git show --color=always \$1 $filter; }; f {}" \
      --bind "j:down,k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort,ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
                FZF-EOF" \
      --preview-window=right:60% \
      --height 80%
}

git config --global fetch.prune true
git config --global alias.prune-branches '!git remote prune origin && git branch -vv | grep '"'"': gone]'"'"' | awk '"'"'{print $1}'"'"' | xargs -r git branch -d'
git config --global alias.prune-branches-force '!git remote prune origin && git branch -vv | grep '"'"': gone]'"'"' | awk '"'"'{print $1}'"'"' | xargs -r git branch -D'