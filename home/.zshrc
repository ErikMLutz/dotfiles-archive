# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
echo
echo "               ZSHRC               "
echo "==================================="
export DOTFILES=$HOME/.dotfiles
source $DOTFILES/utils/log.sh

zrunning "Exporting PATH"
export PATH=/usr/local/opt/grep/libexec/gnubin:$PATH
export PATH=/bin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/sbin:$PATH
export PATH=/usr/sbin:$PATH
export PATH=$DOTFILES/bin:$PATH
zchk

zrunning "Exporting PYTHONPATH"
export PYTHONPATH=~/python_packages:$PYTHONPATH
export PYTHONPATH=~/repos/dagger-airflow/plugins/dagger:$PYTHONPATH
zchk

zrunning "Sourcing FZF"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
zchk
export FZF_DEFAULT_COMMAND='fzf_search_command'

zrunning "Exporting iTerm and Zsh variables"
# Path to your oh-my-zsh installation.
export TERM="xterm-256color"
export ZSH=~/".oh-my-zsh"
zchk

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vi_mode virtualenv)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_VI_COMMAND_MODE_STRING=""

zrunning "Checking for zsh-autosuggestions"
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
	echo "Installing zsh-autosuggestions"
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	zchk
else
	zok
fi
zrunning "Checking for zsh-syntax-highlighting"
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
	echo "Installing zsh-syntaz-highlighting"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	zchk
else
	zok
fi

zrunning "Specifying plugins"
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker
  virtualenv
)
zok

zrunning "Autoloading compinit"
autoload -Uz compinit
zchk

setopt EXTENDEDGLOB
for dump in $ZSH_COMPDUMP(#qN.m1); do
	zrunning "Running compinit"
	compinit
	zchk
	if [[ -s "$dump" && (! -s "$dump.zwc" || "$dump" -nt "$dump.zwc") ]]; then
		zcompile "$dump"
	fi
done
unsetopt EXTENDEDGLOB
zrunning "Initializing completions"
compinit -C
zchk

zrunning "Sourcing oh-my-zsh"
source $ZSH/oh-my-zsh.sh
zchk

zrunning "Sourcing zsh-syntax-highlighting"
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zchk

zrunning "Sourcing custom CLI tool"
source ~/.dotfiles/utils/cli_tools.sh
zchk

zrunning "Hooking direnv"
eval "$(direnv hook zsh)"
zchk

zrunning "Creating aliases"
alias sdiff="svn diff | colordiff"
zchk

zrunning "Completing miscellaneous tasks"
bindkey -v
export KEYTIMEOUT=.1
zchk

clear
