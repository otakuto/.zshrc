export PS1='%F{yellow}%n%f@%F{magenta}%m%f:%F{cyan}%d%f%(!.#.$)'
export WORDCHARS='*?_-[]~=&;!#$%^(){}<>.'
export HISTFILE=~/.zsh/.zsh_history
export HISTSIZE=65536
export SAVEHIST=65536
export LESSHISTFILE=-
export EDITOR=vim

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias l='ls -halF --time-style=long-iso'
alias v=vim
alias ext=extract
alias clang='clang -std=c11 -Wall'
alias clang++='clang++ -std=c++1z -stdlib=libc++ -Wall'

alias gst='git status'
alias gp='git push'
alias gca='git commit -a -m'
alias gca!='git commit -a --amend -m'
alias ga='git add'
alias gd='git diff'

alias agg='ag -g'

alias -s c='(){out=${1:h}/a.out && clang $1 -o $out && shift && $out $@}'
alias -s cpp='(){out=${1:h}/a.out && clang++ $1 -o $out && shift && $out $@}'
alias -s py=python
alias -s hs=runhaskell

zmodload zsh/complist

autoload -U compinit && compinit -d ~/.zsh/.zcompdump
autoload -U colors && colors
autoload history-search-end

zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors '${LS_COLORS}'
zstyle ':completion:*' use-cache yes

setopt auto_menu
setopt auto_list
setopt auto_pushd
setopt correct
setopt globdots
setopt magic_equal_subst
setopt auto_cd
setopt auto_param_slash
setopt extended_history
setopt share_history
setopt ignore_eof
setopt no_beep
setopt no_flow_control
setopt numeric_glob_sort
setopt hist_ignore_space

bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^H' vi-backward-char
bindkey '^L' vi-forward-char
bindkey '^O' backward-delete-char
bindkey '^U' kill-whole-line
bindkey '^W' backward-kill-word
bindkey '^B' clear-screen
bindkey "^F" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
bindkey '^[[3~' delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey '^[q' push-line
bindkey -r '^['

stty stop undef

function ^M()
{
	zle accept-line
	if [[ -z $BUFFER ]]; then
		echo
		l
	fi
}
zle -N ^M
bindkey '^M' ^M

function ^V()
{
	if [[ ${BUFFER:0:2} = 'v ' ]]; then
		BUFFER=${BUFFER:2}
	else
		BUFFER='v '$BUFFER
	fi
	CURSOR='$'
}
zle -N ^V
bindkey '^V' ^V

function ^Z()
{
	if [[ -n $(jobs) ]]; then
		zle push-line
		BUFFER=' fg'
		zle accept-line
	fi
}
zle -N ^Z
bindkey '^Z' ^Z

function ^I()
{
	if [[ -z $BUFFER ]]; then
		BUFFER='./'
		CURSOR='$'
		zle expand-or-complete
	else
		zle expand-or-complete
	fi
}
zle -N ^I
bindkey '^I' ^I

function chpwd()
{
	l
}

if type wpa_supplicant &> /dev/null; then
	wifi()
	{
		if [[ $# != 3 ]]; then
			echo 'Usage: '$0' <interface> <essid> <key>'
			return
		fi

		rm -rf /run/wpa_supplicant
		killall wpa_supplicant
		killall dhcpcd
		ip link set $1 up
		iw $1 connect $2
		wpa_supplicant -B -D wext -i $1 -c <(echo "\
		ctrl_interface=/run/wpa_supplicant
		ap_scan=1
		network={
			ssid=\"$2\"
			key_mgmt=WPA-PSK
			proto=WPA WPA2
			pairwise=CCMP TKIP
			group=CCMP TKIP
			psk=\"$3\"
		}")
		dhcpcd $1
	}
fi

if [ -e /sys/class/backlight/intel_backlight/brightness ]; then
	brightness()
	{
		if [[ $# != 1 ]]; then
			echo 'Usage: '$0' <value>'
			return
		fi

		echo $1 > /sys/class/backlight/intel_backlight/brightness
	}
fi

if type ip &> /dev/null; then
	chmac()
	{
		if [[ $# != 2 ]]; then
			echo 'Usage: '$0' <interface> <address>'
			return
		fi

		ip link set $1 down
		ip link set $1 address $2
		ip link set $1 up
	}
fi

function extract()
{
	case $1 in
		*.tar) tar xvf $1;;
		*.tar.gz|*.tgz) tar xzvf $1;;
		*.gz) gzip -cd $1 > ${1:r};;
		*.tar.bz2|*.tbz) tar xjvf $1;;
		*.bz2) bzip2 -cd $1 > ${1:r};;
		*.tar.xz) tar Jxvf $1;;
		*.xz) xz -cd $1 > ${1:r};;
		*.zip) unzip $1;;
		*.rar) unrar x $1;;
	esac
}

if [[ -z $TMUX ]]; then
	if ! tmux attach; then
		tmux
	fi
fi

if [ ! -f ~/.zshrc.zwc -o ~/.zshrc -nt ~/.zshrc.zwc ]; then
	zcompile ~/.zshrc
fi
