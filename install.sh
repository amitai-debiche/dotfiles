#!/usr/bin/env bash


# ==================================================
# Script: install.sh
# Description: This script creates symlinks for my dotfiles
# Usage: ./install.sh
# Author: Amitai Debiche
# Date 2024-06-05
# Version 1.0
# ==================================================
BASEDIR=$(dirname $0)
cd $BASEDIR


create_symlink() {
    local target_file=$1
    local symlink=$2

    if [ -L "$symlink" ]; then
        echo "Symlink $symlink already exists!"
    elif [ -e "$symlink" ]; then
        echo "File $symlink exists but is not symlink"
    else
        ln -s "$target_file" "$symlink"
        echo "Created symlink $symlink -> $target_file":w
    fi
}

create_symlink "${PWD}/nvim" ~/.config/nvim


