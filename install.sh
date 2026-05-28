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
  sh "$SCRIPT_DIR/bin/update_mirrors.sh"
  sh "$SCRIPT_DIR/bin/install_base.sh"
  sh "$SCRIPT_DIR/bin/setup_desktop_environment.sh"
  sh "$SCRIPT_DIR/bin/personalized_packages.sh"
    # SDDM theming - NOT TOUCHED
}

all
