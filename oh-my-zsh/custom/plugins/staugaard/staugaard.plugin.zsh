c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

# autocorrect is more annoying than helpful
unsetopt correct_all

# add plugin's bin directory to path
export PATH="$(dirname $0)/bin:$PATH"

set_terminal_settings() {
  osascript -e "tell application \"Terminal\"\
    to set current settings of selected tab of front window to settings set \"$1\""
}

light() {
  set_terminal_settings "Solarized Light"
}

dark() {
  set_terminal_settings "Solarized Dark"
}

ssh() {
  set_terminal_settings "Solarized Light"

  /usr/bin/ssh "$@"

  set_terminal_settings "Solarized Dark"
}

sudo() {
  set_terminal_settings "Red Sands"

  /usr/bin/sudo "$@"

  set_terminal_settings "Solarized Dark"
}

alias clear-dev-logs="cat /dev/null >| ~/code/**/log/*.log"

alias bundle-grep="bundle exec ruby -e 'puts $:' | xargs grep -r"

alias pb="git pull && (bundle check || bundle install --local)"
alias br="(bundle check || bundle install --local) && touch tmp/restart.txt && echo 'Restarted'"
alias pbr="git pull && br"

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
