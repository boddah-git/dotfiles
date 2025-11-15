#!/usr/bin/env bash

set -e
ROOT_DIR="$(dirname "$(dirname "$(realpath "$0")")")"

FONT_FILE="$ROOT_DIR/packages/fonts.pkgs"

echo "Installing fonts..."
$AUR_HELPER -S --needed --noconfirm $(grep -v '^#' "$FONT_FILE")

