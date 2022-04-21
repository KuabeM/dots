#!/usr/bin/env zsh

src_dir=${0:a:h}

echo 'Setup config files in ~'
targets=(gdbinit gitconfig zshrc spacemacs)
for target in $targets; do
  ln -nfs $src_dir/$target $HOME/.$target
done

echo 'Setup config folders in .config'
mkdir -p $HOME/.config
folders=(alacritty htop mako piow sway waybar wofi)
for folder in $folders; do
  ln -nfs $src_dir/$folder $HOME/.config/$folder
done

# Starship is directly in ~/.config
ln -nfs $src_dir/starship.toml $HOME/.config/starship.toml
# Move nvim separately
mkdir -p $HOME/.config/nvim
ln -nfs $src_dir/nvim/init.vim $HOME/.config/nvim/init.vim
ln -nfs $src_dir/nvim/lua $HOME/.config/nvim/lua
ln -nfs $src_dir/nvim/lua $HOME/.config/nvim/spell

echo 'Install neovim plugin manager'
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo 'Install vim plugins'
nvim --headless +PlugUpgrade +PlugInstall +PlugUpdate +qall

echo 'Done!'
