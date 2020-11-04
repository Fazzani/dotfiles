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

ZSH_THEME=powerlevel10k/powerlevel10k
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
[ -f "$HOME/.p10k.zsh" ]  && source "$HOME/.p10k.zsh"

fpath+="$ZSH/plugins/conda-zsh-completion"
zstyle ':completion::complete:*' use-cache 1

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

neofetch

# Autoload -U compinit && compinit

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
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
command -v az &>/dev/null && source /etc/bash_completion.d/azure-cli

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

# Source github autocomplete
