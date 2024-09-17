#!/bin/sh

curl https://codeberg.org/segv/dotfiles/raw/branch/master/.tmux.conf -Ss > ~/.tmux.conf && \
echo "tmux configured"

wget https://github.com/mjakob-gh/build-static-tmux/releases/download/v3.3a/tmux.linux-amd64.stripped.gz -q && \
gunzip tmux.linux-amd64.stripped.gz && \
mv tmux.linux-amd64.stripped tmux && \
chmod +x tmux && \
echo "tmux saved to $PWD/tmux"