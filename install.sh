#!/bin/bash

source scripts/modules.sh

confirm_and_run() {
    local cmd="$1"
    echo_info "Ready to run '$cmd'"
    read -n1 -p "Run '$cmd'? [y/N]: " reply
    echo # move to a new line after single keypress
    if [[ "$reply" =~ ^[Yy]$ ]]; then
        echo_info "Executing '$cmd'..."
        $cmd
    else
        echo_info "Skipped '$cmd'"
    fi
}

confirm_and_run prequisites
confirm_and_run migrate_git
confirm_and_run migrate_secrets
confirm_and_run migrate_shell
confirm_and_run migrate_fonts
confirm_and_run migrate_omz
confirm_and_run migrate_vscode
confirm_and_run migrate_ghostty
confirm_and_run migrate_vim

exec zsh