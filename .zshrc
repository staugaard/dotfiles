ZSH=$HOME/.oh-my-zsh
ZSH_THEME="staugaard"
DISABLE_AUTO_UPDATE="true"
DISABLE_LS_COLORS="true"

plugins=(git bundler brew gem capistrano zendesk staugaard vend)

export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"

source $ZSH/oh-my-zsh.sh

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && source ~/.localrc

export EDITOR='micro'

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

# added by travis gem
[ -f /Users/staugaard/.travis/travis.sh ] && source /Users/staugaard/.travis/travis.sh

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" --no-use  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

eval $(thefuck --alias)
eval "$(starship init zsh)"
