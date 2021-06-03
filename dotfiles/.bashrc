#########################
# Manjaro default stuff #
#########################
#
# TODO: Put this in seperate file

# No idea what these do...
[[ $- != *i* ]] && return
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
xhost +local:root > /dev/null 2>&1
complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize
shopt -s expand_aliases

# Enable history appending instead of overwriting.  #139609
# Also make history file size bigger
shopt -s histappend
export HISTFILESIZE=1000

########################
# Start of custom part #
########################
#
# TODO: Load from external file

#############################################
# "Import" the Great Script Utility Library #
#############################################

sul="/config/utils/bin"

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

# Local scipts folders
PATH="~/bin:$PATH"

# Haskell scripts
for hs_script in $($sul/ls-hs-scripts); do
    hs_script=$(dirname $hs_script)
    PATH="$hs_script:$PATH"
done

# Emacs bin folder
PATH="~/.emacs.d/bin:$PATH"

# Programs not managed by the package manager
PATH="~/programs/bin:$PATH"

# `ghup` env
[[ -f "/home/dincio/.ghcup/env" ]] && source "/home/dincio/.ghcup/env"

# programs installed with **raku**
PATH="~/.raku/bin:$PATH"

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

# vim is for boomers
alias vim='nvim'

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

# In case of the immediate need of moral guidance.
alias real="zathura ~/books/music/the-real-book.pdf"

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

###############################################
# Modifications Appended by External Programs #
###############################################

# Add perl's CPAN to path
PATH="/home/dincio/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/dincio/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/dincio/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/dincio/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/dincio/perl5"; export PERL_MM_OPT;
