#!/usr/bin/env bash

set -e

if ! command -v "$AUR_HELPER" &>/dev/null; then
    echo "$AUR_HELPER not found. Installing..."
    sudo pacman -S --needed --noconfirm git base-devel

    cd /tmp
    git clone "https://aur.archlinux.org/${AUR_HELPER}.git"
    cd "$AUR_HELPER"
    makepkg -si --noconfirm
fi

echo "$AUR_HELPER is installed."

