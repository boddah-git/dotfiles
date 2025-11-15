#!/usr/bin/env bash

set -e
ROOT_DIR="$(dirname "$(dirname "$(realpath "$0")")")"

PKG_FILE="$ROOT_DIR/packages/base.pkgs"

echo "Installing base packages..."
$AUR_HELPER -S --needed --noconfirm $(grep -v '^#' "$PKG_FILE")

