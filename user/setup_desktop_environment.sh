#!/bin/bash
set -euo pipefail

DOTFILES_GIT="https://github.com/Zarkibar/dotfiles.git"

sudo -v || exit 1
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

sudo pacman -S --needed --noconfirm gum
windowManager=$(gum choose Hyprland Sway)

msg() {
    printf "\n==> %s\n" "$1"
}

install_dotfiles() {
  msg "Installing dotfiles"

  if [ ! -d "$HOME/dotfiles" ]; then
	  git clone "$DOTFILES_GIT" "$HOME/dotfiles"
  else
	  echo "$HOME/dotfiles already exists."
  fi   
}

setup_hyprland() {
  msg "Setting up hyprland ecosystem"

  stow --restow -t "$HOME" -d "$HOME/dotfiles" backgrounds hypridle hyprland hyprlock hyprpaper kitty waybar rofi starship wleave
  stow --restow -t "$HOME" -d "$HOME/dotfiles" zarch

  if grep "starship init bash" ~/.bashrc; then
    echo "starship already in ~/.bashrc"
  else
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
  fi
}

setup_sway() {
  msg "Setting up Sway ecosystem"

  # sudo pacman -S --needed --noconfirm sway wofi waybar kitty nemo hyprshot swaync
  # sway (foot or kitty) wofi waybar swaylock swayidle mako grim slurp wl-clipboard
  # yazi fzf zoxide eza gum
}

setup_i3() {
  msg "Setting up i3 desktop environment"

  # hyprland -> i3, waybar -> polybar OR i3bar, wofi -> rofi, hyprlock -> i3lock-color
  # hypridle -> xautolock, swaync -> dunst, hyprpaper -> feh OR nitrogen, hyprshot -> flameshot
  # clipse -> greenclip, wl-clipboard -> xclip, wleave -> rofi power menu
  
  # sudo pacman -S i3-wm i3status rofi dunst picom feh \
  # kitty nemo flameshot xclip playerctl brightnessctl \
  # network-manager-applet polkit-gnome
  # yay -S i3lock-color greenclip
  # sudo pacman -S polybar

  stow --restow -t "$HOME" -d "$HOME/dotfiles" backgrounds kitty i3 i3status dunst polybar rofi
}

setup_nvim() {
  msg "Configuring neovim and it's plugins"
  
  stow --restow -t "$HOME" -d "$HOME/dotfiles" nvim
}

install_dotfiles

if [ "$windowManager" = "Hyprland" ]; then
  setup_hyprland
else
  setup_sway
fi

setup_i3
setup_nvim
