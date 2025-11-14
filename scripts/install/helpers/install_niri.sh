#!/usr/bin/env bash

set -e
ROOT_DIR="$(dirname "$(dirname "$(realpath "$0")")")"

NIRI_PKGS="$ROOT_DIR/packages/niri.pkgs"

echo "Installing Niri..."
$AUR_HELPER -S --needed --noconfirm $(grep -v '^#' "$NIRI_PKGS")

