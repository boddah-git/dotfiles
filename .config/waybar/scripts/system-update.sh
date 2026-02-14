#!/usr/bin/env bash

CACHE="$HOME/.cache/waybar-updates.json"
LOCKFILE="$HOME/.cache/waybar-updates.lock"
INTERVAL=900

mkdir -p "$HOME/.cache"

# ------------------------------
# Detect AUR helper
# ------------------------------
get_aur_helper() {
  if command -v yay >/dev/null 2>&1; then
    echo "yay"
  elif command -v paru >/dev/null 2>&1; then
    echo "paru"
  else
    echo ""
  fi
}

aur_helper=$(get_aur_helper)

# ------------------------------
# Upgrade mode
# ------------------------------
if [ "$1" = "up" ]; then
  trap 'pkill -RTMIN+20 waybar' EXIT

  kitty --title "󰞒  - System Update" sh -c "
    sudo pacman -Syu
    if [ -n \"$aur_helper\" ]; then
      $aur_helper -Syu
    fi
    if command -v flatpak >/dev/null 2>&1; then
      flatpak update
    fi
    printf '\nPress any key to continue...'
    read -n 1
  "

  rm -f "$CACHE"
  exit 0
fi

# ------------------------------
# Always show icon instantly
# ------------------------------
if [ -f "$CACHE" ]; then
  cat "$CACHE"
else
  echo '{"text":"󰮠","tooltip":"Initializing..."}'
fi

# ------------------------------
# Prevent parallel runs
# ------------------------------
if [ -f "$LOCKFILE" ]; then
  exit 0
fi

touch "$LOCKFILE"

(
  # Run fastfetch first (non-blocking, silent)
  if command -v fastfetch >/dev/null 2>&1; then
    fastfetch --load-config none >/dev/null 2>&1
  fi

  # Throttle update checks
  if [ -f "$CACHE" ]; then
    last_run=$(date -r "$CACHE" +%s 2>/dev/null)
    now=$(date +%s)
    if [ -n "$last_run" ] && (( now - last_run < INTERVAL )); then
      rm -f "$LOCKFILE"
      exit 0
    fi
  fi

  official_updates=0
  aur_updates=0
  flatpak_updates=0

  if command -v checkupdates >/dev/null 2>&1; then
    official_updates=$(checkupdates 2>/dev/null | wc -l)
  fi

  if [ -n "$aur_helper" ]; then
    aur_updates=$($aur_helper -Qua --quiet 2>/dev/null | wc -l)
  fi

  if command -v flatpak >/dev/null 2>&1; then
    flatpak update --appstream --assumeno >/dev/null 2>&1
    flatpak_updates=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
  fi

  total=$((official_updates + aur_updates + flatpak_updates))

  tooltip="Official:   $official_updates\nAUR ($aur_helper):  $aur_updates\nFlatpak:    $flatpak_updates"

  if [ "$total" -eq 0 ]; then
    json='{"text":"󰮠","tooltip":"Packages are up to date"}'
  else
    json="{\"text\":\"󰣇\",\"tooltip\":\"${tooltip}\"}"
  fi

  echo "$json" > "$CACHE"
  pkill -RTMIN+20 waybar

  rm -f "$LOCKFILE"
) &

exit 0

