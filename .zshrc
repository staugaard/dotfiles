ZSH=$HOME/.oh-my-zsh
DISABLE_AUTO_UPDATE="true"
DISABLE_LS_COLORS="true"

plugins=(git bundler brew chruby gem nvm direnv starship thefuck zendesk staugaard vend)

export PATH="$HOME/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

source $ZSH/oh-my-zsh.sh

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && source ~/.localrc

export EDITOR='micro'
