#!/bin/bash
sudo apt install -y i3 lightdm firefox-esr git starship vim flatpak snap gcc python3 pipx xclip compton feh imagemagick libx11-dev libxft-dev fastfetch tree-sitter-cli ripgrep

# wallpapers
pipx install pywal16

# rust
if [ ! -d "$HOME/.cargo" ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# nvim stuff (pacstall for latest ver)
if [ ! -f "/usr/bin/pacstall" ]; then
	sudo bash -c "$(wget -q https://pacstall.dev/q/install -O -)"
fi

if [ ! -f "/usr/bin/nvim" ]; then
	pacstall -I neovim
fi

# fonts
if [ ! -d "$HOME/.local/share/fonts"]; then
	mkdir -p ~/.local/share/fonts
fi

FONTS=("CascadiaMono" "CascadiaCode" "Noto")
for font in "${FONTS[@]}"; do
	if [ ! -d "$HOME/.local/share/fonts/$font/" ]; then
		wget -P "$HOME/.local/share/fonts/$font/" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/$font.zip"
		cd "$HOME/.local/share/fonts/$font"
		unzip "$font.zip"
		rm  -rf "$font.zip"
		cd
	fi
done

# tabbed
cd ~/.config/tabbed
sudo make clean
sudo make install
cd

# add custom scripts to path
cd ~/.config/scripts/
sudo chmod +x ./configure-path.sh
sudo ./configure-path.sh
