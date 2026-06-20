# Install
```bash
git clone --bare git@github.com:nilese1/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME reset --hard
sudo cmod +x install.sh
./install.sh
```

