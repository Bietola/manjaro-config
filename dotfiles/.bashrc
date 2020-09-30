#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

#################
# Basic options #
#################

# Vim is a good program
set -o vi

# Use <c-s> to go forward in reverse-i-search(es)
stty -ixon

###########
# Aliases #
###########

# Explanation (accepted answer): https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

# cp, but with progress
alias cpp='rsync -ah --progress'

# pfetch is hard to remember...
alias computer-info='neofetch'

# For when everything is dieing
alias power='acpi'

# Installing things is a recurrent endeavour...
alias fi='yay -S'
alias si='yay -Syu'
alias r='yay -Rsn'
alias s='yay -Ss'
alias q='yay -Q'

# Always send things to X clipboard
alias xclip="xclip -selection clipboard"

# Bash is tedious enough on its own
alias cx="chmod +x"

# In case of the immediate need of moral guidance.
alias real="zathura ~/books/music/the-real-book.pdf"

# Egocentric git clone
function glone() {
    rep=${1:?"Usage: glone REPOSITORY"}

    git clone "https://www.github.com/Bietola/$rep"
}

# Show public ip address
alias show-ip4="wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1"
