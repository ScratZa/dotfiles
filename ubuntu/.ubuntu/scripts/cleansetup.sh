LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

rm lazygit.tar.gz lazygit 

sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt-get install neovim -y

TEMP_DIR=$(mktemp -d)

sudo curl -Lo "$TEMP_DIR/CascadiaCode.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip  
unzip "$TEMP_DIR/CascadiaCode.zip" -d "$TEMP_DIR"

sudo mv "$TEMP_DIR"/*.{ttf,otf} /usr/local/share/fonts
rm -rf "$TEMP_DIR"
fc-cache -fv
