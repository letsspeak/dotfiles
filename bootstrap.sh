#!/bin/bash

PREFIX=${PREFIX-$PWD}

git clone https://github.com/etheriqa/dotfiles.git $PREFIX/dotfiles && \
cd $PREFIX/dotfiles && \
make install PREFIX=$HOME
