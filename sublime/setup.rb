#!/usr/bin/env ruby

puts "Symlinking #{ENV['HOME']}/bin/subl"
system 'mkdir -p $HOME/bin'
system 'ln -sf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" $HOME/bin/subl'
