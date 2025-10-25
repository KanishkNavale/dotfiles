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
    sudo pacman -Syu --noconfirm 

    echo_info "Installing general prequisites ..."
    sudo pacman -S --noconfirm \
    os-prober \
    python-virtualenv \
    python-pip \
    python-poetry \
    python-psutil \
    eza \
    git \
    curl \
    zsh \
    fzf \
    btop \
    yazi \
    vim \
    zoxide \
    ghostty \
    bat \

    echo_info "Installing AUR helper ..."
    if ! command -v paru &> /dev/null; then
        echo_info "Installing paru ..."
        git clone https://aur.archlinux.org/paru.git /tmp/paru
        cd /tmp/paru
        makepkg -si --noconfirm
        cd -
        rm -rf /tmp/paru
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
    sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd ttf-meslo-nerd
    sudo fc-cache

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

install_vscode(){
    echo_info "Installing Visual Studio Code ..."
    if ! command -v code &> /dev/null; then
        echo_info "Installing Visual Studio Code ..."
        paru -S --noconfirm visual-studio-code-bin
    fi

    echo_done
}

migrate_ghostty() {
    echo_info "Installing Ghostty ..."
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

migrate_theme(){
    echo_info "Migrating dracula theme ..."
    paru -S --noconfirm dracula-gtk-theme dracula-icon-theme
    gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
    gsettings set org.gnome.desktop.interface icon-theme "Dracula"
    gsettings set org.gnome.shell.extensions.user-theme name "Dracula"
    echo_done
}

migrate_grub(){
    echo_info "Migrating GRUB configuration ..."
    sudo cp -r $(pwd)/dedsec /boot/grub/themes/
    
    sudo cp /etc/default/grub /etc/default/grub.bak
    sudo cp $(pwd)/grub /etc/default/

    sudo cp /etc/grub.d/10_linux /etc/grub.d/10_linux.bak
    sudo cp $(pwd)/10_linux /etc/grub.d/

    sudo grub-mkconfig -o /boot/grub/grub.cfg

    echo_done
}

migrate_docker(){
    echo_info "Migrating Docker ..."
    sudo pacman -S --noconfirm docker docker-compose docker-buildx nvidia-container-toolkit

    echo_info "Enabling and starting Docker service..."
    sudo systemctl enable docker.service
    sudo systemctl start docker.service

    echo_info "Configuring NVIDIA Container Toolkit..."
    sudo nvidia-ctk runtime configure --runtime=docker
    sudo systemctl restart docker.service

    echo_info "Adding $USER to docker group..."
    sudo groupadd docker
    sudo usermod -aG docker $USER

    echo_info "Docker installation and setup complete!"
    echo_info "You may need to log out and back in for group changes to take effect."
}
