#!/bin/bash

set +eux
trap cleanup 1 2 3 6

# ============================================================================
# ============================ Functions   ===================================
# ============================================================================

function error(){
    echo "$(tput setaf 3; tput setab 1) $1 $(tput sgr0)"
}

function info(){
    echo "$(tput setaf 2) $1 $(tput sgr0)"
}

function cleanup(){
    [[ -d "$HOME/dotfiles" ]] && rm -rf "$HOME/dotfiles"
}

function usage()
{
   info "Usage: $progname [--light] [--verbose] [--reinstall]

   optional arguments:
     -h, --help           show this help message and exit
     -v, --verbose        increase the verbosity of the bash script
     -l, --light          does not install system packages
     -r, --reinstall          reinstall from scratch"
}

function os_linux_install(){
    info "installing packages for linux os"
    sudo apt-get update -y && \
    sudo apt-get upgrade -y

    sudo add-apt-repository ppa:jonathonf/vim
    sudo apt update
    sudo apt install vim


    # Add Node.js to sources.list
    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

    # Add Yarn to sources.list
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

    linux_packages=("${COMMON_PACKAGES[@]}" libffi-dev libssl-dev python python-pip xclip xsel npm \
    apt-transport-https \
    nodejs \
    yarn \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common)

    for i in "${linux_packages[@]}"; do
        info "installing $i package"
        command -v "$i" >/dev/null 2>&1 || sudo apt-get install --ignore-missing --no-install-recommends --no-upgrade --show-progress -y "$i"
    done

    sudo apt autoremove
    # install for raspbian
    [[ $is_rasp == true ]] && {
        command -v docker >/dev/null 2>&1 || curl -sSL https://get.docker.com | sh && sudo usermod -aG docker pi
        # command -v docker-compose >/dev/null 2>&1 || { sudo apt-get remove python-configparser; sudo pip install docker-compose; }
        command -v bat >/dev/null 2>&1 || { wget https://github.com/sharkdp/bat/releases/download/v0.12.1/bat_0.12.1_armhf.deb && sudo dpkg -i bat_0.12.1_armhf.deb && rm bat_0.12.1_armhf.deb; }
        command -v fd >/dev/null 2>&1 || { wget https://github.com/sharkdp/fd/releases/download/v7.4.0/fd_7.4.0_armhf.deb && sudo dpkg -i fd_7.4.0_armhf.deb && rm fd_7.4.0_armhf.deb; }
    }

    # install kubectx and kubens
    sudo git clone https://github.com/ahmetb/kubectx ~/.kubectx
    sudo ln -s ~/.kubectx/kubectx /usr/local/bin/kubectx
    sudo ln -s ~/.kubectx/kubens /usr/local/bin/kubens

    mkdir -p ~/.oh-my-zsh/completions
    chmod -R 755 ~/.oh-my-zsh/completions
    ln -s ~/.kubectx/completion/kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh
    ln -s ~/.kubectx/completion/kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh
}

function os_macos_install(){
    info "installing packages for mac os"
    brew tap homebrew/cask-fonts                                                                                                                                                                                               ░▒▓ 16:03:20 ─╯
    brew cask install font-hack-nerd-font
    brew install git zsh fzf zsh-syntax-highlighting zsh-autosuggestions bat gist diff-so-fancy neofetch
}

function install_packages(){
    case "$OSTYPE" in
    darwin*)  os_macos_install ;;
    linux*)   os_linux_install ;;
    *)        error "not supprted os: $OSTYPE" ;;
    esac

    command -v diff-so-fancy >/dev/null 2>&1 || {  info "diff-so-fancy";npm install -g diff-so-fancy; }
}

function install_for_wsl(){

    windowsUserProfile=/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')

    # Windows Terminal settings
    cp ./terminal-settings.json ${windowsUserProfile}/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json

    # Avoid too much RAM consumption
    cp ./.wslconfig ${windowsUserProfile}/.wslconfig
}

function install_terminal(){
    info "oh-my-zsh setup"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh) --unattended"
    # git clone --depth=1 https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
    info "PowerLevel10k setup"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/themes/powerlevel10k"
    info "FZF setup"
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" && "$HOME/.fzf/install" --all
    info "PlugVim setup"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    info "zsh-syntax-highlighting setup"
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    info "zsh-autosuggestions setup"
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    info "conda-zsh-completion setup"
    git clone --depth=1 https://github.com/esc/conda-zsh-completion ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/conda-zsh-completion
    info "bat setup"
    command -v bat >/dev/null 2>&1 || { wget https://github.com/sharkdp/bat/releases/download/v0.12.1/bat_0.12.1_amd64.deb && sudo dpkg -i bat_0.12.1_amd64.deb && rm bat_0.12.1_amd64.deb; }
}

function remove_all(){
    rm -rf "$HOME/.oh-my-zsh"
    rm -rf "$HOME/.dotfiles"
}


# ============================================================================
# ============================ Variables   ===================================
# ============================================================================

cd "$HOME" || return
[[ -z "$PAT" ]] && { error "Github PAT must be defined"; exit 1; }

progname=$(basename "$0")

is_rasp=false
[[ -f "/proc/device-tree/model" ]] && [[ $(cat /proc/device-tree/model) == Raspberry* ]] && is_rasp=true

COMMON_PACKAGES=(git zsh zsh-syntax-highlighting zsh-autosuggestions bat jq ripgrep pbcopy lastpass-cli gist neofetch)

LIGHT=false
reinstall=false
# ============================================================================
# ============================ Main   ========================================
# ============================================================================

for i in "$@"
do
case $i in
    # -s=*|--searchpath=*)
    # SEARCHPATH="${i#*=}"
    # ;;
    -l|--light)
    LIGHT=true
    ;;
    -v|--verbose)
    verbose=true
    ;;
    -r|--reinstall)
    reinstall=true
    ;;
    -h|--help)
    usage && exit 0
    ;;
    *)
    usage && exit 0
    ;;
esac
done

[[ $verbose = true ]] && echo "=========== Raspbian: $is_rasp ============"

[[ $reinstall = true ]] && remove_all

[[ $LIGHT = false ]] && install_packages

install_terminal

echo "export PAT=$PAT" >>! "$HOME/.env"

[[ $verbose ]] && info "dotfiles installation\n"
[[ -d "/mnt/c/Users" ]] && install_for_wsl

dotfiles_target="$HOME/.dotfiles"
git clone --depth=1 https://$PAT@github.com/fazzani/dotfiles "$dotfiles_target" || { git fetch && git reset --hard origin/master && git checkout origin/master; }
ln -sf "$dotfiles_target/dot.zshrc" "$HOME/.zshrc"
ln -sf "$dotfiles_target/dot.vimrc" "$HOME/.vimrc"
ln -sf "$dotfiles_target/dot.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$dotfiles_target/dot.alias" "$HOME/.alias"
# ln -sf "$dotfiles_target/dot.gitconfig" "$HOME/.gitconfig"
ln -sf "$dotfiles_target/dot.p10k.zsh" "$HOME/.p10k.zsh"
ln -sf "$dotfiles_target/dot.common" "$HOME/.common"
ln -sf "$dotfiles_target/dot.fzf.sh" "$HOME/.fzf.sh"
ln -sf "$dotfiles_target/neofetch.config.conf" "$HOME/.config/neofetch/config.conf"

command -v zsh && chsh -s /bin/zsh && zsh

[[ $verbose = true ]] && info "End of installation"

(umask 0077 && echo "$PAT" > ~/.gist)

exit 0
