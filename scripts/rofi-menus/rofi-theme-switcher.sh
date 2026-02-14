#!/usr/bin/env bash
# Rofi Theme Switcher Menu

THEME_DIR="${HOME}/.config/theme-manager/themes"
CURRENT_THEME="${HOME}/.config/theme-manager/current.yaml"
THEME_MANAGER="${HOME}/dotfiles/scripts/theme-manager"

# ---------- Menu definitions ----------
main_menu() {
    # List all available themes
    if [ ! -d "$THEME_DIR" ]; then
        echo "Error: Theme directory not found"
        return
    fi
    
    for theme_file in "$THEME_DIR"/*.yaml; do
        if [ -f "$theme_file" ]; then
            theme_name=$(basename "$theme_file" .yaml)
            
            # Check if this is the current theme
            if [ -f "$CURRENT_THEME" ]; then
                current_name=$(grep "^name:" "$CURRENT_THEME" | cut -d'"' -f2)
                file_name=$(grep "^name:" "$theme_file" | cut -d'"' -f2)
                
                if [ "$current_name" = "$file_name" ]; then
                    echo "● $theme_name"
                else
                    echo "  $theme_name"
                fi
            else
                echo "  $theme_name"
            fi
        fi
    done
}

# ---------- Actions ----------
apply_theme() {
    local selection="$1"
    # Remove the bullet point and spaces if present
    local theme_name=$(echo "$selection" | sed 's/^● *//' | sed 's/^  *//')
    
    # Check if theme manager exists
    if [ ! -f "$THEME_MANAGER" ]; then
        notify-send "Theme Manager Error" "theme-manager not found at $THEME_MANAGER"
        exit 1
    fi
    
    # Apply the theme
    if "$THEME_MANAGER" apply "$theme_name"; then
        notify-send "Theme Applied" "Switched to $theme_name" -i preferences-desktop-theme
        
        # Reload applications
        reload_apps
    else
        notify-send "Theme Error" "Failed to apply $theme_name" -u critical
    fi
}

reload_apps() {
    # Reload Mako
    if command -v makoctl > /dev/null; then
        makoctl reload
    fi
    
    # Reload Kitty (send SIGUSR1 to reload config)
    if pgrep -x kitty > /dev/null; then
        pkill -SIGUSR1 kitty
    fi
    
    # Reload KDE/Dolphin configuration
    if command -v qdbus > /dev/null; then
        # Force KDE to re-read kdeglobals
        qdbus org.kde.KGlobalSettings /KGlobalSettings org.kde.KGlobalSettings.notifyChange 2 0 2>/dev/null || true
        
        # Also try with dbus-send as fallback
        if command -v dbus-send > /dev/null; then
            dbus-send --session --dest=org.kde.KGlobalSettings \
                /KGlobalSettings org.kde.KGlobalSettings.notifyChange int32:2 int32:0 2>/dev/null || true
        fi
        
        # Wait a moment for settings to propagate
        sleep 0.3
        
        # Restart Dolphin if running
        if pgrep -x dolphin > /dev/null; then
            if command -v kquitapp6 > /dev/null; then
                kquitapp6 dolphin 2>/dev/null || killall dolphin
            else
                killall dolphin
            fi
            sleep 0.5
            dolphin &>/dev/null &
            disown
        fi
    fi
}

# ---------- Dispatcher ----------
case "$1" in
    "")
        main_menu
        ;;
    *)
        apply_theme "$1"
        ;;
esac
