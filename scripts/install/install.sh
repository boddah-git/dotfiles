#!/usr/bin/env bash

set -e

ROOT_DIR="$(dirname "$(realpath "$0")")"

echo "== Dotfiles Installer =="

# Ask for AUR helper
echo "Select AUR helper:"
echo "1) paru"
echo "2) yay"
read -rp "Choice (1/2): " choice

if [[ "$choice" == "1" ]]; then
    export AUR_HELPER="paru"
elif [[ "$choice" == "2" ]]; then
    export AUR_HELPER="yay"
else
    echo "Invalid choice."
    exit 1
fi

echo "Using AUR helper: $AUR_HELPER"

# Run modular installers
bash "$ROOT_DIR/helpers/aur_helper.sh"
bash "$ROOT_DIR/helpers/install_packages.sh"
bash "$ROOT_DIR/helpers/install_fonts.sh"
bash "$ROOT_DIR/helpers/install_niri.sh"

echo "Installation complete!"

