GHOSTMIRROR_GIT="https://aur.archlinux.org/ghostmirror.git"

msg() {
    printf "\n==> %s\n" "$1"
}

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
  ghostmirror -Po -mu ~/mirrorlist.new -l ~/mirrorlist.new -s light -S state,outofdate,morerecent,estimated,speed
  sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
  sudo mv ~/mirrorlist.new /etc/pacman.d/mirrorlist
  echo "mirrors updated."
}

update_mirrors
