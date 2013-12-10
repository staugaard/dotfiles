c() { cd ~/code/$1; }
_c() { _files -W ~/code -/; }
compdef _c c

# autocorrect is more annoying than helpful
unsetopt correct_all

# add plugin's bin directory to path
export PATH="$(dirname $0)/bin:$PATH"
