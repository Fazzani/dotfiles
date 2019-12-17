# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export LC_ALL=en_US.UTF-8
export LSCOLORS=""
export GPG_TTY=$(tty)
export ZSH=$HOME/.oh-my-zsh

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
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
  fzf
  conda-zsh-completion
)

case "$OSTYPE" in
  darwin*)  plugins+=(brew osx) ;;
  linux*)   echo "not yet" ;;
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


neofetch

# Autoload -U compinit && compinit
