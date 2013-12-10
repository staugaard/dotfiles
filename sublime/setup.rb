#!/usr/bin/env ruby

unless File.exist?('/Applications/Sublime Text.app')
  puts "Installing Sublime Text 3"
  system 'hdiutil mount http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20Build%203047.dmg'
  system 'cp -r /Volumes/Sublime\ Text/Sublime\ Text.app /Applications'
  system 'hdiutil unmount /Volumes/Sublime\ Text'
end

puts "Symlinking #{ENV['HOME']}/bin/subl"
system 'mkdir -p $HOME/bin'
system 'ln -sf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" $HOME/bin/subl'
