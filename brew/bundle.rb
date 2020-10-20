#!/usr/bin/env ruby

require 'socket'

if `which brew`.empty?
  puts "Installing homebrew"
  system '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"'
end

puts "Installing homebrew packages"
system "brew install git htop ctop wget chruby ruby-install autojump thefuck micro go nvm yarn"

puts "Installing homebrew casks"
system "brew cask install 1password visual-studio-code slack authy docker istat-menus shift postman google-chrome querious"

if File.exist?('/Users/staugaard/code/zendesk/zdi/dockmaster/zdi.sh')
  system "brew install imagemagick"
elsif Socket.gethostname == 'MickS-C02DF0TGMD6V'
  system "brew cask install aws-vault goland"
  system "brew install vektra/tap/mockery"
  system "brew upgrade mockery"
end
