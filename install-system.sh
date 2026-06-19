#!/bin/bash
set -euo pipefail

GHOSTMIRROR_GIT="https://aur.archlinux.org/ghostmirror.git"
YAY_GIT="https://aur.archlinux.org/yay.git"

### CHECKPOINT / RESUME SYSTEM ###

STATE_DIR="$HOME/.cache/zarch-install"
STATE_FILE="$STATE_DIR/system.log"
WM_FILE="$STATE_DIR/window_manager"
mkdir -p "$STATE_DIR"
touch "$STATE_FILE"

is_done() {
    # usage: is_done STAGE_NAME
    grep -qx "$1" "$STATE_FILE"
}

mark_done() {
    # usage: mark_done STAGE_NAME
    echo "$1" >> "$STATE_FILE"
}

run_stage() {
    # usage: run_stage STAGE_NAME function_to_run
    local stage="$1"
    local fn="$2"
    if is_done "$stage"; then
        msg "Skipping '$stage' (already completed). Delete its line from $STATE_FILE to redo."
        return 0
    fi
    "$fn"
    mark_done "$stage"
}

### CHECKPOINT / RESUME SYSTEM ###

msg() {
    printf "\n==> %s\n" "$1"
}

sudo pacman -S --needed --noconfirm gum
windowManager=$(gum choose Hyprland Sway)
echo "$windowManager" > "$WM_FILE"

sudo -v || exit 1
while true; do
    sleep 60
    sudo -n true
    kill -0 "$$" || exit
done 2>/dev/null &

### UPDATE MIRRORS ###

update_mirrors() {
  msg "Installing and reorganizing mirrors for pacman"

  sudo pacman -S --needed --noconfirm base-devel

  if pacman -Q ghostmirror &>/dev/null; then
	  echo "ghostmirror installed"
  else
	  if [ ! -d "$HOME/ghostmirror" ]; then
	    git clone "$GHOSTMIRROR_GIT" "$HOME/ghostmirror"
  	else
	    echo "ghostmirror git file already exists."
  	fi

	  cd ~/ghostmirror/
    makepkg -s --noconfirm
    sudo pacman -U --noconfirm ./*.pkg.tar.zst
    cd
	  rm -rf ~/ghostmirror/
  fi

  COUNTRIES="Bangladesh,India,Singapore,Malaysia,Thailand,Indonesia"
  ghostmirror -Po -c "$COUNTRIES" -l ~/mirrorlist.new -L 30 -S state,outofdate,morerecent,ping
  ghostmirror -Po -mu ~/mirrorlist.new -l ~/mirrorlist.new.tmp -s light -S state,outofdate,morerecent,estimated,speed
  mv ~/mirrorlist.new.tmp ~/mirrorlist.new
  sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
  sudo mv ~/mirrorlist.new /etc/pacman.d/mirrorlist
  echo "mirrors updated."
}

run_stage "UPDATE_MIRRORS" update_mirrors

### UPDATE MIRRORS ###

### INSTALL BASE ###

update_system() {
    msg "Updating system"
    sudo pacman -Syu --noconfirm
}

install_base() {
  msg "Installing base packages"
  sudo pacman -S --needed --noconfirm base-devel git stow neovim base-devel wget curl man pavucontrol wf-recorder fzf playerctl jq
  sudo pacman -S --needed --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber helvum
  sudo pacman -S --needed --noconfirm xdg-desktop-portal-gtk xdg-desktop-portal

  # Installing necessary fonts
  sudo pacman -S --needed --noconfirm ttf-font-awesome ttf-jetbrains-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji

  # Installing necessary GPU drivers
  sudo pacman -S --needed --noconfirm mesa vulkan-radeon libva-mesa-driver  # AMD
  sudo pacman -S --needed --noconfirm mesa vulkan-intel intel-media-driver  # Intel

  # Music Player
  #sudo pacman -S --needed --noconfirm mpd mpc ncmpcpp
}

install_yay() {
  msg "Installing yay"
  cd "$HOME"
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

run_stage "UPDATE_SYSTEM" update_system
run_stage "INSTALL_BASE" install_base
run_stage "INSTALL_YAY" install_yay

### INSTALL BASE ###

### DESKTOP ENVIRONMENT ###

setup_hyprland() {
  msg "Setting up hyprland ecosystem"

  sudo pacman -S --needed --noconfirm hyprland rofi rofi-emoji waybar kitty nemo hyprshot swaync hyprlock hypridle hyprpaper starship wl-clipboard
  yay -S --noconfirm --needed clipse

  sudo pacman -S --needed --noconfirm xdg-desktop-portal-hyprland

  # GTK
  sudo pacman -S --needed --noconfirm nwg-look adw-gtk-theme
}

setup_sway() {
  msg "Setting up Sway ecosystem"

  # sudo pacman -S --needed --noconfirm sway rofi waybar kitty nemo hyprshot swaync
  # sway (foot or kitty) wofi waybar swaylock swayidle mako grim slurp wl-clipboard
  # yazi fzf zoxide eza gum

  sudo pacman -S --needed --noconfirm sway swaybg swayidle swaylock swaync waybar rofi kitty xorg-xwayland wl-clipboard polkit-gnome xdg-desktop-portal-wlr
}

setup_nvim() {
    msg "Configuring neovim and it's plugins"

    sudo pacman -S --noconfirm --needed gcc make git ripgrep fd unzip neovim tree-sitter-cli npm
}

setup_desktop_environment() {
    if [ "$windowManager" = "Hyprland" ]; then
        setup_hyprland
    else
        setup_sway
    fi
}

run_stage "SETUP_DESKTOP_ENVIRONMENT" setup_desktop_environment
run_stage "SETUP_NVIM" setup_nvim

### DESKTOP ENVIRONMENT ###

### PERSONALIZED PACKAGES ###

install_personalized_packages() {
    msg "Installing personalized packages"
    sudo pacman -S --needed --noconfirm flatpak firefox mpv foliate audacity

    flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install --system -y flathub org.processing.processingide
    flatpak install --system -y flathub org.keepassxc.KeePassXC
}

run_stage "INSTALL_PERSONALIZED_PACKAGES" install_personalized_packages

### PERSONALIZED PACKAGES ###

### LOGIN MANAGER ###



### LOGIN MANAGER ###
