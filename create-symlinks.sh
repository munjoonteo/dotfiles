#!/bin/sh

dotfiles_dir=~/dotfiles

rm -rf ~/.zshrc > /dev/null 2>&1
rm -rf ~/.vimrc > /dev/null 2>&1
rm -rf ~/.gitconfig > /dev/null 2>&1
rm -rf ~/.p10k.zsh > /dev/null 2>&1
rm -rf ~/.config/nvim > /dev/null 2>&1
rm -rf ~/.tmux.conf > /dev/null 2>&1

mkdir -p ~/.config/nvim

ln -sf $dotfiles_dir/.zshrc ~/.zshrc
ln -sf $dotfiles_dir/.vimrc ~/.vimrc
ln -sf $dotfiles_dir/.gitconfig ~/.gitconfig
ln -sf $dotfiles_dir/.p10k.zsh ~/.p10k.zsh
ln -sf $dotfiles_dir/init.lua ~/.config/nvim/init.lua
ln -sf $dotfiles_dir/.tmux.conf ~/.tmux.conf

