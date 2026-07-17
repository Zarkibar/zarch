#!/bin/bash
set -euo pipefail

DOTFILES_GIT="https://github.com/Zarkibar/dotfiles.git"

### CHECKPOINT / RESUME SYSTEM ###

STATE_DIR="$HOME/.cache/zarch-install"
STATE_FILE="$STATE_DIR/user.log"
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

if [ -f "$WM_FILE" ]; then
    windowManager=$(cat "$WM_FILE")
    msg "Using window manager from previous run: $windowManager"
else
    windowManager=$(gum choose Hyprland Sway)
    echo "$windowManager" > "$WM_FILE"
fi

### BASE ###

create_dirs() {
    cd "$HOME"
    mkdir -p Books Documents Downloads Music Projects Videos/Recording Pictures/Screenshots
}

run_stage "CREATE_DIRS" create_dirs

### BASE ###

### DESKTOP ENVIRONMENT ###

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

  if systemctl --user status &>/dev/null; then
      systemctl --user enable xdg-desktop-portal-hyprland.service || true
      systemctl --user enable xdg-desktop-portal.service || true
  else
      echo "No active user D-Bus session; skipping systemctl --user enable (services will start on next graphical login)."
  fi

  stow --restow -t "$HOME" -d "$HOME/dotfiles" backgrounds hypridle hyprland hyprlock hyprpaper kitty waybar rofi starship wleave
  stow --restow -t "$HOME" -d "$HOME/dotfiles" zarch  
}

setup_sway() {
  msg "Setting up Sway ecosystem"
  # sudo pacman -S --needed --noconfirm sway wofi waybar kitty nemo hyprshot swaync
  # sway (foot or kitty) wofi waybar swaylock swayidle mako grim slurp wl-clipboard
  # yazi fzf zoxide eza gum
}

setup_desktop_environment() {
    if [ "$windowManager" = "Hyprland" ]; then
        setup_hyprland
    else
        setup_sway
    fi
}

setup_nvim() {
  msg "Configuring neovim and it's plugins"

  stow --restow -t "$HOME" -d "$HOME/dotfiles" nvim
}

setup_terminal() {
  command -v fish | sudo tee -a /etc/shells
  chsh -s "$(command -v fish)"

  touch "$HOME/.config/fish/config.fish"
  if grep -q "starship init fish" "$HOME/.config/fish/config.fish"; then
    echo "starship already in ~/.config/fish/config.fish"
  else
    echo 'starship init fish | source' >> "$HOME/.config/fish/config.fish"
  fi

  echo "Setup done. Please reboot your computer..."
}

run_stage "INSTALL_DOTFILES" install_dotfiles
run_stage "SETUP_DESKTOP_ENVIRONMENT" setup_desktop_environment
run_stage "SETUP_NVIM" setup_nvim
run_stage "SETUP_TERMINAL" setup_terminal

### DESKTOP ENVIRONMENT ###
