typeset -U path
setopt AUTO_CD INTERACTIVE_COMMENTS NO_BEEP HIST_VERIFY

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS SHARE_HISTORY

# vi mode
bindkey -v
export KEYTIMEOUT=10

# prompt
autoload -U colors && colors
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

setopt prompt_subst

zstyle ':vcs_info:git:*' formats '(%F{magenta}%b%f)'

PROMPT='%F{cyan}%n%f@%F{blue}%m%f %F{yellow}%~%f ${vcs_info_msg_0_}%# '
RPROMPT='%F{green}[%?]%f'

# completion
autoload -Uz compinit && compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
setopt COMPLETE_IN_WORD

# plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# aliases
alias df="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias la="eza -lah --group-directories-first"
alias tree="eza --tree"
alias vim="nvim"

# ghcup-env
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

# path
path=(/usr/pgadmin4/bin $HOME/.cargo/bin $path)
export PATH
