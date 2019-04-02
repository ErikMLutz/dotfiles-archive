#!/usr/bin/env bash

# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install Powerline Fonts
git clone https://github.com/powerline/fonts.git $HOME/.powerline-fonts --depth=1
cd $HOME/.powerline-fonts 
./install.sh
cd ..
rm -rf $HOME/.powerline-fonts

brew tap sambadevi/powerlevel9k
brew install powerlevel9k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
