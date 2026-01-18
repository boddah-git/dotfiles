#!/usr/bin/env bash

# ---------- Icons ----------
lock=""
logout=""
sleep=""
reboot=""
shutdown=""

# ---------- Menu ----------
power_menu() {
    echo "$lock"
    echo "$logout"
    echo "$sleep"
    echo "$reboot"
    echo "$shutdown"
}

# ---------- Actions ----------
lock_screen() {
    betterlockscreen --lock
}

logout_user() {
    loginctl terminate-user "$(whoami)"
}

suspend_system() {
    systemctl suspend
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
        power_menu
        ;;
    "$lock")
        lock_screen
        ;;
    "$logout")
        logout_user
        ;;
    "$sleep")
        suspend_system
        ;;
    "$reboot")
        reboot_system
        ;;
    "$shutdown")
        shutdown_system
        ;;
esac

