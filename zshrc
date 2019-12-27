# Returns whether the given command is executable or aliased.
 _has() {
  return $( whence $1 >/dev/null )
}

# Eval virtual env
eval "$(pyenv init -)"
eval "$(nodenv init -)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.vendor/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export EDITOR='vim -u NONE'
export KEYTIMEOUT=1
bindkey -v

# Better searching in command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd "^V" edit-command-line

bindkey "^G" fzf-cd-widget

source ~/.aliases

# fzf + ag configuration
if _has fzf && _has ag; then
  export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS="
  --color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
  --color info:108,prompt:109,spinner:108,pointer:168,marker:168
  --ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'
  "
fi

fzf-vim-widget() {
    local fname="$(__fsel)"
    local fname_no_whitespace="$(echo -e "${fname}" | tr -d '[:space:]')"
    vim "$fname_no_whitespace"
}

zle     -N   fzf-vim-widget
bindkey '^V' fzf-vim-widget
