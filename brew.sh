#!/usr/bin/env bash

# Install Homebrew if necessary
if test ! "$( command -v brew )"; then
	echo -e "\\n\\nInstalling homebrew packages..."
	echo "=============================="
    ruby -e "$( curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install )"
fi

# Install Hombrew packages
echo -e "\\n\\nInstalling homebrew packages..."
echo "=============================="

formulas=(
    fzf
    git
    'grep --with-default-names'
    python
    the_silver_searcher
    tmux
    wget
    vim
    zsh
	zsh-completions 
	cmake
	node
	nvim
	pandoc
)

cask_formulas=(
    iterm2
)

for formula in "${formulas[@]}"; do
    formula_name=$( echo "$formula" | awk '{print $1}' )
    if brew list "$formula_name" > /dev/null 2>&1; then
        echo "$formula_name already installed. Skipping."
    else
        brew install "$formula"
    fi
done

for formula in "${cask_formulas[@]}"; do
    formula_name=$( echo "$formula" | awk '{print $1}' )
    if brew cask list "$formula_name" > /dev/null 2>&1; then
        echo "$formula_name already installed. Skipping."
    else
        brew cask install "$formula"
    fi
done


# After the install, setup fzf
echo -e "\\n\\nRunning fzf install script."
echo "=============================="
/usr/local/opt/fzf/install --all --no-bash --no-fish

# Change the default shell to zsh
zsh_path="$( command -v zsh )"
if ! grep "$zsh_path" /etc/shells; then
    echo "adding $zsh_path to /etc/shells"
    echo "$zsh_path" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$zsh_path" ]]; then
    chsh -s "$zsh_path"
    echo "default shell changed to $zsh_path"
fi


# Install Karabiner-Elements for mapping the Caps Lock Key
# git clone --depth 1 https://github.com/tekezo/Karabiner-Elements.git $HOME/.karabiner

# cd $HOME/.karabiner
# make package
