#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo -v || exit 1
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &


all() {
  sh "$SCRIPT_DIR/system/update_mirrors.sh"
  sh "$SCRIPT_DIR/system/install_base.sh"
  sh "$SCRIPT_DIR/system/setup_desktop_environment.sh" "$windowManager"
  sh "$SCRIPT_DIR/system/personalized_packages.sh"
  # SDDM theming - NOT TOUCHED
}

all
