#!/usr/bin/env bash

~/dotfiles/scripts/rofi-menus/rofi-power-menu.sh | rofi -dmenu -theme ~/.config/rofi/power-menu.rasi | xargs -I {} ~/dotfiles/scripts/rofi-menus/rofi-power-menu.sh "{}"

