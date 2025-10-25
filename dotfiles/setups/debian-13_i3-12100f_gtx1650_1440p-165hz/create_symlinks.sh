#!/bin/bash

# to get the parent directory of this script
# note: for now, in order to run this, you need to be in the same directory as this script
parent_dir=$(pwd)

#### create the dirs if there's any

if ! [ -d ~/.appimages ]; then
    mkdir -p ~/.appimages
fi

if ! [ -d ~/.config/i3 ]; then
    mkdir -p ~/.config/i3
fi

if ! [ -d ~/.config/i3status ]; then
    mkdir -p ~/.config/i3status
fi

if ! [ -d ~/.config/nvim ]; then
    mkdir -p ~/.config/nvim
fi

ln -s -f "$parent_dir"/tmux.conf ~/.tmux.conf &> /dev/null
ln -s -f "$parent_dir"/Xresources ~/.Xresources &> /dev/null
ln -s -f "$parent_dir"/xinitrc ~/.xinitrc &> /dev/null
ln -s -f "$parent_dir"/bashrc ~/.bashrc &> /dev/null
ln -s -f "$parent_dir"/config/nvim/init.vim ~/.config/nvim/init.vim &> /dev/null
ln -s -f "$parent_dir"/config/i3/config ~/.config/i3/config &> /dev/null
ln -s -f "$parent_dir"/config/i3status/config ~/.config/i3status/config &> /dev/null
