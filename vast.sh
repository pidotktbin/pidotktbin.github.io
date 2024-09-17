#!/bin/sh

curl https://codeberg.org/segv/dotfiles/raw/branch/master/.tmux.conf -Ss > ~/.tmux.conf
tmux source-file ~/.tmux.conf
apt update
apt upgrade -y
apt-get install python3-dev python3-venv python3-pip htop neovim ninja-build jq -y
apt-get install ffmpeg libsm6 libxext6  -y
pip install pipx
pipx install bpytop nvitop
ln -sf /bin/python3 /bin/python


release=$(curl -s https://api.github.com/repos/cloudflare/cloudflared/releases/latest)
deb=$(echo "$release" | jq -r '.assets[] | select(.name == "cloudflared-linux-amd64.deb") | .browser_download_url')
wget -O cloudflared-linux-amd64.deb "$deb"
dpkg -i cloudflared-linux-amd64.deb
rm cloudflared-linux-amd64.deb

release=$(curl -s https://api.github.com/repos/schollz/croc/releases/latest)
tarball=$(echo "$release" | jq -r '.assets[] | select(.name | endswith("_Linux-64bit.tar.gz")) | .browser_download_url')
wget -O croc_Linux-64bit.tar.gz "$tarball"
tar -xzf croc_Linux-64bit.tar.gz croc
mv croc /bin
rm croc_Linux-64bit.tar.gz

grep -q '~/.local/bin' ~/.bashrc || echo 'PATH="$PATH:~/.local/bin"' >> ~/.bashrc
source ~/.bashrc
