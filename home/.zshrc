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

zrunning "Sourcing FZF"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
zchk
#export FZF_DEFAULT_COMMAND='ag --path-to-ignore ~/.ignore --files-with-matches'

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
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vi_mode time)
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

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#zrunning "Specifying plugins"
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker
)
zok

#echo "Autoloading compinit"
#autoload -U compinit && compinit
#zok
# Perform compinit only once a day.
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

zrunning "Sourcing custom funcs"
source ~/.dotfiles/utils/funcs.sh
zchk


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#alias ag="ag --path-to-ignore ~/.ignore --hidden --ignore-case --files-with-matches"

bindkey -v
export KEYTIMEOUT=.1

clear
