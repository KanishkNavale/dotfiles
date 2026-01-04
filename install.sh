#!/bin/bash

source automate.sh

confirm_and_run() {
    local cmd="$1"
    echo_info "Ready to run '$cmd'"
    read -n1 -p "Run '$cmd'? [y/N]: " reply
    echo
    if [[ "$reply" =~ ^[Yy]$ ]]; then
        echo_info "Executing '$cmd'..."
        $cmd
    else
        echo_info "Skipped '$cmd'"
    fi
}

confirm_and_run prequisites
confirm_and_run migrate_git
confirm_and_run migrate_shell
confirm_and_run migrate_fonts
confirm_and_run migrate_omz
confirm_and_run migrate_vscode
confirm_and_run migrate_ghostty
confirm_and_run migrate_vim
confirm_and_run migrate_grub
confirm_and_run migrate_docker
confirm_and_run migrate_additionals

exec zsh
