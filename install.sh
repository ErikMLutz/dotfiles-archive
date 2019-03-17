#!/bin/bash



# Create symbolic links to dotfiles
source link.sh

# Configure Git global variables
source git.sh

echo -e "\\n\\nInitializing Git submodule(s)"
echo "=============================="
git submodule update --init --recursive







# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew cask install iterm2

# brew install zsh zsh-completions tmux vim the_silver_searcher

# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# git clone https://github.com/powerline/fonts.git --depth=1
# cd fonts
# ./install.sh
# cd ..
# rm -rf fonts
