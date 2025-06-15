if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi 

export EDITOR='micro'

mkdir -p ~/.zsh
export PATH="${HOME}/.zsh:$PATH"

[[ -f ~/.zsh/oh-my-posh ]] || curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.zsh
if [[ "$TERM_PROGRAM" != "Apple_Terminal" && -z "$SSH_CONNECTION" ]]; then
  eval "$(oh-my-posh init zsh --config ~/.zsh/oh-my-posh-theme.json)"
fi

if [[ -n "$SSH_CONNECTION" ]]; then
    stty -echo
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

if [[ -z "$SSH_CONNECTION" ]]; then
  [[ -a ~/.zsh/zsh-autosuggestions ]] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

  [[ -a ~/.zsh/zsh-syntax-highlighting ]] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

# Only alias builtins in interactive shells
if [[ $- == *i* ]]; then
  # ---- Eza (better ls) -----
  alias ls="eza --icons=always"
  alias cd="z"
fi

# This stuff here is needed by the `c` command below in order to autocomplete
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit
compinit

# c function to go straight to Code
c() { cd ~/Code/$1; }
_c() { _files -W ~/Code -/; }
compdef _c c

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm use --silent

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

eval $(thefuck --alias)

export PATH="/usr/local/go/bin:${HOME}/go/bin:$PATH"

alias git-cleanup="git branch --merged | egrep -v '(^\*|main|master|staging|production)' | xargs git branch -d"

export GOPRIVATE=github.com/subduction-dev

[[ -f ~/.localrc ]] && source ~/.localrc
