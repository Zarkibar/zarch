# Zarch
zarch (zarkibar's arch) is just collection of bash scripts to setup and configure a freshly installed arch linux into my personal configuration. This is more of a post-installation program so you'll need to install arch first before you install this. This program basically just installs and setups a bunch of necessary tools for my convenience. It also copies the dotfiles for those tools from my other github repository.

# Features
It features:
- Tiling Window Manager (Hyprland or i3)
- Waybar
- Login Manager (sddm)
- Lock Screen (Hyprlock)
- Neovim with LSP, code completion, git integration and most modern features
- Rofi
- Theme Changer
- UI for package manager
- Built-in screen recording
- Beautiful terminal with Kitty and Starship
- Custom features like Screenshot, Clipboard Manager, Power Menu, Quick Menu, Window Selector
- Some more (fonts, themes, background selector, i3 tools etc)

# Installation
Assuming you've already installed arch linux on your system. Install git and clone this repository on your home directory. 

```bash
sudo pacman -S git
git clone https://github.com/Zarkibar/zarch.git

``` 

Now go to the `zarch/` directory with ```cd zarch```. Now There are 2 files `install-system.sh` and `install-user.sh`. `install-syste.sh` should be run once. It will install the necessary tools and packages into the whole system. `install-user.sh` is for each user using the system. Run `install-system.sh` first and then `install-user.sh`. If you have multiple users in your system then `install-user.sh` has to be run on each of them once to setup all the dotfiles.

```bash
./install-system.sh
./install-user.sh

```
