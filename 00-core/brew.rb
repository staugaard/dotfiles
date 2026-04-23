#!/usr/bin/env ruby

abort if RUBY_PLATFORM =~ /linux/

if `which brew`.empty?
  puts "Installing homebrew"
  system '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"'
end

puts "Installing homebrew packages"
system "brew install git htop ctop wget autojump thefuck micro go nvm yarn direnv gh"

puts "Installing homebrew casks"
system "brew install --cask istat-menus"

system "brew install vektra/tap/mockery"
system "brew upgrade mockery"

puts "Installing GitHub CLI extensions"
system "gh extension install seachicken/gh-poi"
