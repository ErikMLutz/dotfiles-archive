#!/bin/bash

###
# some colorized echo helpers
###

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31m"
COL_GREEN=$ESC_SEQ"32m"
COL_YELLOW=$ESC_SEQ"33m"
COL_BLUE=$ESC_SEQ"34m"
COL_MAGENTA=$ESC_SEQ"35m"
COL_CYAN=$ESC_SEQ"36m"
COL_RSP=$ESC_SEQ"5m"

function msg() {
	echo -e "\n${COL_GREEN}Dotfiles Installer$COL_RESET - "$1
}

function ok() {
	echo -e "$COL_GREEN[ok]$COL_RESET "$1
}

function running() {
	echo -en "$COL_YELLOW ⇒ $COL_RESET"$1": "
}

function action() {
	echo -e "\n$COL_YELLOW[action]:$COL_RESET\n ⇒ $1..."
}

function warn() {
	echo -e "$COL_YELLOW[warning]$COL_RESET "$1
}

function error() {
	echo -e "$COL_RED[error]$COL_RESET "$1
}

function chk() {
	if [ $? != 0 ]; then error $1; else ok; fi
}

function rsp() {
	echo -e "\n$COL_YELLOW$1$COL_RESET" 
	echo -en "${COL_RSP}:$COL_RESET"
	read -r -p " " $2
	if [ ! -z ${!2} ]; then
		echo -e ${ESC_SEQ}1A": ${!2}" 
	else
		echo -e ${ESC_SEQ}"1A\r " 
	fi
}

function zmsg() {
	echo -e "\n$fg[green]Dotfiles Installer$fg[default] - "$1
}

function zok() {
	echo -e "$fg[green][ok]$fg[default] "$1
}

function zrunning() {
	echo -en "$fg[yellow] ⇒ $fg[default]"$1": "
}

function zaction() {
	echo -e "\n$fg[yellow][action]:$fg[default]\n ⇒ $1..."
}

function zwarn() {
	echo -e "$fg[yellow][warning]$fg[default] "$1
}

function zerror() {
	echo -e "$fg[red][error]$fg[default] "$1
}

function zchk() {
	if [ $? != 0 ]; then zerror $1; else zok; fi
}

