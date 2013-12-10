ZSH=$HOME/.oh-my-zsh
ZSH_THEME="staugaard"
DISABLE_AUTO_UPDATE="true"
DISABLE_LS_COLORS="true"

plugins=(git bundler brew gem capistrano staugaard)

export PATH="$HOME/bin:/usr/local/bin:$PATH"
export EDITOR='subl -w'

source $ZSH/oh-my-zsh.sh

source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
