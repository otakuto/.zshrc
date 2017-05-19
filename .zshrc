export PS1='%F{yellow}%n%f@%F{magenta}%m%f:%F{cyan}%d%f%(!.#.$)'
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export HISTFILE=~/.zsh/.zsh_history
export HISTSIZE=65536
export SAVEHIST=65536

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -halF --time-style=long-iso'
alias clang='clang -std=c11'
alias clang++='clang++ -std=c++1z -stdlib=libc++'

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
setopt magic_equal_subst
setopt auto_cd
setopt auto_param_slash
setopt extended_history
setopt share_history
setopt no_beep

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^[[3~' delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
