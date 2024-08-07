#!/bin/sh

curl https://codeberg.org/segv/dotfiles/raw/branch/master/.tmux.conf -Ss > ~/.tmux.conf
tmux source-file ~/.tmux.conf
apt update
apt upgrade -y
apt-get install python3-dev python3-venv python3-pip htop neovim ninja-build -y
apt-get install ffmpeg libsm6 libxext6  -y
pip install pipx
pipx install bpytop nvitop

echo 'PATH="$PATH:~/.local/bin"' >> ~/.bashrc
source ~/.bashrc
