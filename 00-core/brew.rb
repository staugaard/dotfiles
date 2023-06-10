#!/usr/bin/env ruby

abort if RUBY_PLATFORM =~ /linux/

if `which brew`.empty?
  puts "Installing homebrew"
  system '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"'
end

puts "Installing homebrew packages"
system "brew install git htop ctop wget chruby ruby-install autojump thefuck micro go nvm yarn direnv"

puts "Installing homebrew casks"
system "brew install --cask 1password visual-studio-code slack authy docker istat-menus shift postman brave-browser querious"

system "brew install vektra/tap/mockery"
system "brew upgrade mockery"

if File.exist?('/Users/staugaard/Code/zendesk/zdi/dockmaster/zdi.sh')
  system "brew install imagemagick"
end
