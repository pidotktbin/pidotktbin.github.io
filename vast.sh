#!/bin/sh

curl https://codeberg.org/segv/dotfiles/raw/branch/master/.tmux.conf -Ss > ~/.tmux.conf
tmux source-file ~/.tmux.conf
apt update
apt upgrade -y
apt-get install python3-dev python3-venv python3-pip htop neovim ninja-build jq -y
apt-get install ffmpeg libsm6 libxext6  -y
pip install pipx
pipx install bpytop nvitop

release=$(curl -s https://api.github.com/repos/cloudflare/cloudflared/releases/latest)
deb=$(echo "$release" | jq -r '.assets[] | select(.name == "cloudflared-linux-amd64.deb") | .browser_download_url')
wget -O cloudflared-linux-amd64.deb "$deb"
sudo dpkg -i cloudflared-linux-amd64.deb
rm cloudflared-linux-amd64.deb

grep -q '~/.local/bin' && echo 'PATH="$PATH:~/.local/bin"' >> ~/.bashrc
source ~/.bashrc
