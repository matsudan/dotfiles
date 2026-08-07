#!/bin/bash

DOTFILES=(.vimrc)
SCRIPT_DIR=$(cd $(dirname $0);pwd)
for file in ${DOTFILES[@]}
do
    ln -nfs $SCRIPT_DIR/$file $HOME/$file
done
