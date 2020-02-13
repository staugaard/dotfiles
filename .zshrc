ZSH=$HOME/.oh-my-zsh
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind git-remotebranch)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator)
ZSH_THEME="powerlevel9k"
# ZSH_THEME="staugaard"
DISABLE_AUTO_UPDATE="true"
DISABLE_LS_COLORS="true"

plugins=(git bundler brew gem capistrano zendesk staugaard vend)

export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH"

source $ZSH/oh-my-zsh.sh

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && source ~/.localrc

export EDITOR='subl -w'

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

# added by travis gem
[ -f /Users/staugaard/.travis/travis.sh ] && source /Users/staugaard/.travis/travis.sh

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
