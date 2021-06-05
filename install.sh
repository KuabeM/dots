#!/usr/bin/env zsh

echo 'Setup config files in ~'
targets=(gdbinit gitconfig zshrc spacemacs)
for target in $targets; do
  ln -nfs $HOME/.dots/$target $HOME/.$target
done

echo 'Setup config folders in .config'
folders=(alacritty htop mako piow sway waybar)
for folder in $folders; do
  ln -nfs $HOME/.dots/$folder $HOME/.config/$folder
done

# Starship is directly in ~/.config
ln -nfs $HOME/.dots/starship.toml $HOME/.config/starship.toml
# Move nvim separately
ln -nfs $HOME/.dots/nvim/init.vim $HOME/.config/nvim/init.vim

echo 'Install vim plugins'
nvim +PlugUpgrade +PlugUpdate +qall

echo 'Done!'
