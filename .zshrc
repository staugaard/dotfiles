export EDITOR='micro'

mkdir -p ~/.zsh
export PATH="${HOME}/.zsh:$PATH"

[[ -f ~/.zsh/oh-my-posh ]] || curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.zsh
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config ~/.zsh/oh-my-posh-theme.json)"
fi

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

[[ -a ~/.zsh/zsh-autosuggestions ]] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -a ~/.zsh/zsh-syntax-highlighting ]] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ---- Eza (better ls) -----
alias ls="eza --icons=always"

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
alias cd="z"

# This stuff here is needed by the `c` command below in order to autocomplete
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit
compinit

# c function to go straight to Code
c() { cd ~/Code/$1; }
_c() { _files -W ~/Code -/; }
compdef _c c

source $HOME/.zsh/zendesk.zsh
[[ -f ~/.localrc ]] && source ~/.localrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
