msg() {
    printf "\n==> %s\n" "$1"
}

update_system() {
    msg "Updating system"
    sudo pacman -Syu --needed --noconfirm
}

install_base() {
  cd
  mkdir -p Books Documents Downloads Music Projects Videos/Recording Pictures/Screenshots

  msg "Installing base packages"
  sudo pacman -S --needed --noconfirm git stow neovim base-devel wget curl man pavucontrol wf-recorder ghostty
  sudo pacman -S --needed --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber helvum
  sudo pacman -S --needed --noconfirm xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal

  systemctl --user enable xdg-desktop-portal-hyprland.service
  systemctl --user enable xdg-desktop-portal.service

  # Instaling necessary fonts
  sudo pacman -S --needed --noconfirm ttf-font-awesome ttf-jetbrains-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji

  # Installing necessary GPU drivers
  sudo pacman -S --needed --noconfirm mesa vulkan-radeon libva-mesa-driver  # AMD
  sudo pacman -S --needed --noconfirm mesa vulkan-intel intel-media-driver  # Intel

  # Music Player
  sudo pacman -S --needed --noconfirm mpd mpc ncmpcpp
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

install_dotfiles() {
    msg "Installing dotfiles"

    if [ ! -d "$HOME/dotfiles" ]; then
	git clone "$DOTFILES_GIT" "$HOME/dotfiles"
    else
	echo "$HOME/dotfiles already exists."
    fi   
}

update_system
install_base
install_yay
install_dotfiles
