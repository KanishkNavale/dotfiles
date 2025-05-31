#!/bin/bash

echo_info() {
    echo -e "\e[34m[INFO]: $1\e[0m"
}

echo_error() {
    echo -e "\e[31m[ERROR]: $1\e[0m"
}

echo_done() {
    echo -e "\e[32m[Done]\e[0m"
}

prequisites(){
    echo_info "Installing prequisites ..."

    echo_info "Updating system ..."
    sudo pacman -Syu --noconfirm &> /dev/null

    echo_info "Installing general prequisites ..."
    sudo pacman -Syu --noconfirm \
    python3-venv \
    python3-pip \
    python3-poetry \
    eza \
    git \
    curl \
    zsh \
    fzf \
    btop \
    yazi \
    vim &> /dev/null

    echo_info "Installing AUR helper ..."
    if ! command -v yay &> /dev/null; then
        echo_info "Installing yay ..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm &> /dev/null
        cd -
        rm -rf /tmp/yay
    fi

    echo_done
}

migrate_shell(){
    echo_info "Changing default shell to zsh ..."
    chsh -s $(which zsh) $USER

    echo_info "Updating .zshrc file ..."
    rm -rf $HOME/.zshrc
    ln -s $(pwd)/.zshrc $HOME/.zshrc

    echo_done
}

migrate_fonts(){
    echo_info "Installing fonts ..."
    sudo cp fonts/* /usr/share/fonts/ &> /dev/null
    sudo fc-cache -fv &> /dev/null

    echo_done
}

migrate_omz(){
    ZSH_CUSTOM_PATH="$HOME/.oh-my-zsh/custom"

    echo_info "Installing oh-my-zsh ..."
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    echo_info "Installing zsh plugins ..."
    if [ ! -d "$ZSH_CUSTOM_PATH/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM_PATH/plugins/zsh-autosuggestions
    fi

    if [ ! -d "$ZSH_CUSTOM_PATH/plugins/fast-syntax-highlighting" ]; then
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM_PATH/plugins/fast-syntax-highlighting
    fi

    if [ ! -d "$ZSH_CUSTOM_PATH/plugins/zsh-autocomplete" ]; then
        git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM_PATH/plugins/zsh-autocomplete
    fi

    echo_info "Installing powerlevel10k theme ..."
    if [ ! -d "$ZSH_CUSTOM_PATH/themes/powerlevel10k" ]; then
        git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM_PATH/themes/powerlevel10k
    fi

    echo_info "Updating .p10k.zsh file ..."
    sudo rm -rf $HOME/.p10k.zsh
    ln -s $(pwd)/.p10k.zsh $HOME/.p10k.zsh

    echo_done
}

migrate_vscode(){
    echo_info "Installing Visual Studio Code ..."
    if ! command -v code &> /dev/null; then
        echo_info "Installing Visual Studio Code ..."
        yay -S --noconfirm visual-studio-code-bin &> /dev/null
    fi

    echo_done
}

migrate_ghostty() {
    echo_info "Installing Ghostty ..."
    if ! command -v ghostty &> /dev/null; then
        echo_info "Installing Ghostty ..."
        yay -S --noconfirm ghostty &> /dev/null
    fi
    
    echo_done
}


migrate_git(){
    echo_info "Migrating git configuration ..."
    sudo rm -rf $HOME/.gitconfig
    ln -s $(pwd)/.gitconfig $HOME/.gitconfig

    echo_done
}

migrate_secrets(){
    echo_info "Decrypting Secrets ..."
    gpg secrets.sh.gpg

    sudo rm -rf $HOME/secrets.sh
    ln -s $(pwd)/secrets.sh $HOME/.secrets.sh

    echo_done
}

migrate_vim(){
    echo_info "Migrating vim configuration ..."
    sudo rm -rf $HOME/.vim $HOME/.vimrc

    mkdir -p $HOME/.vim
    mkdir -p $HOME/.vim/backup $HOME/.vim/undo $HOME/.vim/swap

    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    vim +PlugInstall +qall

    ln -s $(pwd)/.vimrc $HOME/.vimrc

    echo_done
}
