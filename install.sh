#!/usr/bin/env zsh

echo 'Setup config files in ~'
targets=(gdbinit gitconfig zshrc spacemacs)
for target in $targets; do
  ln -nfs $HOME/.dots/$target $HOME/.$target
done

echo 'Setup config folders in .config'
folders=(alacritty htop mako nvim pwio sway waybar)
for folder in $folders; do
  ln -nfs $HOME/.dots/$folder $HOME/.config/target
done

echo 'Install vim plugins'
nvim +PlugUpgrade +PlugUpdate +qall

echo 'Done!'
