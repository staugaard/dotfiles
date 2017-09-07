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
# BEGIN DOCKER-IMAGES
source /Users/staugaard/code/zendesk/docker-images/dockmaster/zdi.sh
# END DOCKER-IMAGES
fi

# added by travis gem
[ -f /Users/staugaard/.travis/travis.sh ] && source /Users/staugaard/.travis/travis.sh

export NVM_DIR="$HOME/.nvm"
[ -f /usr/local/opt/nvm/nvm.sh ] && source /usr/local/opt/nvm/nvm.sh
