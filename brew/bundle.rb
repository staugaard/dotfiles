#!/usr/bin/env ruby

brewfile = File.expand_path('Brewfile', File.dirname(__FILE__))

if ENV['BOXEN_HOME']
  puts "Skipping Homebrew as Boxen is present"
  exit
end

if `which brew`.empty?
  puts "Installing home"
  system 'ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"'
else
  puts "Updating homebrew"
  system 'brew update'
end

puts "Installing homebrew packages"
exec "brew bundle #{brewfile}"
