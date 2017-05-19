export PS1='%F{yellow}%n%f@%F{magenta}%m%f:%F{cyan}%d%f%(!.#.$)'
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export HISTFILE=~/.zsh/.zsh_history
export HISTSIZE=65536
export SAVEHIST=65536

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias l='ls -halF --time-style=long-iso'
alias ll=l
alias clang='clang -std=c11 -Wall'
alias clang++='clang++ -std=c++1z -stdlib=libc++ -Wall'

alias gst='git status'
alias gp='git push'
alias gca='git commit -a -m'
alias gca!='git commit -a --amend -m'
alias ga='git add'

zmodload zsh/complist

autoload -U compinit && compinit -d ~/.zsh/.zcompdump
autoload -U colors && colors
autoload history-search-end

zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors '${LS_COLORS}'

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

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^H' vi-backward-char
bindkey '^L' vi-forward-char
bindkey '^O' backward-delete-char
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

function chpwd()
{
	l;
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
		ip link set $1 down
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

if [[ -z $TMUX ]]; then
	if ! tmux attach; then
		tmux
	fi
fi

