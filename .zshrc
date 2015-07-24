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
export ANDROID_HOME=/usr/local/opt/android-sdk

if [ -f /Users/staugaard/code/zendesk/docker-images/dockmaster/zdi.sh ]
then
# ADDED BY DOCKER-IMAGES
source /Users/staugaard/code/zendesk/docker-images/dockmaster/zdi.sh
export MYSQL_URL=mysql://admin:123456@$DOCKER_HOST_IP:3306/zendesk_development
fi
