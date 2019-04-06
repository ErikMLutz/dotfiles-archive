#!/bin/bash

###
# convienience methods for requiring installed software
###

function require_cask() {
    running "brew cask $1"
    brew cask list $1 > /dev/null 2>&1 | true
    if [[ $? != 0 ]]; then
		echo -en "\r"
        running "brew cask install $1 $2"
        brew cask install $1
        if [[ $? != 0 ]]; then
            error "failed to install $1! aborting..."
		else ok
        fi
	else ok
    fi
}

function require_brew() {
    running "brew $1 $2"
    brew list $1 > /dev/null 2>&1 | true
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
		echo -en "\r"
        running "brew install $1 $2"
        brew install $1 $2
        if [[ $? != 0 ]]; then
            error "failed to install $1! aborting..."
            # exit -1
        fi
    fi
    chk
}

function require_node(){
    running "node -v"
    node -v
    if [[ $? != 0 ]]; then
		echo -en "\r"
        running "node not found, installing via homebrew"
        brew install node
    fi
    chk
}

function sourceNVM(){
    export NVM_DIR=~/.nvm
    source $(brew --prefix nvm)/nvm.sh
}


function require_nvm() {
	running "nvm $1"
    mkdir -p ~/.nvm
    cp $(brew --prefix nvm)/nvm-exec ~/.nvm/
    sourceNVM
    nvm install $1 > /dev/null 2>&1
    if [[ $? != 0 ]]; then
		error "install failed, reinstalling nvm"
        require_brew nvm
        . ~/.bashrc
		running "nvm $1"
        nvm install $1
    fi
    chk
}

function require_npm() {
	sourceNVM
	nvm use stable > /dev/null
	running "npm $*"
	npm list -g --depth 0 | grep $1@ > /dev/null
	if [[ $? != 0 ]]; then
		echo -en "\r"
		running "npm install -g $*"
		npm install -g $@
	fi
	chk
}
