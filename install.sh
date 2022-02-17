#!/usr/bin/env zsh

echo 'Setup config files in ~'
targets=(gdbinit gitconfig zshrc spacemacs)
for target in $targets; do
  ln -nfs $HOME/.dots/$target $HOME/.$target
done

echo 'Setup config folders in .config'
mkdir -p $HOME/.config
folders=(alacritty htop mako piow sway waybar wofi)
for folder in $folders; do
  ln -nfs $HOME/.dots/$folder $HOME/.config/$folder
done

# Starship is directly in ~/.config
ln -nfs $HOME/.dots/starship.toml $HOME/.config/starship.toml
# Move nvim separately
mkdir -p $HOME/.config/nvim
ln -nfs $HOME/.dots/nvim/init.vim $HOME/.config/nvim/init.vim

echo 'Install neovim plugin manager'
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo 'Install vim plugins'
nvim --headless +PlugUpgrade +PlugInstall +PlugUpdate +qall

echo 'Done!'
