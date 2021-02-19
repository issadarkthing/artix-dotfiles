source ~/.profile

# check large size in git repository
checksize() {
	git rev-list --objects --all \
		| git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
		| awk '/^blob/ {print substr($0,6)}' \
		| sort --numeric-sort --key=2 \
		| cut --complement --characters=8-40 \
		| numfmt --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest
}

zp() {

	preview_command='ls $(awk "{print \$2}" <<< {})'
	# sort flags
	# -g = enables sort by floating point
	# -r = reverse
	# -k = column to sort
	# list and sort path according to highest value and ends prioritize end match
	custom_path="z | sort -grk 1 | \
		fzf --tiebreak='index' --preview='$preview_command' --preview-window=right:30%"
	# if argument given, use that as query
	if [[ -n $1 ]]; then
		zpath=$(eval "$custom_path" -q $1)
	else
		zpath=$(eval "$custom_path")
	fi
	
	# cd into path if not empty string
	# otherwise zsh will cd into home dir if empty string
	[[ -n $zpath ]] && cd "$(echo "${zpath#* }" | xargs)"
}

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

h=$(date +%H)

if [ $h -lt 12 ]; then
  echo -e "${BLUE}Good morning terra!${NC}"
elif [ $h -lt 18 ]; then
  echo -e "${GREEN}Good afternoon terra!${NC}"
else
  echo -e "${YELLOW}Good evening terra!${NC}"
fi

zstyle ':completion:*' menu select
bindkey '\e[B' history-beginning-search-forward
bindkey '\e[A' history-beginning-search-backward
zmodload zsh/complist
# use the vi navigation keys in menu completion
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'h' vi-backward-char
bindkey "^?" backward-delete-char
bindkey -e
# use emacs keybinds

setopt extended_glob
# to enable wildcard negation
setopt pushdminus
setopt pushd_ignore_dups
setopt auto_pushd
# directory stack
setopt share_history          # share command history data
setopt hist_verify            # show command with history expansion to user before running it
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt extended_history       # record timestamp of command in HISTFILE
## History command configuration
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"

# ============== ZPLUG ==================
source ~/.zplug/init.zsh
# Install plugins if there are plugins that have not been installed
# Then, source plugins and add commands to $PATH
if ! zplug check --verbose; then
	zplug install
fi

zplug "rupa/z", use:z.sh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
# auto pair in terminal
zplug "hlissner/zsh-autopair", defer:2
zplug load

alias ytdl="youtube-dl"
alias dg="dragon-drag-and-drop -x"
alias zt="zathura --fork 2>/dev/null"
alias zr="zaread"
alias lz="lazygit"
alias -g ......='../../../../..'
alias -g .....='../../../..'
alias -g ....='../../..'
alias -g ...='../..'
alias ls="logo-ls"

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
setopt PROMPT_SUBST
export PROMPT='%F{blue}<%~> %F{green} 
λ%F{yellow}$(parse_git_branch)%F{green} ->%f '


[ -f ~/.key-bindings.zsh ] && source ~/.key-bindings.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
