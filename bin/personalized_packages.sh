#!/bin/bash
set -euo pipefail

sudo -v || exit 1
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &


msg() {
    printf "\n==> %s\n" "$1"
}

install_personalized_packages() {
    msg "Installing personalized packages"
    sudo pacman -S --needed --noconfirm flatpak firefox mpv foliate audacity

    flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install --system -y flathub org.processing.processingide
    flatpak install --system -y flathub org.keepassxc.KeePassXC
}

install_personalized_packages
