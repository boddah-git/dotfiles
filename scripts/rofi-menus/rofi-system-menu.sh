#!/bin/env bash

# ---------- Menu definitions ----------

main_menu() {
    echo "Update system"
    echo "Launch Firefox"
    echo "Open Terminal"
    echo "Reboot"
    echo "Shutdown"
}

# ---------- Actions ----------

update_system() {
    alacritty -e sudo pacman -Syu
}

launch_firefox() {
    firefox &
}

open_terminal() {
    alacritty &
}

reboot_system() {
    systemctl reboot
}

shutdown_system() {
    systemctl poweroff
}

# ---------- Dispatcher ----------

case "$1" in
    "")
        main_menu
        ;;
    "Update system")
        update_system
        ;;
    "Launch Firefox")
        launch_firefox
        ;;
    "Open Terminal")
        open_terminal
        ;;
    "Reboot")
        reboot_system
        ;;
    "Shutdown")
        shutdown_system
        ;;
esac

