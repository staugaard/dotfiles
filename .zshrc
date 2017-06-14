ZSH=$HOME/.oh-my-zsh
ZSH_THEME="staugaard"
DISABLE_AUTO_UPDATE="true"
DISABLE_LS_COLORS="true"

plugins=(git bundler brew gem capistrano zendesk staugaard)

export PATH="$HOME/bin:/usr/local/bin:$PATH"

source $ZSH/oh-my-zsh.sh

# use .localrc for settings specific to one system
[[ -f ~/.localrc ]] && source ~/.localrc

export EDITOR='subl -w'

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

if [ -f /Users/staugaard/code/zendesk/docker-images/dockmaster/zdi.sh ]
then
# ADDED BY DOCKER-IMAGES
source /Users/staugaard/code/zendesk/docker-images/dockmaster/zdi.sh
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# added by travis gem
[ -f /Users/staugaard/.travis/travis.sh ] && source /Users/staugaard/.travis/travis.sh

export NVM_DIR="/Users/staugaard/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
