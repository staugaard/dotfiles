c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

# autocorrect is more annoying than helpful
unsetopt correct_all

# add plugin's bin directory to path
export PATH="$(dirname $0)/bin:$PATH"

set_iterm_color() {
  osascript -e "tell application \"iTerm\"\
    to tell the current terminal\
      to tell the current session\
        to set the background color to $1"
}

set_iterm_profile() {
  # https://groups.google.com/forum/?fromgroups#!topic/iterm2-discuss/bLz7kpMjb28
  echo -e "\033]50;SetProfile=$1\a"
}

light() {
  set_iterm_profile "light_solarized"
}

dark() {
  set_iterm_profile "dark_solarized"
}

ssh() {
  set_iterm_profile "ssh"

  /usr/bin/ssh "$@"

  set_iterm_profile "Default"
}

sudo() {
  set_iterm_profile "sudo"

  /usr/bin/sudo "$@"

  set_iterm_profile "Default"
}

alias bundle-grep="bundle exec ruby -e 'puts $:' | xargs grep -r"

alias pbr="git pull && (bundle check || bundle install --local) && touch tmp/restart.txt && echo 'Restarted'"
