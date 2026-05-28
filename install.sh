#!/bin/bash
set -euo pipefail

sudo -v || exit 1
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

all() {
  sh bin/update_mirrors.sh
  sh bin/install_base.sh
  sh bin/setup_desktop_environment.sh
  sh bin/personalized_packages.sh
    # SDDM theming - NOT TOUCHED
}

all
