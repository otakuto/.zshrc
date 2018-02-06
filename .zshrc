export PS1='${vcs_info_msg_0_}${vcs_info_msg_0_:+'$'\n}${job_info_msg}${job_info_msg:+'$'\n}%F{yellow}%n%f@%F{magenta}%m%f:%F{cyan}%d%f%(!.#.$)'
export PATH="/usr/lib/ccache/bin/:${PATH}"
export WORDCHARS='*?_-[]~=&;!#$%^(){}<>.'
export HISTFILE=~/.zsh/.zsh_history
export HISTSIZE=65536
export SAVEHIST=65536
export LESSHISTFILE=-
export EDITOR=nvim

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias l='ls -halF --time-style=long-iso'
alias xxd='xxd -g1'
alias xxr='xxd -g1 -r'
alias du='du -sh'
alias v='nvim'
alias vp='nvim -p'
alias v-='nvim -'
alias ext='extract'
alias clang='clang -std=c11 -Wall'
alias clang++='clang++ -std=c++1z -stdlib=libc++ -Wall'

alias dockerrminone='docker rmi $(docker images | grep \<none\> | awk "{print \$3}")'
alias dockerrmall='docker rm $(docker ps -a --format={{.Names}})'
alias dockerkillall='docker kill $(docker ps -a --format={{.Names}})'

alias gst='git stash'
alias gsp='git stash pop'
alias gl='git pull'
alias gp='git push'
alias gcl='git clone'
alias gco='git checkout'
alias gcob='git checkout -b'
function gcm()
{
	git commit -m "${*}"
}
function gcm!()
{
	git commit --amend -m "${*}"
}
alias ga='git add'
alias gap='git add -p'
alias gd='git diff'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

alias fd='ag -g'

alias sudo='sudo '
alias doas='doas '

alias -s c='(){out=${1:h}/a.out && clang $1 -o $out && shift && $out $@}'
alias -s cpp='(){out=${1:h}/a.out && clang++ $1 -o $out && shift && $out $@}'
alias -s py='python'
alias -s hs='runhaskell'
alias -s png='feh'
alias -s gif='feh'
alias -s jpg='feh'
alias -s tex='(){ptex2pdf -l $1 && if pgrep firefox &> /dev/null; then firefox $1:r.pdf; fi}'
alias -s diag='(){blockdiag $1 && feh $1:r.png}'

zmodload zsh/complist

autoload -U compinit && compinit -d ~/.zsh/.zcompdump
autoload -U colors && colors
autoload -U history-search-end
autoload -Uz vcs_info

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z} r:|[-_.]=**'
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors '${LS_COLORS}'
zstyle ':completion:*' use-cache yes
zstyle ':vcs_info:*' formats '%F{green}%s:[%b]%f'
zstyle ':vcs_info:*' actionformats '%s][* %F{green}%b%f(%F{red}%a%f)'

setopt auto_menu
setopt auto_list
setopt auto_pushd
setopt correct
setopt globdots
setopt magic_equal_subst
setopt auto_cd
setopt auto_param_slash
setopt ignore_eof
setopt no_beep
setopt no_flow_control
setopt numeric_glob_sort
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt share_history
setopt extended_history
setopt inc_append_history
setopt prompt_subst
setopt always_last_prompt

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
bindkey '^F' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
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

for i in {1..9}
{
	eval\
	"
	function ^\[$i()
	{
		if jobs %$i &> /dev/null; then
			zle push-line
			BUFFER=' fg %$i'
			zle accept-line
		fi
	}
	zle -N ^\[$i
	bindkey '^[$i' ^\[$i
	"
}

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

function ^T()
{
	case ${BUFFER:0:1} in
		' ')
		BUFFER=${BUFFER:1};;
		*)
		BUFFER=' '$BUFFER;;
	esac
	zle end-of-line
}
zle -N ^T
bindkey '^T' ^T

function ^V()
{
	local space=''
	if [[ ${BUFFER:0:1} == ' ' ]] then
		BUFFER=${BUFFER:1}
		space=' '
	fi
	case ${BUFFER:0:2} in
		'v ')
		BUFFER=${space}${BUFFER:2};;
		'l ')
		BUFFER=${space}'v '${BUFFER:2};;
		*)
		BUFFER=${space}'v '$BUFFER;;
	esac
	zle end-of-line
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
		zle end-of-line
	fi
	zle expand-or-complete
}
zle -N ^I
bindkey '^I' ^I

function ^G()
{
	local space=''
	if [[ ${BUFFER:0:1} == ' ' ]] then
		BUFFER=${BUFFER:1}
		space=' '
	fi
	case ${BUFFER:0:2} in
		'l ')
		BUFFER=${space}${BUFFER:2};;
		'v ')
		BUFFER=${space}'l '${BUFFER:2};;
		*)
		BUFFER=${space}'l '$BUFFER;;
	esac
	zle end-of-line
}
zle -N ^G
bindkey '^G' ^G

function zshaddhistory()
{
	whence ${${(z)1}[1]} >| /dev/null || return 1
}

function chpwd()
{
	l
}

function precmd()
{
	vcs_info
	job_info
}

function job_info()
{
	if [[ -n $(jobs) ]]; then
		job_info_msg=$fg_bold[green]$(jobs -p | sed -e '/^(.*)$/d' -e 's/\[\([0-9]\+\)\]  \([-+ ]\) \([0-9]\+\) \([a-z]\+\)\( (.*)\)\?  \(.*\)/\1:[\6]\2/' | tr '\n' ' ')$fg_no_bold[default]
	else
		job_info_msg=''
	fi
}

if ! type ag &> /dev/null; then
	function ag()
	{
		grep -n -i $1 -r .
	}

	unalias fd
	function fd()
	{
		find -iname '*'$1'*' -type f | grep -v '/\.' | sed -e s@./@@
	}
fi

if [ -e /sys/class/backlight/intel_backlight/brightness ]; then
	function brightness()
	{
		if [[ $# != 1 ]]; then
			echo 'Usage: '$0' <value>'
			return
		fi

		sudo zsh -c "echo $(($(cat /sys/class/backlight/intel_backlight/max_brightness) * $1 / 100)) > /sys/class/backlight/intel_backlight/brightness"
	}
fi

function offdisplay()
{
	xset dpms force off ||
	setterm -blank force
}

if type ip &> /dev/null; then
	function chmac()
	{
		if [[ $# != 2 ]]; then
			echo 'Usage: '$0' <interface> <address>'
			return
		fi

		sudo zsh -c\
		"
		ip link set $1 down
		ip link set $1 address $2
		ip link set $1 up
		"
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

function gclg()
{
	git clone https://github.com/"${@}"
}

if [[ -z $TMUX ]]; then
	if tmux list-sessions &> /dev/null; then
		tmux attach
	else
		tmux
	fi
fi

if [ ! -e ~/.zsh ]; then
	mkdir ~/.zsh
fi

if [ ! -f ~/.zshrc.zwc -o ~/.zshrc -nt ~/.zshrc.zwc ]; then
	zcompile ~/.zshrc
fi
