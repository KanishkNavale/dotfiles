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
    sudo apt-get update && sudo apt-get upgrade -y

    sudo apt-get install software-properties-common snapd nala -y
    
    sudo nala install -y \
    python3-venv \
    python3-pip \
    python3-poetry \
    eza \
    git \
    curl \
    fzf \
    zsh \
    vim \
    htop &> /dev/null

    echo_done
}

update_shell(){
    echo_info "Changing default shell to zsh ..."
    chsh -s $(which zsh) $USER

    echo_info "Updating .zshrc file ..."
    rm -rf $HOME/.zshrc
    ln -s $(pwd)/.zshrc $HOME/.zshrc

    echo_done
}

fonts (){
    echo_info "Installing fonts ..."
    sudo cp fonts/* /usr/share/fonts/ &> /dev/null
    sudo fc-cache -fv &> /dev/null
}

oh_my_zsh(){
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

vscode(){
    echo_info "Installing Visual Studio Code ..."
    sudo snap install code --classic

    echo_done
}

ghostty(){
    echo_info "Installing Ghostty ..."
    source /etc/os-release
    curl -L -O "https://github.com/mkasberg/ghostty-ubuntu/releases/download/1.0.1-0-ppa1/ghostty_1.0.1-0.ppa1_amd64_${VERSION_ID}.deb"
    sudo dpkg -i ghostty_1.0.1-0.ppa1_amd64_${VERSION_ID}.deb
    rm ghostty_1.0.1-0.ppa1_amd64_${VERSION_ID}.deb

    echo_info "Updating Ghostty configuration ..."
    sudo rm -rf $HOME/.config/ghostty
    ln -s $(pwd)/ghostty $HOME/.config/ghostty

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
    ln -s $(pwd)/secrets.sh $HOME/secrets.sh

    echo_done
}
