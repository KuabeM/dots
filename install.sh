#!/usr/bin/env zsh

src_dir=${0:a:h}

echo 'Setup config files in ~'
targets=(gdbinit gitconfig)
for target in $targets; do
  ln -nfs $src_dir/$target $HOME/.$target
done

echo 'Setup config folders in .config'
mkdir -p $HOME/.config
folders=(alacritty htop mako piow sway waybar yofi kitty swappy)
for folder in $folders; do
  ln -nfs $src_dir/$folder $HOME/.config/$folder
done

# Starship is directly in ~/.config
ln -nfs $src_dir/starship.toml $HOME/.config/starship.toml
# fish only allows config.fish
mkdir -p $HOME/.config/fish
ln -nfs $src_dir/fish/config.fish $HOME/.config/fish/config.fish
# Move nvim separately
mkdir -p $HOME/.config/nvim
ln -nfs $src_dir/nvim/init.lua $HOME/.config/nvim/init.lua
ln -nfs $src_dir/nvim/lua $HOME/.config/nvim/lua
ln -nfs $src_dir/nvim/lua $HOME/.config/nvim/spell

echo 'Install neovim plugin manager'
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
sh -c 'git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim'
echo 'Install vim plugins'
nvim --headless +PlugUpgrade +PlugInstall +PlugUpdate +PackerInstall +PackerUpdate +qall

echo 'Add git templates'
git config --global init.templatedir $src_dir/git-templates

echo 'Done!'
