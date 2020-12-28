# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/home/ansible/miniconda3/bin:$PATH
[[ -f "$HOME/.kubectx" ]] && export PATH=$HOME/.kubectx:$PATH
# Path to your oh-my-zsh installation.
export LC_ALL=en_US.UTF-8
# export LSCOLORS=""
export ZSH=$HOME/.oh-my-zsh
export ZSH_DISABLE_COMPFIX=true
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$ZSH/custom/plugins/zsh-syntax-highlighting/highlighters
export AZURE_CONFIG_DIR=$HOME/.azure

ZSH_THEME=powerlevel10k/powerlevel10k
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
[ -f "$HOME/.p10k.zsh" ]  && source "$HOME/.p10k.zsh"

fpath+="$ZSH/plugins/conda-zsh-completion"

plugins=(
  git
  z
  cp
  docker
  docker-compose
  helm
  kubectl
  colored-man-pages
  colorize
  jump
  pip
  history
  python
  history-substring-search
  fzf
  conda-zsh-completion
  zsh-autosuggestions
  zsh-syntax-highlighting
)

function install_linux {
  command -v diff-so-fancy &>/dev/null || npm i -g diff-so-fancy;
  dpkg -s fonts-firacode &>/dev/null || sudo apt install fonts-firacode;
  command -v ansible &>/dev/null || { sudo apt-add-repository ppa:ansible/ansible -y &>/dev/null && sudo apt update -yqq && sudo apt install ansible -y; }
}

case "$OSTYPE" in
  darwin*)  plugins+=(brew osx) ;;
  linux*)    install_linux ;;
  *)        echo "not supprted os: $OSTYPE" ;;
esac

# PATH=$PATH:~/Library/Python/2.7/bin
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
[ -f "$HOME/.env" ] && source "$HOME/.env"
[ -f "$HOME/.zshenv" ] && source "$HOME/.zshenv"
[ -f "$HOME/.alias" ]  && source "$HOME/.alias"
[ -f "$HOME/.dotfiles/.zsh_aliases" ]  && source "$HOME/.dotfiles/.zsh_aliases"
[ -f "$HOME/.common" ]  && source "$HOME/.common"
[ -f "$HOME/.fzf.sh" ]  && source "$HOME/.fzf.sh"
[ -f "$HOME/.fzf.zsh" ]  && source "$HOME/.fzf.zsh"
[ -f /usr/local/bin/kubectl ] && source <(kubectl completion zsh)
[ -f "$HOME/.tmux/tmux.completion.bash" ] && source "$HOME/.tmux/tmux.completion.bash"
[ -f "$HOME/.minikube-completion" ] && source "$HOME/.minikube-completion"
[ -f "$HOME/.dotfiles/.terraform_aliases" ] && source "$HOME/.dotfiles/.terraform_aliases"

# neofetch

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/ansible/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/ansible/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/ansible/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/ansible/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
# command -v az &>/dev/null && source /etc/bash_completion.d/azure-cliq

# emulate bash PROMPT_COMMAND (only for zsh)
precmd() { eval "$PROMPT_COMMAND" }
# open new terminal in same dir
PROMPT_COMMAND='pwd > "${HOME}/.cwd"'
[[ -f "${HOME}/.cwd" ]] && cd "$(< ${HOME}/.cwd)"

if [ $commands[gh] ]; then
  source <(gh completion --shell zsh)
  compdef _gh gh
  compdump
fi

function activate_systemd_wsl {
  git clone https://github.com/DamionGans/ubuntu-wsl2-systemd-script.git
  cd ubuntu-wsl2-systemd-script/
  bash ubuntu-wsl2-systemd-script.sh
  cd .. && rm -Rf ubuntu-wsl2-systemd-script
}

pidof systemd > /dev/null || activate_systemd_wsl
## Ajout des couleurs pour la complétion
zmodload -i zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache
setopt correctall

setopt histignorealldups sharehistory
# autoload -Uz compinit
# compinit
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'export PATH="$PATH:/home/ansible/sqlpackage"
export PATH="$PATH:/home/ansible/sqlpackage"
