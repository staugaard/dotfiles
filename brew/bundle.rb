#!/usr/bin/env ruby

brewfile = File.expand_path('Brewfile', File.dirname(__FILE__))

puts "Installing homebrew packages"
exec "brew bundle #{brewfile}"