#!/bin/bash

DOTFILES=(.zshrc .tmux.conf .vimrc)

for file in ${DOTFILES[@]}
do
    ln -s $HOME/dotfiles/$file $HOME/$file
done
