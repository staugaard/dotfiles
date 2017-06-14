#!/usr/bin/env ruby

brewfile = File.expand_path('Brewfile', File.dirname(__FILE__))

if `which brew`.empty?
  puts "Installing homebrew"
  system 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
else
  puts "Upgrading homebrew"
  system "brew update"
end

puts "Installing homebrew packages"
system "brew install git"
system "brew install htop"
system "brew install ios-sim"
system "brew install wget"
system "brew install chruby"
system "brew install ruby-install"

if File.exist?('/Users/staugaard/code/zendesk/docker-images/dockmaster/zdi.sh')
  system "brew install imagemagick"
end
