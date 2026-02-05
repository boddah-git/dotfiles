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
    else
        notify-send "Theme Error" "Failed to apply $theme_name" -u critical
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
