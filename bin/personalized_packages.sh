msg() {
    printf "\n==> %s\n" "$1"
}

install_personalized_packages() {
    msg "Installing personalized packages"
    sudo pacman -S --needed --noconfirm flatpak firefox blender mpv foliate

    flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install --system -y flathub org.processing.processingide
    flatpak install --system -y flathub org.keepassxc.KeePassXC
}
