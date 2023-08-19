#!/bin/bash

DOTFILES=(.zshrc .vimrc)
SCRIPT_DIR=$(cd $(dirname $0);pwd)
for file in ${DOTFILES[@]}
do
    ln -s $SCRIPT_DIR/$file $HOME/$file
done
