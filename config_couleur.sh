echo " 
#############################################################
### Modification des couleurs de l'interfaces du terminal ###
### avec le script config_couleur.sh par Thomas SAVIO     ###
#############################################################
"
echo '
# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, dont do anything
[ -z "$PS1" ] && return' > /etc/bash.bashrc

echo "
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
" >>/etc/bash.bashrc
echo '
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
' >> /etc/bash.bashrc
echo "
# set a fancy prompt (non-color, overwrite the one in /etc/profile)
# PS1=${debian_chroot:+($debian_chroot)}\u@\h:\w\$ 

# Commented out, dont overwrite xterm -T 'title' -n 'icontitle' by default.
# If this is an xterm set the title to user@host:dir
#case '$TERM' in
#xterm*|rxvt*)
#    PROMPT_COMMAND=echo -ne '\033]0;${USER}@${HOSTNAME}: ${PWD}\007'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi
" >> /etc/bash.bashrc

echo ' 
# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f couldve been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/bin/python /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/bin/python /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi
COLOR_RED="\[\e[31;40m\]"
COLOR_GREEN="\[\e[32;40m\]"
COLOR_YELLOW="\[\e[33;40m\]"
COLOR_BLUE="\[\e[34;40m\]"
COLOR_MAGENTA="\[\e[35;40m\]"
COLOR_CYAN="\[\e[36;40m\]"

COLOR_RED_BOLD="\[\e[31;1m\]"
COLOR_GREEN_BOLD="\[\e[32;1m\]"
COLOR_YELLOW_BOLD="\[\e[33;1m\]"
COLOR_BLUE_BOLD="\[\e[34;1m\]"
COLOR_MAGENTA_BOLD="\[\e[35;1m\]"
COLOR_CYAN_BOLD="\[\e[36;1m\]"

COLOR_NONE="\[\e[0m\]"
COLOR_NONE_BOLD="\[\e[1m\]"

PS1=""

if test `whoami` != "root"
then
    PS1="${PS1}${COLOR_GREEN_BOLD}\u@\h ${COLOR_BLUE_BOLD}\w "
else
    PS1="${PS1}${COLOR_RED_BOLD}\h ${COLOR_GREEN_BOLD}\W "
fi
' >> /etc/bash.bashrc

read -p "La machine va redémarrer pour prendre en compte la couleur du terminal 
Pour modifier la couleur, il faut aller dans /etc/bash.bashrc
Taper sur n'importe quel touche pour continuer " prout
reboot
