#########################
# Manjaro default stuff #
#########################
#
# TODO: Put this in seperate file

# No idea what these do...
[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

#alias cp="cp -i"                          # confirm before overwriting something
#alias df='df -h'                          # human-readable sizes
#alias free='free -m'                      # show sizes in MB
#alias np='nano -w PKGBUILD'
#alias more=less

xhost +local:root > /dev/null 2>&1

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
# Also make history file size bigger
shopt -s histappend
export HISTFILESIZE=1000

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

########################
# Start of custom part #
########################
#
# TODO: Load from external file

#################
# Basic options #
#################

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Vim is a good program
set -o vi

# Use <c-s> to go forward in reverse-i-search(es)
stty -ixon

###############
# Environment #
###############

export TERM="alacritty"
export BROWSER="qutebrowser"
export EDITOR="nvim"

########
# Path #
########

# The great and terrifying Super User Library
PATH="/sul:$PATH"

# Local scipts folders
PATH="~/bin:$PATH"

# # Haskell scripts
# TODO: Fix this if and when needed
# for hs_script in $(/sul/ls-hs-scripts); do
#     hs_script=$(dirname $hs_script)
#     PATH="$hs_script:$PATH"
# done

# Emacs bin folder
PATH="~/.emacs.d/bin:$PATH"

# Programs not managed by the package manager
PATH="~/programs/bin:$PATH"

# `ghup` env
[[ -f "/home/dincio/.ghcup/env" ]] && source "/home/dincio/.ghcup/env"

# programs installed with **raku**
PATH="~/.raku/bin:$PATH"

# radare2 from r2env
PATH="$HOME/.r2env/bin:$PATH"

# CTF scripts
# (From CTF rep in home folder)
PATH="$HOME/ctf/bin:$PATH"

# Neorg notes scripts
# (From notes rep in home folder)
PATH="$HOME/notes/bin:$PATH"

#########################
# Git Utility Functions #
#########################

git-rename-remote-branch(){
  if [ $# -ne 3 ]; then
    echo "Rationale : Rename a branch on the server without checking it out."
    echo "Usage     : ${FUNCNAME[0]} <remote> <old name> <new name>"
    echo "Example   : ${FUNCNAME[0]} origin master release"
    return 1 
  fi

  git push $1 $1/$2\:refs/heads/$3 :$2
}

###########
# Aliases #
###########

# Explanation (accepted answer): https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

# spawn additional terminal in same directory
alias other='alacritty &'

# cp, but with progress
alias cpp='rsync -ah --progress'

# pfetch is hard to remember
alias computer-info='neofetch'

# For when everything is dieing
alias power='acpi'

# The most important unix utility
alias cow='cowsay'

# Installing things is a recurrent endeavour
alias yfi='yay -S'
alias ysi='yay -Syu'
alias yr='yay -Rsn'
alias ys='yay -Ss'
alias yq='yay -Q'

# Color is good
alias ls='ls --color=auto'

# Always send things to X clipboard
alias clip="xclip -selection clipboard"

# Bash is tedious enough on its own
alias cx="chmod +x"

# In case of immediate need of moral guidance.
alias real="zathura ~/books/music/the-real-book.pdf"

# Copying stuff to phone internal storage
function adb-internal() {
    echo '1. Activate USB debugging throught dev settings on phone.'
    echo '2. Allow this PC to use USB debugging'
    echo '3. Copy to phone primary storage like this: adb push {} /storage/self/primary/{}'
}
function android-internal() {
    adb-internal
}

# Egocentric git clone
# function glone() {
#     rep=${1:?"Usage: glone REPOSITORY"}

#     # $2 is destination
#     if [[ -z $2 ]]; then
#         git clone --recurse-submodules "https://www.github.com/Bietola/$rep"
#     else
#         git clone --recurse-submodules "https://www.github.com/Bietola/$rep" $2
#     fi
# }

# Show public ip address
alias show-ip4="wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1"

# "Interactive SSH", to fix BS not working in alacritty
# https://github.com/alacritty/alacritty/issues/3932
alias issh="TERM=xterm-256color ssh"

# Clipboard IN SPAAAACE (space being the internet... I'm too tired to be witty)
function cl1p-put() {
    curl -H "Content-Type: text/html; charset=UTF-8" -X POST --data "$2" https://api.cl1p.net/"$1"
}
function cl1p-get() {
    curl https://api.cl1p.net/"$1"
}

# I might be personifying a bit too much
alias children='ps auxf'

########################
# Eternal bash history #
########################
# From: https://stackoverflow.com/questions/9457233/unlimited-bash-history

# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "

# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history

# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

###############################################
# Modifications Appended by External Programs #
###############################################

# Add perl's CPAN to path
PATH="/home/dincio/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/dincio/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/dincio/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/dincio/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/dincio/perl5"; export PERL_MM_OPT;

# `app-get`, a command line installer for app images
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:${HOME}/.local/bin/app"
