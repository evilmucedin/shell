# $Id: .zsh,v 1.1 2007/11/07 19:51:11 denplusplus Exp $

# Shell functions
#setenv() { export $1=$2 }  # csh compatibility

setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }
stty pass8

# Set prompts
PROMPT="$(echo '%{\e[1;31m%}%m %{\e[1;34m%}%n #%{\e[1;37m%} ')"

#bindkey -v             	# vi key bindings
#bindkey -e			# emacs key bindings

bindkey ' ' 			magic-space  # also do history expansion on space
bindkey '^[[3~' 		delete-char

case $TERM in
        linux)
        bindkey "^[[2~" 	yank
        bindkey "^[[3~" 	delete-char
        bindkey "^[[5~" 	up-line-or-history
        bindkey "^[[6~" 	down-line-or-history
        bindkey "^[[1~" 	beginning-of-line
        bindkey "^[[4~" 	end-of-line
        bindkey "^[e" 		expand-cmd-path
        bindkey "^[[A" 		up-line-or-search
        bindkey "^[[B" 		down-line-or-search
        bindkey " "		magic-space
        ;;
*xterm*|(dt|k|E)term)
        bindkey "\e[3;2~"	delete-word      	# Shift-Del
        bindkey "^[[2~" 	yank
        bindkey "^[[3~" 	delete-char
        bindkey "^[[5~" 	up-line-or-history
        bindkey "^[[6~" 	down-line-or-history
        bindkey "\e[H" 		beginning-of-line
        bindkey "\e[F" 		end-of-line
        bindkey "^[e" 		expand-cmd-path		## C-e for expanding path of typed command
        bindkey "^[[A" 		up-line-or-search   	## up arrow for back-history-search
        bindkey "^[[B" 		down-line-or-search	## down arrow for fwd-history-search
        bindkey " "		magic-space 		## do history expansion on space
	bindkey "^_"		backward-delete-char
        ;;
rxvt*)
	bindkey "\e[7~"		beginning-of-line 	# Home
	bindkey "\e[8~"		end-of-line       	# End
	bindkey "\e[3$"		delete-word       	# Shift-Del
	;;
esac

    bindkey    "^[[C"		forward-char
    bindkey    "^[[D"		backward-char
    bindkey    "^[[A"		up-history
    bindkey    "^[[B"		down-history
	    
    bindkey    "^?"		backward-delete-char
    bindkey    "^H"		backward-delete-char
		    
# setup backspace correctly
#if [ -x /usr/bin/tput ]; then
	# check we're not in a dumb terminal
#	[ -n "`tput kbs 2>/dev/null`" ] && stty erase `tput kbs`
#fi

if [ -f /usr/share/mc/mc.gentoo ]; then
     . /usr/share/mc/mc.gentoo
fi

setopt histignoredups histignorespace
setopt No_Beep
unsetopt bgnice autoparamslash

autoload -U compinit promptinit
compinit
promptinit; 
#prompt gentoo
zstyle ':completion::complete:*' use-cache 1
zmodload zsh/complist
zstyle ':completion:*' menu yes select
alias ls='ls --color'
alias aterm='aterm -tr -trsb -sh 30 -fn "-*-terminus-medium-r-normal-*-*-140-*-*-c-*-koi8-r" +sb -cr yellow -fg green >& /dev/null'
alias aterm2='for i in `seq 5`;do aterm &!;done'
alias multi-aterm='multi-aterm -tr -trsb -sh 30 -font "-*-terminus-medium-r-normal-*-*-140-*-*-c-*-koi8-r" +sb -fg green'

src () {
   autoload -U zrecompile
   [ -f /etc/zsh/zshrc ] && zrecomile -p /etc/zsh/zshrc
   [ -f ~/.zshrc ] && zrecompile -p ~/.zshrc
   [ -f ~/.zshrc.zwc.old ] && rm -f ~/.zshrc.zwc.old
   [ -f ~/.zcompdump.zwc.old ] && rm -f ~/.zcompdump.zwc.old
   source ~/.zshrc
}

setopt autocd
setopt CORRECT_ALL
SPROMPT="Ошибка! Вы хотели ввести %r вместо %R? ([Y]es/[N]o/[E]dit/[A]bort) "
case $TERM in
 xterm* | rxvt)
  preexec(){print -Pn "\e]0;$0\a"}
 ;;
esac
autoload -U tetris
zle -N tetris
bindkey ^T tetris
autoload -U zcalc
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
