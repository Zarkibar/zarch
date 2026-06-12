#!/bin/bash
set -euo pipefail

YAY_GIT="https://aur.archlinux.org/yay.git"

sudo -v || exit 1
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

msg() {
    printf "\n==> %s\n" "$1"
}

update_system() {
    msg "Updating system"
    sudo pacman -Syu --noconfirm
}

install_base() {
  msg "Installing base packages"
  sudo pacman -S --needed --noconfirm - < packages.txt
}

install_yay() {
  msg "Installing yay"
  cd
  if [ ! -d "$HOME/yay" ]; then
	  git clone "$YAY_GIT" "$HOME/yay"
  else
	  echo "yay git file already exists."
  fi

  if test "$(command -v yay)" = "/usr/bin/yay"; then
	  echo "yay already exists."
  else
	  cd ~/yay
	  makepkg -si --noconfirm
	  cd ..
  fi

  rm -rf ~/yay
}


update_system
install_base
install_yay

