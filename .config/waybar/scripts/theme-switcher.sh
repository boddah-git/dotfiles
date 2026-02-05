#!/usr/bin/env bash
# Launcher script for rofi theme switcher

SCRIPT_DIR="$HOME/dotfiles/scripts/rofi-menus"
THEME_SWITCHER="$SCRIPT_DIR/rofi-theme-switcher.sh"
ROFI_THEME="$HOME/.config/rofi/theme-switcher.rasi"

# Make sure script is executable
chmod +x "$THEME_SWITCHER"

# Launch rofi with the theme switcher
"$THEME_SWITCHER" | rofi -dmenu \
    -theme "$ROFI_THEME" \
    -p "Select Theme" \
    -mesg "Choose a theme to apply" | xargs -I {} "$THEME_SWITCHER" "{}"



