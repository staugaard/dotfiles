#!/usr/bin/env ruby

abort if RUBY_PLATFORM !~ /linux/
abort if `which apt`.empty?

puts "Installing dnf packages"
system 'sudo apt install htop wget thefuck -y'

# system "brew install ctop chruby ruby-install autojump go nvm yarn"

# puts "Installing homebrew casks"
# system "brew install --cask 1password visual-studio-code slack authy docker istat-menus shift postman brave-browser querious"

# system "brew install vektra/tap/mockery"
# system "brew upgrade mockery"
