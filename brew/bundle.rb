#!/usr/bin/env ruby

if `which brew`.empty?
  puts "Installing homebrew"
  system 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
end

puts "Installing homebrew packages"
system "brew install git htop wget chruby ruby-install autojump thefuck micro"

if File.exist?('/Users/staugaard/code/zendesk/zdi/dockmaster/zdi.sh')
  system "brew install imagemagick"
end
