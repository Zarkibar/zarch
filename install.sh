#!/bin/bash
set -euo pipefail

DOTFILES_GIT="https://github.com/Zarkibar/dotfiles.git"
YAY_GIT="https://aur.archlinux.org/yay.git"
GHOSTMIRROR_GIT="https://aur.archlinux.org/ghostmirror.git"


sudo -v || exit 1

while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

all() {
  ./bin/update_mirrors.sh
  ./bin/install_base.sh
  ./bin/setup_desktop_environment.sh
  ./bin/personalized_packages.sh
    # SDDM theming - NOT TOUCHED
}

all
