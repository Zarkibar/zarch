#!/bin/bash
set -euo pipefail

sudo -v || exit 1
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

sudo pacman -S --needed --noconfirm gum
windowManager=$(gum choose Hyprland KDE-Plasma)

msg() {
    printf "\n==> %s\n" "$1"
}

setup_hyprland() {
  msg "Setting up hyprland ecosystem"

  sudo pacman -S --needed --noconfirm hyprland rofi waybar kitty nemo hyprshot swaync hyprlock hypridle hyprpaper starship
  yay -S --noconfirm --needed wleave clipse
 
  sudo pacman -S --needed --noconfirm xdg-desktop-portal-hyprland

  # GTK
  sudo pacman -S --needed --noconfirm nwg-look adw-gtk-theme
}

setup_sway() {
  msg "Setting up Sway ecosystem"

  # sudo pacman -S --needed --noconfirm sway rofi waybar kitty nemo hyprshot swaync
  # sway (foot or kitty) wofi waybar swaylock swayidle mako grim slurp wl-clipboard
  # yazi fzf zoxide eza gum
}

setup_kde() {
  sudo pacman -S --needed --noconfirm plasma plasma-wayland-session kde-applications
}

setup_sddm() {
  sudo pacman -S --needed --noconfirm sddm
  sudo systemctl enable sddm.service
}

setup_nvim() {
    msg "Configuring neovim and it's plugins"

    sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim tree-sitter-cli npm
}

if [ "$windowManager" = "Hyprland" ]; then
  setup_hyprland
else
  setup_kde
fi

setup_nvim
