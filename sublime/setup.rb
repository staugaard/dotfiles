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

puts "Symlinking Sublime Text Settings"
packages_path = "#{ENV['HOME']}/Library/Application Support/Sublime Text 3/Packages"
system "mkdir -p '#{packages_path}/User'"
['Staugaard.tmTheme', 'Preferences.sublime-settings'].each do |file|
  system "ln -sf #{File.expand_path(file, File.dirname(__FILE__))} '#{packages_path}/User'"
end

{
  'TrailingSpaces' => 'SublimeText/TrailingSpaces'
}.each do |name, source|
  unless File.exist?("#{packages_path}/#{name}/.git")
    puts "Installing the #{name} Sublime Text Package"
    system "git clone http://github.com/#{source} '#{packages_path}/#{name}'"
  end
end
