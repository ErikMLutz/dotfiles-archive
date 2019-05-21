#!/bin/bash

# Get colorschemed logging functions
source ~/.dotfiles/utils/log.sh
source ~/.dotfiles/utils/funcs.sh
source ~/.dotfiles/utils/requirers.sh

echo -e "DOTFILES AUTOMATIC INSTALLATION AND SYSTEM CONFIGURATION"
echo -e "========================================================"
echo -e "This program will install a variety of software elements, change system settings, and place configuration files in appropriate locations."

################################################################
# Administrator Access
################################################################
if [[ $# -eq 0 ]] || containsElement sudo $@; then
	msg "Configuring SUDO access."

	sudo -v
	# Keep-alive: update existing sudo time stamp until the script has finished
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	# Check for existing passwordless sudo access
	grep -q 'NOPASSWD:     ALL' /etc/sudoers.d/$LOGNAME > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo "Couldn't find exisiting sudoer file."

		rsp "Configure passwordless sudo access? [y|N]" response

		if [[ $response =~ (yes|y|Y) ]];then
			if ! grep -q "#includedir /private/etc/sudoers.d" /etc/sudoers; then
				echo '#includedir /private/etc/sudoers.d' | sudo tee -a /etc/sudoers > /dev/null
			fi
			echo -e "Defaults:$LOGNAME    !requiretty\n$LOGNAME ALL=(ALL) NOPASSWD:     ALL" | sudo tee /etc/sudoers.d/$LOGNAME
			echo "Passwordless sudo access configured."
		fi
	else
		echo "Sudoer file already exists." 
	fi
fi

################################################################
# Build Tools
################################################################
if [[ $# -eq 0 ]] || containsElement tools $@; then
	msg "Installing build tools."

	running "installing xcode"
	xcode-select --install > /dev/null 2>&1 
	sudo xcode-select -s /Library/Developer/CommandLineTools > /dev/null 2>&1 
	ok

	running "installing homebrew"
	brew_bin=$(which brew) > /dev/null 2>&1 
	if [[ $? != 0 ]]; then
		action "installing homebrew"
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		if [[ $? != 0 ]]; then
			error "homebrew install failed. aborting script $0."
			exit
		fi
	else
		ok
		rsp "run brew update & upgrade? [y|N]" response
		if [[ $response =~ (y|yes|Y) ]]; then
			running "updating homebrew"
			brew update > /dev/null
			chk
			running "upgrading brew packages"
			brew upgrade > /dev/null
			chk
		else
			ok "skipped brew package upgrades.\n"
		fi
	fi

	running "installing brew-cask"
	output=$(brew tap | grep cask)
	if [[ $? != 0 ]]; then
		action "installing brew-cask"
		require_brew caskroom/cask/brew-cask
	fi
	brew tap caskroom/versions > /dev/null 2>&1
	chk
fi

################################################################
# Program Installations
################################################################
if [[ $# -eq 0 ]] || containsElement packages $@; then
	msg "Installing programs and utilities"

	brew_packages=(
	cmake
	fzf
	git
	grep
	node
	nvim
	nvm
	pandoc
	python
	task
	the_silver_searcher
	tmux
	vim
	wget
	zsh
	)

	for pkg in "${brew_packages[@]}"; do require_brew $pkg; done

	cask_packages=(
	iterm2
	)

	for pkg in "${cask_packages[@]}"; do require_cask $pkg; done

	nvm_packages=(
	stable
	)

	for pkg in "${nvm_packages[@]}"; do require_nvm $pkg; done


	npm config set save-exact true

	npm_packages=(
	instant-markdown-d  
	)

	for pkg in "${npm_packages[@]}"; do require_npm $pkg; done

	running "running homebrew cleanup"
	brew cleanup --force > /dev/null 2>&1
	rm -f -r /Library/Caches/Homebrew/* > /dev/null 2>&1
	chk

# Install Oh-My-Zsh
running "installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" > /dev/null
chk

# Running fzf installation
running "completing fzf installation"
/usr/local/opt/fzf/install --all --no-fish > /dev/null 2>&1
chk

# Install Karabiner-Elements for mapping the Caps Lock Key
running "installing karabiner"
if [[ ! -d /Applications/Karabiner-Elements.app ]]; then
	git clone --depth 1 https://github.com/tekezo/Karabiner-Elements.git ~/.karabiner > /dev/null 2>&1
	pushd ~/.karabiner > /dev/null 2>&1
	make package  > /dev/null 
	chk
	popd > /dev/null 2>&1
else ok
fi
fi

################################################################
# Git Configuration
################################################################
if [[ $# -eq 0 ]] || containsElement git $@; then
	msg "Configuring Git."

	git config --global core.editor nvim

	defaultName=$( git config --global user.name )
	defaultEmail=$( git config --global user.email )
	defaultGithub=$( git config --global github.user )

	echo -e "Current configuration:\n  Name: $defaultName\n  Email: $defaultEmail\n  GitHub Username: $defaultGithub"

	rsp "Do you wish to modify this configuration? [y|N]" response

	if [[ $response =~ (y|yes|Y) ]]; then
		rsp "Name [$defaultName]:" name
		rsp "Email [$defaultEmail]:" email 
		rsp "Github username [$defaultGithub]:" github

		git config --global user.name "${name:-$defaultName}"
		git config --global user.email "${email:-$defaultEmail}"
		git config --global github.user "${github:-$defaultGithub}"

		if [[ "$( uname )" == "Darwin" ]]; then
			git config --global credential.helper "osxkeychain"
		else
			rsp "Save user and password to an unencrypted file to avoid writing? [y|N]" save
			if [[ $save =~ ^([Yy])$ ]]; then
				git config --global credential.helper "store"
			else
				git config --global credential.helper "cache --timeout 3600"
			fi
		fi
	fi
fi

################################################################
# Shell Configuration
################################################################
if [[ $# -eq 0 ]] || containsElement shell $@; then
	msg "Configuring Shell."

	running "setting '/usr/local/bin/zsh' as your shell"
	CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
	if [[ "$CURRENTSHELL" != "/usr/local/bin/zsh" ]]; then
		sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/zsh > /dev/null 2>&1
	fi
	chk

	running "installing powerlevel10k theme"
	if [[ ! -d ~/".oh-my-zsh/custom/themes/powerlevel10k" ]]; then
		git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
	fi
	chk
fi

################################################################
# Dotfile Symlinks
################################################################
if [[ $# -eq 0 ]] || containsElement links $@; then
	msg "Creating dotfile symlinks."

	rsp "Do you wish to backup existing dotfiles? [Y|n]" backup_dotfiles
	echo

	pushd ~/.dotfiles/home > /dev/null 2>&1
	now=$(date +"%Y.%m.%d.%H.%M.%S")

	IFS=$'\n' # make newlines the only separator so that Application Support doesn't get split
	for obj in $(find . -type f | sed -e "s/^\.\///g"); do

		running "~/$obj"

	# create directory if necessary
	mkdir -p ~/"$(dirname $obj)"

	# if the file exists:
	if [[ -e ~/"$obj" ]] && [[ ! $backup_dotfiles =~ (n|no|N) ]] ; then
		mkdir -p ~/.dotfiles_backup/$now/$(dirname "$obj")
		mv ~/"$obj" ~/.dotfiles_backup/$now/"$obj"
		echo -n "backup saved at ~/.dotfiles_backup/$now/$obj, "
	fi

	# symlink might still exist
	unlink ~/"$obj" > /dev/null 2>&1

	# create the link
	ln -s ~/.dotfiles/home/"$obj" ~/"$obj"
	echo -en "link created. ";chk
done

unset IFS
popd > /dev/null 2>&1
fi

################################################################
# VIM/NeoVIM Setup
################################################################
if [[ $# -eq 0 ]] || containsElement vim $@; then
	msg "Configuring Vim and NeoVim"

	rsp "Install Vim plugins now? [y|N]" response
	if [[ $response =~ (y|yes|Y) ]]; then
		if [[ ! -e ~/.vim/autoload/plug.vim ]]; then 
			running "installing vim-plug"
			curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
				https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null 2>&1 
							chk
						fi
						running "installing vim plugins"
						vim +PluginInstall +qall > /dev/null 2>&1
						chk
						running "installing neovim plugins"
						nvim -c "PlugInstall | qa" > /dev/null 2>&1
						chk
						running "installing OmniSharp"
						nvim -c "set ft=cs | OmniSharpInstall | qa" > /dev/null 2>&1
						chk
					fi
				fi

################################################################
# iTerm Setup
################################################################
if [[ $# -eq 0 ]] || containsElement iterm $@; then
	msg "Configuring iTerm2"

	rsp "Install fonts? [y|N] " response
	if [[ $response =~ (y|yes|Y) ]];then
		# need fontconfig to install/build fonts
		require_brew fontconfig
		./fonts/install.sh
		brew tap caskroom/fonts
		require_cask font-fontawesome
		require_cask font-awesome-terminal-fonts
		require_cask font-hack
		require_cask font-inconsolata-dz-for-powerline
		require_cask font-inconsolata-g-for-powerline
		require_cask font-inconsolata-for-powerline
		require_cask font-roboto-mono
		require_cask font-roboto-mono-for-powerline
		require_cask font-source-code-pro
		ok
	fi

	running "loading cutom iTerm2 settings"
	# Specify the preferences directory
	defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/.dotfiles/misc/iterm2_profiles/"
	# Tell iTerm2 to use the custom preferences in the directory
	defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
	chk
fi

echo
echo
msg "Configuration Complete. You may need to restart Terminal/iTerm2 for all changes to take effect."
