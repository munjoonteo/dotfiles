#!/bin/sh

dotfiles_dir=~/dotfiles

sudo rm -rf ~/.zshrc > /dev/null 2>&1
sudo rm -rf ~/.gitconfig > /dev/null 2>&1
sudo rm -rf ~/.p10k.zsh > /dev/null 2>&1
sudo rm -rf ~/.vimrc > /dev/null 2>&1
sudo rm -rf ~/.config/coc/extensions/package.json > /dev/null 2>&1
sudo rm -rf ~/.vim/coc-settings.json > /dev/null 2>&1

mkdir -p ./config/coc/extensions
mkdir ~/.vim

ln -sf $dotfiles_dir/.zshrc ~/.zshrc
ln -sf $dotfiles_dir/.gitconfig ~/.gitconfig
ln -sf $dotfiles_dir/.p10k.zsh ~/.p10k.zsh
ln -sf $dotfiles_dir/.vimrc ~/.vimrc
ln -sf $dotfiles_dir/package.json ~/.config/coc/extensions/package.json
ln -sf $dotfiles_dir/coc-settings.json ~/.vim/coc-settings.json

