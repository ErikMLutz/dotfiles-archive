#!/bin/bash

# Download any Git submodules
echo -e "\\n\\nInitializing Git submodule(s)"
echo "=============================="
git submodule update --init --recursive

# Create symbolic links to dotfiles
source link.sh

# Configure Git global variables
source git.sh

# only perform macOS-specific install
if [ "$(uname)" == "Darwin" ]; then
    echo -e "\\n\\nRunning on macOS"

    source brew.sh

fi

# npm -g install instant-markdown-d
