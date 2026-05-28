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

setup_hyprland() {
    msg "Setting up hyprland ecosystem"

    sudo pacman -S --needed --noconfirm hyprland wofi waybar kitty nemo hyprshot swaync hyprlock hypridle hyprpaper starship
    yay -S --noconfirm --needed wleave clipse

    stow --restow -t "$HOME" -d "$HOME/dotfiles" backgrounds hypridle hyprland hyprlock hyprpaper kitty waybar wofi starship wleave

    if grep "starship init bash" ~/.bashrc; then
      echo "starship already in ~/.bashrc"
    else
        echo 'eval "$(starship init bash)"' >> ~/.bashrc
    fi

    # GTK
    sudo pacman -S --needed --noconfirm nwg-look
    yay -S --needed --noconfirm colloid-gtk-theme
}

setup_nvim() {
    msg "Configuring neovim and it's plugins"

    sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim tree-sitter-cli npm

    stow --restow -t "$HOME" -d "$HOME/dotfiles" nvim
}

setup_zarch() {
  msg "Setting up zarch"

  stow --restow -t "$HOME" -d "$HOME/dotfiles" zarch
}

setup_hyprland
setup_nvim
setup_zarch
