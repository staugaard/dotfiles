#!/usr/bin/env ruby

puts "Symlinking micro configuration"
system 'mkdir -p $HOME/.config/micro'
system "ln -sf '#{File.expand_path('settings.json', File.dirname(__FILE__))}' $HOME/.config/micro"
