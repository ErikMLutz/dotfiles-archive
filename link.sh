#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

echo -e "\\n\\nCreating symlinks"
echo "=============================="

linkables=$( find -H $DOTFILES -name '*.symlink'  )
for file in $linkables ; do
	target="$HOME/.$( basename "$file" '.symlink' )"
	if [ -e "$target" ]; then
		echo "~${target#HOME} already exists. Link skipped."
	else
		echo "Creating symlink for $file"
		ln -s "$file" "$target"
	fi
done

